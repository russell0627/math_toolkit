import 'dart:async';
import 'dart:isolate';
import 'dart:math' as math;

enum SignalType { prng, xorPulse, cellularRule30 }

class SignalResult {
  final List<int> bytes;
  final List<bool> patternMatches;
  final SignalType type;
  final DateTime timestamp;

  SignalResult({
    required this.bytes,
    required this.patternMatches,
    required this.type,
    required this.timestamp,
  });
}

class SignalRequest {
  final SignalType type;
  final int byteCount;
  final String? pattern;
  final List<int>? seed;

  SignalRequest({
    required this.type,
    required this.byteCount,
    this.pattern,
    this.seed,
  });
}

class SignalProcessor {
  final int poolSize;
  final List<Isolate> _isolates = [];
  final List<SendPort> _sendPorts = [];
  final List<ReceivePort> _receivePorts = [];
  final _resultsController = StreamController<SignalResult>.broadcast();
  int _nextIsolateIndex = 0;

  Stream<SignalResult> get results => _resultsController.stream;

  SignalProcessor({this.poolSize = 4});

  Future<void> init() async {
    for (int i = 0; i < poolSize; i++) {
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn(_processorEntry, receivePort.sendPort);
      _receivePorts.add(receivePort);
      _isolates.add(isolate);

      final complexInit = Completer<SendPort>();
      receivePort.listen((message) {
        if (message is SendPort) {
          complexInit.complete(message);
        } else if (message is SignalResult) {
          _resultsController.add(message);
        }
      });

      _sendPorts.add(await complexInit.future);
    }
  }

  void requestData(SignalRequest request) {
    if (_sendPorts.isEmpty) return;
    _sendPorts[_nextIsolateIndex].send(request);
    _nextIsolateIndex = (_nextIsolateIndex + 1) % _sendPorts.length;
  }

  void dispose() {
    for (final isolate in _isolates) {
      isolate.kill(priority: Isolate.immediate);
    }
    for (final port in _receivePorts) {
      port.close();
    }
    _resultsController.close();
  }

  static void _processorEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    final random = math.Random();
    List<int> cellularState = List.generate(256, (_) => random.nextBool() ? 1 : 0);

    receivePort.listen((message) {
      if (message is SignalRequest) {
        final List<int> bytes = [];
        final List<bool> patternMatches = [];

        RegExp? regex;
        if (message.pattern != null && message.pattern!.isNotEmpty) {
          final pattern = message.pattern!.replaceAll('*', '.*');
          try {
            regex = RegExp(pattern); // Partial match for signals
          } catch (_) {}
        }

        switch (message.type) {
          case SignalType.prng:
            for (int i = 0; i < message.byteCount; i++) {
              bytes.add(random.nextInt(256));
            }
            break;
          case SignalType.xorPulse:
            final seed = message.seed ?? [42, 101];
            for (int i = 0; i < message.byteCount; i++) {
              bytes.add((random.nextInt(256) ^ seed[i % seed.length]) % 256);
            }
            break;
          case SignalType.cellularRule30:
            for (int i = 0; i < message.byteCount; i++) {
              // Rule 30 logic
              final newState = List<int>.filled(cellularState.length, 0);
              int byteVal = 0;
              for (int j = 0; j < cellularState.length; j++) {
                final left = cellularState[(j - 1 + cellularState.length) % cellularState.length];
                final center = cellularState[j];
                final right = cellularState[(j + 1) % cellularState.length];

                // Rule 30: 001, 010, 011, 100 -> 1
                final next = (left ^ (center | right)) == 1 ? 1 : 0;
                newState[j] = next;
                if (j < 8) byteVal |= (next << j);
              }
              cellularState = newState;
              bytes.add(byteVal % 256);
            }
            break;
        }

        // Pattern matching on Hex representation
        for (final b in bytes) {
          final hex = b.toRadixString(16).padLeft(2, '0').toUpperCase();
          patternMatches.add(regex?.hasMatch(hex) ?? false);
        }

        mainSendPort.send(
          SignalResult(
            bytes: bytes,
            patternMatches: patternMatches,
            type: message.type,
            timestamp: DateTime.now(),
          ),
        );
      }
    });
  }
}

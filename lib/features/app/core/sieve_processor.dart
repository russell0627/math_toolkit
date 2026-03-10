import 'dart:async';
import 'dart:isolate';

/// Result packet from the [SieveProcessor]
class SieveResult {
  final BigInt number;
  final bool isPrime;
  final bool isPerfect;
  final bool isPiFragment;
  final bool isPatternMatch;
  final List<BigInt>? divisors; // Only populated for X-Ray requests
  final int sessionId;

  SieveResult({
    required this.number,
    required this.isPrime,
    required this.isPerfect,
    required this.isPiFragment,
    this.isPatternMatch = false,
    this.divisors,
    required this.sessionId,
  });
}

/// Request packet for the [SieveProcessor]
class SieveRequest {
  final List<BigInt> numbers;
  final bool includeDivisors;
  final List<int> currentPiDigits;
  final String? pattern;
  final int sessionId;

  SieveRequest({
    required this.numbers,
    this.includeDivisors = false,
    required this.currentPiDigits,
    this.pattern,
    required this.sessionId,
  });
}

/// A dedicated processor for offloading numerical analysis to a background isolate.
class SieveProcessor {
  final int poolSize;
  final List<SendPort?> _sendPorts = [];
  final List<Isolate?> _isolates = [];
  int _currentIsolateIndex = 0;
  final _resultsController = StreamController<SieveResult>.broadcast();

  Stream<SieveResult> get results => _resultsController.stream;

  SieveProcessor({this.poolSize = 4});

  Future<void> init() async {
    for (int i = 0; i < poolSize; i++) {
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn(_processorEntry, receivePort.sendPort);
      _isolates.add(isolate);

      receivePort.listen((message) {
        if (message is SendPort) {
          _sendPorts.add(message);
        } else if (message is SieveResult) {
          _resultsController.add(message);
        }
      });
    }
  }

  void requestAnalysis(SieveRequest request) {
    if (_sendPorts.isEmpty) return;
    // Map requests across the pool
    final port = _sendPorts[_currentIsolateIndex % _sendPorts.length];
    port?.send(request);
    _currentIsolateIndex++;
  }

  void dispose() {
    for (final isolate in _isolates) {
      isolate?.kill();
    }
    _resultsController.close();
  }

  static void _processorEntry(SendPort mainSendPort) {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    receivePort.listen((message) {
      if (message is SieveRequest) {
        RegExp? regex;
        if (message.pattern != null && message.pattern!.isNotEmpty) {
          final pattern = message.pattern!.replaceAll('*', '.*');
          try {
            regex = RegExp('^$pattern\$');
          } catch (_) {
            // Invalid pattern
          }
        }

        for (final n in message.numbers) {
          final isPrime = _checkPrime(n);
          final isPerfect = _checkPerfect(n);
          final isPi = _checkPi(n, message.currentPiDigits);
          final isPatternMatch = regex?.hasMatch(n.toString()) ?? false;
          List<BigInt>? divisors;

          if (message.includeDivisors) {
            divisors = _getDivisors(n);
          }

          mainSendPort.send(
            SieveResult(
              number: n,
              isPrime: isPrime,
              isPerfect: isPerfect,
              isPiFragment: isPi,
              isPatternMatch: isPatternMatch,
              divisors: divisors,
              sessionId: message.sessionId,
            ),
          );
        }
      }
    });
  }

  static final List<BigInt> _smallPrimes = [
    2,
    3,
    5,
    7,
    11,
    13,
    17,
    19,
    23,
    29,
    31,
    37,
    41,
    43,
    47,
    53,
    59,
    61,
    67,
    71,
    73,
    79,
    83,
    89,
    97,
    101,
    103,
    107,
    109,
    113,
    127,
    131,
    137,
    139,
    149,
    151,
    157,
    163,
    167,
    173,
    179,
    181,
    191,
    193,
    197,
    199,
  ].map((e) => BigInt.from(e)).toList();

  static bool _checkPrime(BigInt n) {
    if (n <= BigInt.one) return false;
    if (n <= BigInt.from(3)) return true;

    // Phase 1: Small Prime Filter
    for (final p in _smallPrimes) {
      if (n == p) return true;
      if (n % p == BigInt.zero) return false;
    }

    // Phase 2: Miller-Rabin Probabilistic Primality Test for large depths
    // For n < 3,317,044,064,679,887,361, it's sufficient to test a=2, 3, 5, 7, 11, 13, 17, 19, 23
    // We'll use a standard set of bases for high confidence.
    return _millerRabin(n, [2, 3, 5, 7, 11, 13, 17, 19, 23].map((e) => BigInt.from(e)).toList());
  }

  static bool _millerRabin(BigInt n, List<BigInt> bases) {
    BigInt d = n - BigInt.one;
    int s = 0;
    while (d % BigInt.two == BigInt.zero) {
      d ~/= BigInt.two;
      s++;
    }

    for (final a in bases) {
      if (a >= n) break;
      BigInt x = a.modPow(d, n);
      if (x == BigInt.one || x == n - BigInt.one) continue;

      bool composite = true;
      for (int r = 1; r < s; r++) {
        x = x.modPow(BigInt.two, n);
        if (x == n - BigInt.one) {
          composite = false;
          break;
        }
      }
      if (composite) return false;
    }
    return true;
  }

  static bool _checkPerfect(BigInt n) {
    if (n <= BigInt.one) return false;
    if (n % BigInt.two != BigInt.zero) {
      // All known perfect numbers are even.
      // Odd perfect numbers, if they exist, are > 10^1500.
      return false;
    }

    // Optimization: Harmonic Harvesting is expensive at high depth.
    // Perfect numbers follow the form 2^(p-1) * (2^p - 1) where (2^p - 1) is a Mersenne prime.
    // For general exploration, we cap trial division to maintain UI responsiveness.
    if (n > BigInt.from(1000000000000)) {
      // Specialized Mersenne check could go here, but for now we skip massive indices
      // to prevent isolate lockup.
      return false;
    }

    BigInt sum = BigInt.one;
    for (BigInt i = BigInt.two; i * i <= n; i += BigInt.one) {
      if (n % i == BigInt.zero) {
        sum += i;
        if (i * i != n) {
          sum += n ~/ i;
        }
      }
    }
    return sum == n;
  }

  static bool _checkPi(BigInt n, List<int> piDigits) {
    if (n <= BigInt.zero) return false;
    final s = n.toString();
    if (s.length > piDigits.length) return false;

    for (int i = 0; i < s.length; i++) {
      if (int.parse(s[i]) != piDigits[i]) {
        return false;
      }
    }
    return true;
  }

  static List<BigInt> _getDivisors(BigInt n) {
    List<BigInt> divisors = [];
    int count = 0;
    // Cap iterations for highly composite massive numbers
    // Trial division for divisors is O(sqrt(n)), which is impossible for 10^20
    // We only perform this for "small" large numbers.
    if (n > BigInt.from(1000000000)) {
      return [BigInt.one, n];
    }

    for (BigInt i = BigInt.one; i * i <= n; i += BigInt.one) {
      if (n % i == BigInt.zero) {
        divisors.add(i);
        if (i * i != n) {
          divisors.add(n ~/ i);
        }
        count++;
        if (count > 500) break; // Hard cap on UI report size
      }
    }
    divisors.sort();
    return divisors;
  }
}

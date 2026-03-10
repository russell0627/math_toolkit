import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

enum DiscoveryType { prime, perfect, piFragment }

class Discovery {
  final BigInt number;
  final DiscoveryType type;
  final int timestamp;
  final BigInt depth;

  Discovery({
    required this.number,
    required this.type,
    required this.timestamp,
    required this.depth,
  });

  Map<String, dynamic> toJson() => {
    'n': number.toString(),
    't': type.index,
    'ts': timestamp,
    'd': depth.toString(),
  };

  factory Discovery.fromJson(Map<String, dynamic> json) => Discovery(
    number: BigInt.parse(json['n']),
    type: DiscoveryType.values[json['t']],
    timestamp: json['ts'],
    depth: BigInt.parse(json['d']),
  );
}

class DossierService {
  static const String _fileName = 'bureau_dossier.json';
  List<Discovery> _discoveries = [];

  List<Discovery> get discoveries => List.unmodifiable(_discoveries);

  Future<void> init() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(content);
        _discoveries = decoded.map((e) => Discovery.fromJson(e)).toList();
      }
    } catch (e) {
      // Bureau Silence: Log error locally
    }
  }

  Future<void> recordDiscovery({
    required BigInt number,
    required DiscoveryType type,
    required BigInt depth,
  }) async {
    final discovery = Discovery(
      number: number,
      type: type,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      depth: depth,
    );
    _discoveries.add(discovery);
    await _save();
  }

  Future<void> _save() async {
    try {
      final file = await _getFile();
      final content = jsonEncode(_discoveries.map((e) => e.toJson()).toList());
      await file.writeAsString(content);
    } catch (e) {
      // Bureau Error Handling
    }
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> clearDossier() async {
    _discoveries.clear();
    await _save();
  }
}

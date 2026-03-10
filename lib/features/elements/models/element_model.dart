import 'package:dart_mappable/dart_mappable.dart';

part 'element_model.mapper.dart';

@MappableClass()
class BureauElement with BureauElementMappable {
  final int atomicNumber;
  final String symbol;
  final String name;
  final double atomicMass;
  final String category;
  final String electronConfiguration;
  final String appearance;
  final int x; // Position in Periodic Table Grid (1-indexed)
  final int y; // Position in Periodic Table Grid (1-indexed)

  const BureauElement({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.atomicMass,
    required this.category,
    required this.electronConfiguration,
    required this.appearance,
    required this.x,
    required this.y,
  });
}

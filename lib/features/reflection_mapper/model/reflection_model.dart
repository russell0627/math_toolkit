import 'package:dart_mappable/dart_mappable.dart';

part 'reflection_model.mapper.dart';

@MappableClass()
class ReflectionState with ReflectionStateMappable {
  final double? x;
  final double? y;

  const ReflectionState({
    this.x,
    this.y,
  });

  bool get hasInput => x != null && y != null;

  double? get reflectedX => x != null ? -x! : null;
  double? get reflectedY => y != null ? -y! : null;
}

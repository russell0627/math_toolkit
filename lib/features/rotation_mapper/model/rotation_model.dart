import 'package:dart_mappable/dart_mappable.dart';

part 'rotation_model.mapper.dart';

@MappableClass()
class RotationState with RotationStateMappable {
  final double? x;
  final double? y;

  const RotationState({
    this.x,
    this.y,
  });

  bool get hasInput => x != null && y != null;

  // CCW: (-y, x) | CW: (y, -x)
  double? get rot90CCWX => y != null ? -y! : null;
  double? get rot90CCWY => x != null ? x! : null;
  double? get rot90CWX => y != null ? y! : null;
  double? get rot90CWY => x != null ? -x! : null;

  // CCW/CW: (-x, -y)
  double? get rot180X => x != null ? -x! : null;
  double? get rot180Y => y != null ? -y! : null;

  // CCW: (y, -x) | CW: (-y, x)
  double? get rot270CCWX => y != null ? y! : null;
  double? get rot270CCWY => x != null ? -x! : null;
  double? get rot270CWX => y != null ? -y! : null;
  double? get rot270CWY => x != null ? x! : null;

  // Deprecated/Legacy aliases for painter compatibility if needed, but better to update painter
  double? get rot90X => rot90CCWX;
  double? get rot90Y => rot90CCWY;
  double? get rot270X => rot270CCWX;
  double? get rot270Y => rot270CCWY;
}

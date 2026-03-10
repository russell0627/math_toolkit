import 'package:dart_mappable/dart_mappable.dart';

part 'workbench_model.mapper.dart';

@MappableEnum()
enum MainModule {
  algebra(
    thematicTitle: 'ALGEBRAIC AUDITOR (ALG-01)',
    normalTitle: 'ALGEBRA SOLVER',
  ),
  triangle(
    thematicTitle: 'TRIANGLE SOLVER (TRI-01)',
    normalTitle: 'TRIANGLE SOLVER',
  ),
  pythagorean(
    thematicTitle: 'HYPOTENUSE VERIFICATION (PYT-02)',
    normalTitle: 'PYTHAGOREAN THEOREM',
  ),
  gridPythagorean(
    thematicTitle: 'GRID AUDIT (GRD-04)',
    normalTitle: 'COORDINATE GEOMETRY',
  );

  final String thematicTitle;
  final String normalTitle;
  const MainModule({required this.thematicTitle, required this.normalTitle});

  String getTitle(bool isThematic) => isThematic ? thematicTitle : normalTitle;
}

@MappableEnum()
enum UtilityModule {
  radical(
    thematicTitle: 'RADICAL REDUCTION (RAD-03)',
    normalTitle: 'RADICAL SIMPLIFIER',
  ),
  fraction(
    thematicTitle: 'FRACTION SIMPLIFIER',
    normalTitle: 'FRACTION SIMPLIFIER',
  ),
  calculator(
    thematicTitle: 'CALCULATOR',
    normalTitle: 'CALCULATOR',
  ),
  reflection(
    thematicTitle: 'REFLECTION MAPPER',
    normalTitle: 'REFLECTION TOOL',
  ),
  rotation(
    thematicTitle: 'ROTATION MAPPER',
    normalTitle: 'ROTATION TOOL',
  ),
  transformationSequence(
    thematicTitle: 'TRANSFORMATION SEQ',
    normalTitle: 'TRANSFORMATION SEQUENCE',
  ),
  none(
    thematicTitle: 'NONE',
    normalTitle: 'NONE',
  );

  final String thematicTitle;
  final String normalTitle;
  const UtilityModule({required this.thematicTitle, required this.normalTitle});

  String getTitle(bool isThematic) => isThematic ? thematicTitle : normalTitle;
}

@MappableEnum()
enum SubUtilityModule {
  notepad(
    thematicTitle: 'NOTEPAD',
    normalTitle: 'NOTEPAD',
  ),
  calculator(
    thematicTitle: 'CALCULATOR',
    normalTitle: 'CALCULATOR',
  ),
  none(
    thematicTitle: 'NONE',
    normalTitle: 'NONE',
  );

  final String thematicTitle;
  final String normalTitle;
  const SubUtilityModule({required this.thematicTitle, required this.normalTitle});

  String getTitle(bool isThematic) => isThematic ? thematicTitle : normalTitle;
}

@MappableClass()
class WorkbenchState with WorkbenchStateMappable {
  final MainModule activeMain;
  final UtilityModule activeUtility;
  final SubUtilityModule activeSubUtility;
  final bool isSidebarExpanded;

  const WorkbenchState({
    this.activeMain = MainModule.algebra,
    this.activeUtility = UtilityModule.radical,
    this.activeSubUtility = SubUtilityModule.none,
    this.isSidebarExpanded = true,
  });
}

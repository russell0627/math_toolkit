import 'package:dart_mappable/dart_mappable.dart';

part 'workbench_model.mapper.dart';

@MappableEnum()
enum MainModule {
  algebra('Algebraic Auditor (ALG-01)', 'Algebraic Auditor'),
  triangle('Triangle Solver (TRI-01)', 'Triangle Solver'),
  pythagorean('Hypotenuse Verification (PYT-02)', 'Pythagorean Theorem'),
  gridPythagorean('Grid Audit (GRD-04)', 'Grid Coordinate Calculation')
  ;

  final String bureauTitle;
  final String normalTitle;
  const MainModule(this.bureauTitle, this.normalTitle);

  String title({required bool useBureau}) => useBureau ? bureauTitle.toUpperCase() : normalTitle.toUpperCase();
}

@MappableEnum()
enum UtilityModule {
  radical('Radical Reduction (RAD-03)', 'Radical Simplifier'),
  fraction('Fraction Simplifier', 'Fraction Simplifier'),
  calculator('Calculator', 'Calculator'),
  reflection('Reflection Mapper', 'Coordinate Reflection'),
  rotation('Rotation Mapper', 'Coordinate Rotation'),
  transformationSequence('Transformation Seq', 'Transformation Sequence'),
  none('None', 'None')
  ;

  final String bureauTitle;
  final String normalTitle;
  const UtilityModule(this.bureauTitle, this.normalTitle);

  String title({required bool useBureau}) => useBureau ? bureauTitle.toUpperCase() : normalTitle.toUpperCase();
}

@MappableEnum()
enum SubUtilityModule {
  notepad('NOTEPAD'),
  calculator('CALCULATOR'),
  none('NONE')
  ;

  final String title;
  const SubUtilityModule(this.title);
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

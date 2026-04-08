// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'workbench_model.dart';

class MainModuleMapper extends EnumMapper<MainModule> {
  MainModuleMapper._();

  static MainModuleMapper? _instance;
  static MainModuleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MainModuleMapper._());
    }
    return _instance!;
  }

  static MainModule fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  MainModule decode(dynamic value) {
    switch (value) {
      case r'algebra':
        return MainModule.algebra;
      case r'triangle':
        return MainModule.triangle;
      case r'pythagorean':
        return MainModule.pythagorean;
      case r'gridPythagorean':
        return MainModule.gridPythagorean;
      case r'transformationSequence':
        return MainModule.transformationSequence;
      case r'slopeAudit':
        return MainModule.slopeAudit;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(MainModule self) {
    switch (self) {
      case MainModule.algebra:
        return r'algebra';
      case MainModule.triangle:
        return r'triangle';
      case MainModule.pythagorean:
        return r'pythagorean';
      case MainModule.gridPythagorean:
        return r'gridPythagorean';
      case MainModule.transformationSequence:
        return r'transformationSequence';
      case MainModule.slopeAudit:
        return r'slopeAudit';
    }
  }
}

extension MainModuleMapperExtension on MainModule {
  String toValue() {
    MainModuleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<MainModule>(this) as String;
  }
}

class UtilityModuleMapper extends EnumMapper<UtilityModule> {
  UtilityModuleMapper._();

  static UtilityModuleMapper? _instance;
  static UtilityModuleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UtilityModuleMapper._());
    }
    return _instance!;
  }

  static UtilityModule fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  UtilityModule decode(dynamic value) {
    switch (value) {
      case r'radical':
        return UtilityModule.radical;
      case r'fraction':
        return UtilityModule.fraction;
      case r'calculator':
        return UtilityModule.calculator;
      case r'reflection':
        return UtilityModule.reflection;
      case r'rotation':
        return UtilityModule.rotation;
      case r'none':
        return UtilityModule.none;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(UtilityModule self) {
    switch (self) {
      case UtilityModule.radical:
        return r'radical';
      case UtilityModule.fraction:
        return r'fraction';
      case UtilityModule.calculator:
        return r'calculator';
      case UtilityModule.reflection:
        return r'reflection';
      case UtilityModule.rotation:
        return r'rotation';
      case UtilityModule.none:
        return r'none';
    }
  }
}

extension UtilityModuleMapperExtension on UtilityModule {
  String toValue() {
    UtilityModuleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<UtilityModule>(this) as String;
  }
}

class SubUtilityModuleMapper extends EnumMapper<SubUtilityModule> {
  SubUtilityModuleMapper._();

  static SubUtilityModuleMapper? _instance;
  static SubUtilityModuleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubUtilityModuleMapper._());
    }
    return _instance!;
  }

  static SubUtilityModule fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  SubUtilityModule decode(dynamic value) {
    switch (value) {
      case r'notepad':
        return SubUtilityModule.notepad;
      case r'calculator':
        return SubUtilityModule.calculator;
      case r'none':
        return SubUtilityModule.none;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(SubUtilityModule self) {
    switch (self) {
      case SubUtilityModule.notepad:
        return r'notepad';
      case SubUtilityModule.calculator:
        return r'calculator';
      case SubUtilityModule.none:
        return r'none';
    }
  }
}

extension SubUtilityModuleMapperExtension on SubUtilityModule {
  String toValue() {
    SubUtilityModuleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<SubUtilityModule>(this) as String;
  }
}

class WorkbenchStateMapper extends ClassMapperBase<WorkbenchState> {
  WorkbenchStateMapper._();

  static WorkbenchStateMapper? _instance;
  static WorkbenchStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WorkbenchStateMapper._());
      MainModuleMapper.ensureInitialized();
      UtilityModuleMapper.ensureInitialized();
      SubUtilityModuleMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WorkbenchState';

  static MainModule _$activeMain(WorkbenchState v) => v.activeMain;
  static const Field<WorkbenchState, MainModule> _f$activeMain = Field(
    'activeMain',
    _$activeMain,
    opt: true,
    def: MainModule.algebra,
  );
  static UtilityModule _$activeUtility(WorkbenchState v) => v.activeUtility;
  static const Field<WorkbenchState, UtilityModule> _f$activeUtility = Field(
    'activeUtility',
    _$activeUtility,
    opt: true,
    def: UtilityModule.radical,
  );
  static SubUtilityModule _$activeSubUtility(WorkbenchState v) =>
      v.activeSubUtility;
  static const Field<WorkbenchState, SubUtilityModule> _f$activeSubUtility =
      Field(
        'activeSubUtility',
        _$activeSubUtility,
        opt: true,
        def: SubUtilityModule.none,
      );
  static bool _$isSidebarExpanded(WorkbenchState v) => v.isSidebarExpanded;
  static const Field<WorkbenchState, bool> _f$isSidebarExpanded = Field(
    'isSidebarExpanded',
    _$isSidebarExpanded,
    opt: true,
    def: true,
  );

  @override
  final MappableFields<WorkbenchState> fields = const {
    #activeMain: _f$activeMain,
    #activeUtility: _f$activeUtility,
    #activeSubUtility: _f$activeSubUtility,
    #isSidebarExpanded: _f$isSidebarExpanded,
  };

  static WorkbenchState _instantiate(DecodingData data) {
    return WorkbenchState(
      activeMain: data.dec(_f$activeMain),
      activeUtility: data.dec(_f$activeUtility),
      activeSubUtility: data.dec(_f$activeSubUtility),
      isSidebarExpanded: data.dec(_f$isSidebarExpanded),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WorkbenchState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WorkbenchState>(map);
  }

  static WorkbenchState fromJson(String json) {
    return ensureInitialized().decodeJson<WorkbenchState>(json);
  }
}

mixin WorkbenchStateMappable {
  String toJson() {
    return WorkbenchStateMapper.ensureInitialized().encodeJson<WorkbenchState>(
      this as WorkbenchState,
    );
  }

  Map<String, dynamic> toMap() {
    return WorkbenchStateMapper.ensureInitialized().encodeMap<WorkbenchState>(
      this as WorkbenchState,
    );
  }

  WorkbenchStateCopyWith<WorkbenchState, WorkbenchState, WorkbenchState>
  get copyWith => _WorkbenchStateCopyWithImpl<WorkbenchState, WorkbenchState>(
    this as WorkbenchState,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return WorkbenchStateMapper.ensureInitialized().stringifyValue(
      this as WorkbenchState,
    );
  }

  @override
  bool operator ==(Object other) {
    return WorkbenchStateMapper.ensureInitialized().equalsValue(
      this as WorkbenchState,
      other,
    );
  }

  @override
  int get hashCode {
    return WorkbenchStateMapper.ensureInitialized().hashValue(
      this as WorkbenchState,
    );
  }
}

extension WorkbenchStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WorkbenchState, $Out> {
  WorkbenchStateCopyWith<$R, WorkbenchState, $Out> get $asWorkbenchState =>
      $base.as((v, t, t2) => _WorkbenchStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WorkbenchStateCopyWith<$R, $In extends WorkbenchState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    MainModule? activeMain,
    UtilityModule? activeUtility,
    SubUtilityModule? activeSubUtility,
    bool? isSidebarExpanded,
  });
  WorkbenchStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _WorkbenchStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WorkbenchState, $Out>
    implements WorkbenchStateCopyWith<$R, WorkbenchState, $Out> {
  _WorkbenchStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WorkbenchState> $mapper =
      WorkbenchStateMapper.ensureInitialized();
  @override
  $R call({
    MainModule? activeMain,
    UtilityModule? activeUtility,
    SubUtilityModule? activeSubUtility,
    bool? isSidebarExpanded,
  }) => $apply(
    FieldCopyWithData({
      if (activeMain != null) #activeMain: activeMain,
      if (activeUtility != null) #activeUtility: activeUtility,
      if (activeSubUtility != null) #activeSubUtility: activeSubUtility,
      if (isSidebarExpanded != null) #isSidebarExpanded: isSidebarExpanded,
    }),
  );
  @override
  WorkbenchState $make(CopyWithData data) => WorkbenchState(
    activeMain: data.get(#activeMain, or: $value.activeMain),
    activeUtility: data.get(#activeUtility, or: $value.activeUtility),
    activeSubUtility: data.get(#activeSubUtility, or: $value.activeSubUtility),
    isSidebarExpanded: data.get(
      #isSidebarExpanded,
      or: $value.isSidebarExpanded,
    ),
  );

  @override
  WorkbenchStateCopyWith<$R2, WorkbenchState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _WorkbenchStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


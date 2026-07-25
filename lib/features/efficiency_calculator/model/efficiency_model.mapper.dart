// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'efficiency_model.dart';

class EfficiencyStateMapper extends ClassMapperBase<EfficiencyState> {
  EfficiencyStateMapper._();

  static EfficiencyStateMapper? _instance;
  static EfficiencyStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = EfficiencyStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'EfficiencyState';

  static String _$inputWorkInput(EfficiencyState v) => v.inputWorkInput;
  static const Field<EfficiencyState, String> _f$inputWorkInput = Field(
    'inputWorkInput',
    _$inputWorkInput,
    opt: true,
    def: "",
  );
  static String _$inputWorkOutput(EfficiencyState v) => v.inputWorkOutput;
  static const Field<EfficiencyState, String> _f$inputWorkOutput = Field(
    'inputWorkOutput',
    _$inputWorkOutput,
    opt: true,
    def: "",
  );
  static double? _$workInput(EfficiencyState v) => v.workInput;
  static const Field<EfficiencyState, double> _f$workInput = Field(
    'workInput',
    _$workInput,
    opt: true,
  );
  static double? _$workOutput(EfficiencyState v) => v.workOutput;
  static const Field<EfficiencyState, double> _f$workOutput = Field(
    'workOutput',
    _$workOutput,
    opt: true,
  );
  static double? _$efficiency(EfficiencyState v) => v.efficiency;
  static const Field<EfficiencyState, double> _f$efficiency = Field(
    'efficiency',
    _$efficiency,
    opt: true,
  );
  static double? _$loss(EfficiencyState v) => v.loss;
  static const Field<EfficiencyState, double> _f$loss = Field(
    'loss',
    _$loss,
    opt: true,
  );
  static List<String> _$steps(EfficiencyState v) => v.steps;
  static const Field<EfficiencyState, List<String>> _f$steps = Field(
    'steps',
    _$steps,
    opt: true,
    def: const [],
  );
  static String? _$errorMessage(EfficiencyState v) => v.errorMessage;
  static const Field<EfficiencyState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );

  @override
  final MappableFields<EfficiencyState> fields = const {
    #inputWorkInput: _f$inputWorkInput,
    #inputWorkOutput: _f$inputWorkOutput,
    #workInput: _f$workInput,
    #workOutput: _f$workOutput,
    #efficiency: _f$efficiency,
    #loss: _f$loss,
    #steps: _f$steps,
    #errorMessage: _f$errorMessage,
  };

  static EfficiencyState _instantiate(DecodingData data) {
    return EfficiencyState(
      inputWorkInput: data.dec(_f$inputWorkInput),
      inputWorkOutput: data.dec(_f$inputWorkOutput),
      workInput: data.dec(_f$workInput),
      workOutput: data.dec(_f$workOutput),
      efficiency: data.dec(_f$efficiency),
      loss: data.dec(_f$loss),
      steps: data.dec(_f$steps),
      errorMessage: data.dec(_f$errorMessage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EfficiencyState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EfficiencyState>(map);
  }

  static EfficiencyState fromJson(String json) {
    return ensureInitialized().decodeJson<EfficiencyState>(json);
  }
}

mixin EfficiencyStateMappable {
  String toJson() {
    return EfficiencyStateMapper.ensureInitialized()
        .encodeJson<EfficiencyState>(this as EfficiencyState);
  }

  Map<String, dynamic> toMap() {
    return EfficiencyStateMapper.ensureInitialized().encodeMap<EfficiencyState>(
      this as EfficiencyState,
    );
  }

  EfficiencyStateCopyWith<EfficiencyState, EfficiencyState, EfficiencyState>
  get copyWith =>
      _EfficiencyStateCopyWithImpl<EfficiencyState, EfficiencyState>(
        this as EfficiencyState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return EfficiencyStateMapper.ensureInitialized().stringifyValue(
      this as EfficiencyState,
    );
  }

  @override
  bool operator ==(Object other) {
    return EfficiencyStateMapper.ensureInitialized().equalsValue(
      this as EfficiencyState,
      other,
    );
  }

  @override
  int get hashCode {
    return EfficiencyStateMapper.ensureInitialized().hashValue(
      this as EfficiencyState,
    );
  }
}

extension EfficiencyStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EfficiencyState, $Out> {
  EfficiencyStateCopyWith<$R, EfficiencyState, $Out> get $asEfficiencyState =>
      $base.as((v, t, t2) => _EfficiencyStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class EfficiencyStateCopyWith<$R, $In extends EfficiencyState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get steps;
  $R call({
    String? inputWorkInput,
    String? inputWorkOutput,
    double? workInput,
    double? workOutput,
    double? efficiency,
    double? loss,
    List<String>? steps,
    String? errorMessage,
  });
  EfficiencyStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EfficiencyStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EfficiencyState, $Out>
    implements EfficiencyStateCopyWith<$R, EfficiencyState, $Out> {
  _EfficiencyStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EfficiencyState> $mapper =
      EfficiencyStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get steps =>
      ListCopyWith(
        $value.steps,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(steps: v),
      );
  @override
  $R call({
    String? inputWorkInput,
    String? inputWorkOutput,
    Object? workInput = $none,
    Object? workOutput = $none,
    Object? efficiency = $none,
    Object? loss = $none,
    List<String>? steps,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (inputWorkInput != null) #inputWorkInput: inputWorkInput,
      if (inputWorkOutput != null) #inputWorkOutput: inputWorkOutput,
      if (workInput != $none) #workInput: workInput,
      if (workOutput != $none) #workOutput: workOutput,
      if (efficiency != $none) #efficiency: efficiency,
      if (loss != $none) #loss: loss,
      if (steps != null) #steps: steps,
      if (errorMessage != $none) #errorMessage: errorMessage,
    }),
  );
  @override
  EfficiencyState $make(CopyWithData data) => EfficiencyState(
    inputWorkInput: data.get(#inputWorkInput, or: $value.inputWorkInput),
    inputWorkOutput: data.get(#inputWorkOutput, or: $value.inputWorkOutput),
    workInput: data.get(#workInput, or: $value.workInput),
    workOutput: data.get(#workOutput, or: $value.workOutput),
    efficiency: data.get(#efficiency, or: $value.efficiency),
    loss: data.get(#loss, or: $value.loss),
    steps: data.get(#steps, or: $value.steps),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  EfficiencyStateCopyWith<$R2, EfficiencyState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _EfficiencyStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


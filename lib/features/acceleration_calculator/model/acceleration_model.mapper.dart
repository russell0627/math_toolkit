// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'acceleration_model.dart';

class AccelerationSolveModeMapper extends EnumMapper<AccelerationSolveMode> {
  AccelerationSolveModeMapper._();

  static AccelerationSolveModeMapper? _instance;
  static AccelerationSolveModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccelerationSolveModeMapper._());
    }
    return _instance!;
  }

  static AccelerationSolveMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AccelerationSolveMode decode(dynamic value) {
    switch (value) {
      case r'acceleration':
        return AccelerationSolveMode.acceleration;
      case r'initialVelocity':
        return AccelerationSolveMode.initialVelocity;
      case r'finalVelocity':
        return AccelerationSolveMode.finalVelocity;
      case r'time':
        return AccelerationSolveMode.time;
      case r'speedChange':
        return AccelerationSolveMode.speedChange;
      case r'velocityChange':
        return AccelerationSolveMode.velocityChange;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AccelerationSolveMode self) {
    switch (self) {
      case AccelerationSolveMode.acceleration:
        return r'acceleration';
      case AccelerationSolveMode.initialVelocity:
        return r'initialVelocity';
      case AccelerationSolveMode.finalVelocity:
        return r'finalVelocity';
      case AccelerationSolveMode.time:
        return r'time';
      case AccelerationSolveMode.speedChange:
        return r'speedChange';
      case AccelerationSolveMode.velocityChange:
        return r'velocityChange';
    }
  }
}

extension AccelerationSolveModeMapperExtension on AccelerationSolveMode {
  String toValue() {
    AccelerationSolveModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AccelerationSolveMode>(this)
        as String;
  }
}

class AccelerationStateMapper extends ClassMapperBase<AccelerationState> {
  AccelerationStateMapper._();

  static AccelerationStateMapper? _instance;
  static AccelerationStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccelerationStateMapper._());
      AccelerationSolveModeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AccelerationState';

  static AccelerationSolveMode _$solveMode(AccelerationState v) => v.solveMode;
  static const Field<AccelerationState, AccelerationSolveMode> _f$solveMode =
      Field(
        'solveMode',
        _$solveMode,
        opt: true,
        def: AccelerationSolveMode.acceleration,
      );
  static String _$inputInitialVelocity(AccelerationState v) =>
      v.inputInitialVelocity;
  static const Field<AccelerationState, String> _f$inputInitialVelocity = Field(
    'inputInitialVelocity',
    _$inputInitialVelocity,
    opt: true,
    def: "",
  );
  static String _$inputFinalVelocity(AccelerationState v) =>
      v.inputFinalVelocity;
  static const Field<AccelerationState, String> _f$inputFinalVelocity = Field(
    'inputFinalVelocity',
    _$inputFinalVelocity,
    opt: true,
    def: "",
  );
  static String _$inputTime(AccelerationState v) => v.inputTime;
  static const Field<AccelerationState, String> _f$inputTime = Field(
    'inputTime',
    _$inputTime,
    opt: true,
    def: "",
  );
  static String _$inputAcceleration(AccelerationState v) => v.inputAcceleration;
  static const Field<AccelerationState, String> _f$inputAcceleration = Field(
    'inputAcceleration',
    _$inputAcceleration,
    opt: true,
    def: "",
  );
  static String _$inputSpeedChange(AccelerationState v) => v.inputSpeedChange;
  static const Field<AccelerationState, String> _f$inputSpeedChange = Field(
    'inputSpeedChange',
    _$inputSpeedChange,
    opt: true,
    def: "",
  );
  static double? _$vInitial(AccelerationState v) => v.vInitial;
  static const Field<AccelerationState, double> _f$vInitial = Field(
    'vInitial',
    _$vInitial,
    opt: true,
  );
  static double? _$vFinal(AccelerationState v) => v.vFinal;
  static const Field<AccelerationState, double> _f$vFinal = Field(
    'vFinal',
    _$vFinal,
    opt: true,
  );
  static double? _$time(AccelerationState v) => v.time;
  static const Field<AccelerationState, double> _f$time = Field(
    'time',
    _$time,
    opt: true,
  );
  static double? _$acceleration(AccelerationState v) => v.acceleration;
  static const Field<AccelerationState, double> _f$acceleration = Field(
    'acceleration',
    _$acceleration,
    opt: true,
  );
  static double? _$speedChange(AccelerationState v) => v.speedChange;
  static const Field<AccelerationState, double> _f$speedChange = Field(
    'speedChange',
    _$speedChange,
    opt: true,
  );
  static double? _$calculatedValue(AccelerationState v) => v.calculatedValue;
  static const Field<AccelerationState, double> _f$calculatedValue = Field(
    'calculatedValue',
    _$calculatedValue,
    opt: true,
  );
  static double? _$distance(AccelerationState v) => v.distance;
  static const Field<AccelerationState, double> _f$distance = Field(
    'distance',
    _$distance,
    opt: true,
  );
  static List<String> _$steps(AccelerationState v) => v.steps;
  static const Field<AccelerationState, List<String>> _f$steps = Field(
    'steps',
    _$steps,
    opt: true,
    def: const [],
  );
  static String? _$errorMessage(AccelerationState v) => v.errorMessage;
  static const Field<AccelerationState, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );

  @override
  final MappableFields<AccelerationState> fields = const {
    #solveMode: _f$solveMode,
    #inputInitialVelocity: _f$inputInitialVelocity,
    #inputFinalVelocity: _f$inputFinalVelocity,
    #inputTime: _f$inputTime,
    #inputAcceleration: _f$inputAcceleration,
    #inputSpeedChange: _f$inputSpeedChange,
    #vInitial: _f$vInitial,
    #vFinal: _f$vFinal,
    #time: _f$time,
    #acceleration: _f$acceleration,
    #speedChange: _f$speedChange,
    #calculatedValue: _f$calculatedValue,
    #distance: _f$distance,
    #steps: _f$steps,
    #errorMessage: _f$errorMessage,
  };

  static AccelerationState _instantiate(DecodingData data) {
    return AccelerationState(
      solveMode: data.dec(_f$solveMode),
      inputInitialVelocity: data.dec(_f$inputInitialVelocity),
      inputFinalVelocity: data.dec(_f$inputFinalVelocity),
      inputTime: data.dec(_f$inputTime),
      inputAcceleration: data.dec(_f$inputAcceleration),
      inputSpeedChange: data.dec(_f$inputSpeedChange),
      vInitial: data.dec(_f$vInitial),
      vFinal: data.dec(_f$vFinal),
      time: data.dec(_f$time),
      acceleration: data.dec(_f$acceleration),
      speedChange: data.dec(_f$speedChange),
      calculatedValue: data.dec(_f$calculatedValue),
      distance: data.dec(_f$distance),
      steps: data.dec(_f$steps),
      errorMessage: data.dec(_f$errorMessage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AccelerationState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AccelerationState>(map);
  }

  static AccelerationState fromJson(String json) {
    return ensureInitialized().decodeJson<AccelerationState>(json);
  }
}

mixin AccelerationStateMappable {
  String toJson() {
    return AccelerationStateMapper.ensureInitialized()
        .encodeJson<AccelerationState>(this as AccelerationState);
  }

  Map<String, dynamic> toMap() {
    return AccelerationStateMapper.ensureInitialized()
        .encodeMap<AccelerationState>(this as AccelerationState);
  }

  AccelerationStateCopyWith<
    AccelerationState,
    AccelerationState,
    AccelerationState
  >
  get copyWith =>
      _AccelerationStateCopyWithImpl<AccelerationState, AccelerationState>(
        this as AccelerationState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AccelerationStateMapper.ensureInitialized().stringifyValue(
      this as AccelerationState,
    );
  }

  @override
  bool operator ==(Object other) {
    return AccelerationStateMapper.ensureInitialized().equalsValue(
      this as AccelerationState,
      other,
    );
  }

  @override
  int get hashCode {
    return AccelerationStateMapper.ensureInitialized().hashValue(
      this as AccelerationState,
    );
  }
}

extension AccelerationStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AccelerationState, $Out> {
  AccelerationStateCopyWith<$R, AccelerationState, $Out>
  get $asAccelerationState => $base.as(
    (v, t, t2) => _AccelerationStateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class AccelerationStateCopyWith<
  $R,
  $In extends AccelerationState,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get steps;
  $R call({
    AccelerationSolveMode? solveMode,
    String? inputInitialVelocity,
    String? inputFinalVelocity,
    String? inputTime,
    String? inputAcceleration,
    String? inputSpeedChange,
    double? vInitial,
    double? vFinal,
    double? time,
    double? acceleration,
    double? speedChange,
    double? calculatedValue,
    double? distance,
    List<String>? steps,
    String? errorMessage,
  });
  AccelerationStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AccelerationStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AccelerationState, $Out>
    implements AccelerationStateCopyWith<$R, AccelerationState, $Out> {
  _AccelerationStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AccelerationState> $mapper =
      AccelerationStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get steps =>
      ListCopyWith(
        $value.steps,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(steps: v),
      );
  @override
  $R call({
    AccelerationSolveMode? solveMode,
    String? inputInitialVelocity,
    String? inputFinalVelocity,
    String? inputTime,
    String? inputAcceleration,
    String? inputSpeedChange,
    Object? vInitial = $none,
    Object? vFinal = $none,
    Object? time = $none,
    Object? acceleration = $none,
    Object? speedChange = $none,
    Object? calculatedValue = $none,
    Object? distance = $none,
    List<String>? steps,
    Object? errorMessage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (solveMode != null) #solveMode: solveMode,
      if (inputInitialVelocity != null)
        #inputInitialVelocity: inputInitialVelocity,
      if (inputFinalVelocity != null) #inputFinalVelocity: inputFinalVelocity,
      if (inputTime != null) #inputTime: inputTime,
      if (inputAcceleration != null) #inputAcceleration: inputAcceleration,
      if (inputSpeedChange != null) #inputSpeedChange: inputSpeedChange,
      if (vInitial != $none) #vInitial: vInitial,
      if (vFinal != $none) #vFinal: vFinal,
      if (time != $none) #time: time,
      if (acceleration != $none) #acceleration: acceleration,
      if (speedChange != $none) #speedChange: speedChange,
      if (calculatedValue != $none) #calculatedValue: calculatedValue,
      if (distance != $none) #distance: distance,
      if (steps != null) #steps: steps,
      if (errorMessage != $none) #errorMessage: errorMessage,
    }),
  );
  @override
  AccelerationState $make(CopyWithData data) => AccelerationState(
    solveMode: data.get(#solveMode, or: $value.solveMode),
    inputInitialVelocity: data.get(
      #inputInitialVelocity,
      or: $value.inputInitialVelocity,
    ),
    inputFinalVelocity: data.get(
      #inputFinalVelocity,
      or: $value.inputFinalVelocity,
    ),
    inputTime: data.get(#inputTime, or: $value.inputTime),
    inputAcceleration: data.get(
      #inputAcceleration,
      or: $value.inputAcceleration,
    ),
    inputSpeedChange: data.get(#inputSpeedChange, or: $value.inputSpeedChange),
    vInitial: data.get(#vInitial, or: $value.vInitial),
    vFinal: data.get(#vFinal, or: $value.vFinal),
    time: data.get(#time, or: $value.time),
    acceleration: data.get(#acceleration, or: $value.acceleration),
    speedChange: data.get(#speedChange, or: $value.speedChange),
    calculatedValue: data.get(#calculatedValue, or: $value.calculatedValue),
    distance: data.get(#distance, or: $value.distance),
    steps: data.get(#steps, or: $value.steps),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
  );

  @override
  AccelerationStateCopyWith<$R2, AccelerationState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AccelerationStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


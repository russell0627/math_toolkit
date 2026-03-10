// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'element_model.dart';

class BureauElementMapper extends ClassMapperBase<BureauElement> {
  BureauElementMapper._();

  static BureauElementMapper? _instance;
  static BureauElementMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BureauElementMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BureauElement';

  static int _$atomicNumber(BureauElement v) => v.atomicNumber;
  static const Field<BureauElement, int> _f$atomicNumber = Field(
    'atomicNumber',
    _$atomicNumber,
  );
  static String _$symbol(BureauElement v) => v.symbol;
  static const Field<BureauElement, String> _f$symbol = Field(
    'symbol',
    _$symbol,
  );
  static String _$name(BureauElement v) => v.name;
  static const Field<BureauElement, String> _f$name = Field('name', _$name);
  static double _$atomicMass(BureauElement v) => v.atomicMass;
  static const Field<BureauElement, double> _f$atomicMass = Field(
    'atomicMass',
    _$atomicMass,
  );
  static String _$category(BureauElement v) => v.category;
  static const Field<BureauElement, String> _f$category = Field(
    'category',
    _$category,
  );
  static String _$electronConfiguration(BureauElement v) =>
      v.electronConfiguration;
  static const Field<BureauElement, String> _f$electronConfiguration = Field(
    'electronConfiguration',
    _$electronConfiguration,
  );
  static String _$appearance(BureauElement v) => v.appearance;
  static const Field<BureauElement, String> _f$appearance = Field(
    'appearance',
    _$appearance,
  );
  static int _$x(BureauElement v) => v.x;
  static const Field<BureauElement, int> _f$x = Field('x', _$x);
  static int _$y(BureauElement v) => v.y;
  static const Field<BureauElement, int> _f$y = Field('y', _$y);

  @override
  final MappableFields<BureauElement> fields = const {
    #atomicNumber: _f$atomicNumber,
    #symbol: _f$symbol,
    #name: _f$name,
    #atomicMass: _f$atomicMass,
    #category: _f$category,
    #electronConfiguration: _f$electronConfiguration,
    #appearance: _f$appearance,
    #x: _f$x,
    #y: _f$y,
  };

  static BureauElement _instantiate(DecodingData data) {
    return BureauElement(
      atomicNumber: data.dec(_f$atomicNumber),
      symbol: data.dec(_f$symbol),
      name: data.dec(_f$name),
      atomicMass: data.dec(_f$atomicMass),
      category: data.dec(_f$category),
      electronConfiguration: data.dec(_f$electronConfiguration),
      appearance: data.dec(_f$appearance),
      x: data.dec(_f$x),
      y: data.dec(_f$y),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BureauElement fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BureauElement>(map);
  }

  static BureauElement fromJson(String json) {
    return ensureInitialized().decodeJson<BureauElement>(json);
  }
}

mixin BureauElementMappable {
  String toJson() {
    return BureauElementMapper.ensureInitialized().encodeJson<BureauElement>(
      this as BureauElement,
    );
  }

  Map<String, dynamic> toMap() {
    return BureauElementMapper.ensureInitialized().encodeMap<BureauElement>(
      this as BureauElement,
    );
  }

  BureauElementCopyWith<BureauElement, BureauElement, BureauElement>
  get copyWith => _BureauElementCopyWithImpl<BureauElement, BureauElement>(
    this as BureauElement,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return BureauElementMapper.ensureInitialized().stringifyValue(
      this as BureauElement,
    );
  }

  @override
  bool operator ==(Object other) {
    return BureauElementMapper.ensureInitialized().equalsValue(
      this as BureauElement,
      other,
    );
  }

  @override
  int get hashCode {
    return BureauElementMapper.ensureInitialized().hashValue(
      this as BureauElement,
    );
  }
}

extension BureauElementValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BureauElement, $Out> {
  BureauElementCopyWith<$R, BureauElement, $Out> get $asBureauElement =>
      $base.as((v, t, t2) => _BureauElementCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BureauElementCopyWith<$R, $In extends BureauElement, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? atomicNumber,
    String? symbol,
    String? name,
    double? atomicMass,
    String? category,
    String? electronConfiguration,
    String? appearance,
    int? x,
    int? y,
  });
  BureauElementCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BureauElementCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BureauElement, $Out>
    implements BureauElementCopyWith<$R, BureauElement, $Out> {
  _BureauElementCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BureauElement> $mapper =
      BureauElementMapper.ensureInitialized();
  @override
  $R call({
    int? atomicNumber,
    String? symbol,
    String? name,
    double? atomicMass,
    String? category,
    String? electronConfiguration,
    String? appearance,
    int? x,
    int? y,
  }) => $apply(
    FieldCopyWithData({
      if (atomicNumber != null) #atomicNumber: atomicNumber,
      if (symbol != null) #symbol: symbol,
      if (name != null) #name: name,
      if (atomicMass != null) #atomicMass: atomicMass,
      if (category != null) #category: category,
      if (electronConfiguration != null)
        #electronConfiguration: electronConfiguration,
      if (appearance != null) #appearance: appearance,
      if (x != null) #x: x,
      if (y != null) #y: y,
    }),
  );
  @override
  BureauElement $make(CopyWithData data) => BureauElement(
    atomicNumber: data.get(#atomicNumber, or: $value.atomicNumber),
    symbol: data.get(#symbol, or: $value.symbol),
    name: data.get(#name, or: $value.name),
    atomicMass: data.get(#atomicMass, or: $value.atomicMass),
    category: data.get(#category, or: $value.category),
    electronConfiguration: data.get(
      #electronConfiguration,
      or: $value.electronConfiguration,
    ),
    appearance: data.get(#appearance, or: $value.appearance),
    x: data.get(#x, or: $value.x),
    y: data.get(#y, or: $value.y),
  );

  @override
  BureauElementCopyWith<$R2, BureauElement, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BureauElementCopyWithImpl<$R2, $Out2>($value, $cast, t);
}


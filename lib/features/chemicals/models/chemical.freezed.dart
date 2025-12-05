// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chemical.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Chemical _$ChemicalFromJson(Map<String, dynamic> json) {
  return _Chemical.fromJson(json);
}

/// @nodoc
mixin _$Chemical {
  String get id => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  String get casNumber => throw _privateConstructorUsedError;
  String get manufacturer => throw _privateConstructorUsedError;
  InventoryData get inventoryData => throw _privateConstructorUsedError;

  /// Serializes this Chemical to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Chemical
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChemicalCopyWith<Chemical> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChemicalCopyWith<$Res> {
  factory $ChemicalCopyWith(Chemical value, $Res Function(Chemical) then) =
      _$ChemicalCopyWithImpl<$Res, Chemical>;
  @useResult
  $Res call({
    String id,
    String productName,
    String casNumber,
    String manufacturer,
    InventoryData inventoryData,
  });

  $InventoryDataCopyWith<$Res> get inventoryData;
}

/// @nodoc
class _$ChemicalCopyWithImpl<$Res, $Val extends Chemical>
    implements $ChemicalCopyWith<$Res> {
  _$ChemicalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Chemical
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? casNumber = null,
    Object? manufacturer = null,
    Object? inventoryData = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
            casNumber: null == casNumber
                ? _value.casNumber
                : casNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            manufacturer: null == manufacturer
                ? _value.manufacturer
                : manufacturer // ignore: cast_nullable_to_non_nullable
                      as String,
            inventoryData: null == inventoryData
                ? _value.inventoryData
                : inventoryData // ignore: cast_nullable_to_non_nullable
                      as InventoryData,
          )
          as $Val,
    );
  }

  /// Create a copy of Chemical
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventoryDataCopyWith<$Res> get inventoryData {
    return $InventoryDataCopyWith<$Res>(_value.inventoryData, (value) {
      return _then(_value.copyWith(inventoryData: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ChemicalImplCopyWith<$Res>
    implements $ChemicalCopyWith<$Res> {
  factory _$$ChemicalImplCopyWith(
    _$ChemicalImpl value,
    $Res Function(_$ChemicalImpl) then,
  ) = __$$ChemicalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productName,
    String casNumber,
    String manufacturer,
    InventoryData inventoryData,
  });

  @override
  $InventoryDataCopyWith<$Res> get inventoryData;
}

/// @nodoc
class __$$ChemicalImplCopyWithImpl<$Res>
    extends _$ChemicalCopyWithImpl<$Res, _$ChemicalImpl>
    implements _$$ChemicalImplCopyWith<$Res> {
  __$$ChemicalImplCopyWithImpl(
    _$ChemicalImpl _value,
    $Res Function(_$ChemicalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Chemical
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productName = null,
    Object? casNumber = null,
    Object? manufacturer = null,
    Object? inventoryData = null,
  }) {
    return _then(
      _$ChemicalImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
        casNumber: null == casNumber
            ? _value.casNumber
            : casNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        manufacturer: null == manufacturer
            ? _value.manufacturer
            : manufacturer // ignore: cast_nullable_to_non_nullable
                  as String,
        inventoryData: null == inventoryData
            ? _value.inventoryData
            : inventoryData // ignore: cast_nullable_to_non_nullable
                  as InventoryData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChemicalImpl implements _Chemical {
  const _$ChemicalImpl({
    required this.id,
    required this.productName,
    required this.casNumber,
    required this.manufacturer,
    required this.inventoryData,
  });

  factory _$ChemicalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChemicalImplFromJson(json);

  @override
  final String id;
  @override
  final String productName;
  @override
  final String casNumber;
  @override
  final String manufacturer;
  @override
  final InventoryData inventoryData;

  @override
  String toString() {
    return 'Chemical(id: $id, productName: $productName, casNumber: $casNumber, manufacturer: $manufacturer, inventoryData: $inventoryData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChemicalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.casNumber, casNumber) ||
                other.casNumber == casNumber) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.inventoryData, inventoryData) ||
                other.inventoryData == inventoryData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productName,
    casNumber,
    manufacturer,
    inventoryData,
  );

  /// Create a copy of Chemical
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChemicalImplCopyWith<_$ChemicalImpl> get copyWith =>
      __$$ChemicalImplCopyWithImpl<_$ChemicalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChemicalImplToJson(this);
  }
}

abstract class _Chemical implements Chemical {
  const factory _Chemical({
    required final String id,
    required final String productName,
    required final String casNumber,
    required final String manufacturer,
    required final InventoryData inventoryData,
  }) = _$ChemicalImpl;

  factory _Chemical.fromJson(Map<String, dynamic> json) =
      _$ChemicalImpl.fromJson;

  @override
  String get id;
  @override
  String get productName;
  @override
  String get casNumber;
  @override
  String get manufacturer;
  @override
  InventoryData get inventoryData;

  /// Create a copy of Chemical
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChemicalImplCopyWith<_$ChemicalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryData _$InventoryDataFromJson(Map<String, dynamic> json) {
  return _InventoryData.fromJson(json);
}

/// @nodoc
mixin _$InventoryData {
  double get currentStock => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;

  /// Serializes this InventoryData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryDataCopyWith<InventoryData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryDataCopyWith<$Res> {
  factory $InventoryDataCopyWith(
    InventoryData value,
    $Res Function(InventoryData) then,
  ) = _$InventoryDataCopyWithImpl<$Res, InventoryData>;
  @useResult
  $Res call({double currentStock, String unit});
}

/// @nodoc
class _$InventoryDataCopyWithImpl<$Res, $Val extends InventoryData>
    implements $InventoryDataCopyWith<$Res> {
  _$InventoryDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStock = null, Object? unit = null}) {
    return _then(
      _value.copyWith(
            currentStock: null == currentStock
                ? _value.currentStock
                : currentStock // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryDataImplCopyWith<$Res>
    implements $InventoryDataCopyWith<$Res> {
  factory _$$InventoryDataImplCopyWith(
    _$InventoryDataImpl value,
    $Res Function(_$InventoryDataImpl) then,
  ) = __$$InventoryDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double currentStock, String unit});
}

/// @nodoc
class __$$InventoryDataImplCopyWithImpl<$Res>
    extends _$InventoryDataCopyWithImpl<$Res, _$InventoryDataImpl>
    implements _$$InventoryDataImplCopyWith<$Res> {
  __$$InventoryDataImplCopyWithImpl(
    _$InventoryDataImpl _value,
    $Res Function(_$InventoryDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? currentStock = null, Object? unit = null}) {
    return _then(
      _$InventoryDataImpl(
        currentStock: null == currentStock
            ? _value.currentStock
            : currentStock // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryDataImpl implements _InventoryData {
  const _$InventoryDataImpl({required this.currentStock, required this.unit});

  factory _$InventoryDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryDataImplFromJson(json);

  @override
  final double currentStock;
  @override
  final String unit;

  @override
  String toString() {
    return 'InventoryData(currentStock: $currentStock, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryDataImpl &&
            (identical(other.currentStock, currentStock) ||
                other.currentStock == currentStock) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currentStock, unit);

  /// Create a copy of InventoryData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryDataImplCopyWith<_$InventoryDataImpl> get copyWith =>
      __$$InventoryDataImplCopyWithImpl<_$InventoryDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryDataImplToJson(this);
  }
}

abstract class _InventoryData implements InventoryData {
  const factory _InventoryData({
    required final double currentStock,
    required final String unit,
  }) = _$InventoryDataImpl;

  factory _InventoryData.fromJson(Map<String, dynamic> json) =
      _$InventoryDataImpl.fromJson;

  @override
  double get currentStock;
  @override
  String get unit;

  /// Create a copy of InventoryData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryDataImplCopyWith<_$InventoryDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

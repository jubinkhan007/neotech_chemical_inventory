// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package,
// ignore_for_file: use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null,
// ignore_for_file: invalid_override_different_default_values_named, prefer_expression_function_bodies,
// ignore_for_file: annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chemical.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Chemical _$ChemicalFromJson(Map<String, dynamic> json) {
  return _Chemical.fromJson(json);
}

/// @nodoc
mixin _$Chemical {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'cas_number')
  String get casNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'storage_location')
  String get storageLocation => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChemicalCopyWith<Chemical> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChemicalCopyWith<$Res> {
  factory $ChemicalCopyWith(Chemical value, $Res Function(Chemical) then) =
      _$ChemicalCopyWithImpl<$Res, Chemical>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'cas_number') String casNumber,
      @JsonKey(name: 'storage_location') String storageLocation,
      int quantity});
}

/// @nodoc
class _$ChemicalCopyWithImpl<$Res, $Val extends Chemical>
    implements $ChemicalCopyWith<$Res> {
  _$ChemicalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? casNumber = null,
    Object? storageLocation = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      casNumber: null == casNumber
          ? _value.casNumber
          : casNumber // ignore: cast_nullable_to_non_nullable
              as String,
      storageLocation: null == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChemicalImplCopyWith<$Res> implements $ChemicalCopyWith<$Res> {
  factory _$$ChemicalImplCopyWith(
          _$ChemicalImpl value, $Res Function(_$ChemicalImpl) then) =
      __$$ChemicalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'cas_number') String casNumber,
      @JsonKey(name: 'storage_location') String storageLocation,
      int quantity});
}

/// @nodoc
class __$$ChemicalImplCopyWithImpl<$Res>
    extends _$ChemicalCopyWithImpl<$Res, _$ChemicalImpl>
    implements _$$ChemicalImplCopyWith<$Res> {
  __$$ChemicalImplCopyWithImpl(
      _$ChemicalImpl _value, $Res Function(_$ChemicalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? casNumber = null,
    Object? storageLocation = null,
    Object? quantity = null,
  }) {
    return _then(_$ChemicalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      casNumber: null == casNumber
          ? _value.casNumber
          : casNumber // ignore: cast_nullable_to_non_nullable
              as String,
      storageLocation: null == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChemicalImpl implements _Chemical {
  const _$ChemicalImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'cas_number') required this.casNumber,
      @JsonKey(name: 'storage_location') required this.storageLocation,
      required this.quantity});

  factory _$ChemicalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChemicalImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'cas_number')
  final String casNumber;
  @override
  @JsonKey(name: 'storage_location')
  final String storageLocation;
  @override
  final int quantity;

  @override
  String toString() {
    return 'Chemical(id: $id, name: $name, casNumber: $casNumber, storageLocation: $storageLocation, quantity: $quantity)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChemicalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.casNumber, casNumber) ||
                other.casNumber == casNumber) &&
            (identical(other.storageLocation, storageLocation) ||
                other.storageLocation == storageLocation) &&
            (identical(other.quantity, quantity) || other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, casNumber, storageLocation, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChemicalImplCopyWith<_$ChemicalImpl> get copyWith =>
      __$$ChemicalImplCopyWithImpl<_$ChemicalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChemicalImplToJson(
      this,
    );
  }
}

abstract class _Chemical implements Chemical {
  const factory _Chemical(
      {required final String id,
      required final String name,
      @JsonKey(name: 'cas_number') required final String casNumber,
      @JsonKey(name: 'storage_location') required final String storageLocation,
      required final int quantity}) = _$ChemicalImpl;

  factory _Chemical.fromJson(Map<String, dynamic> json) =
      _$ChemicalImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'cas_number')
  String get casNumber;
  @override
  @JsonKey(name: 'storage_location')
  String get storageLocation;
  @override
  int get quantity;
  @override
  @JsonKey(ignore: true)
  _$$ChemicalImplCopyWith<_$ChemicalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

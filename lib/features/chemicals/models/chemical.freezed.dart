// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'chemical.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only\n'
  'meant to be used by freezed and you are not supposed to need it nor use it.\n'
  'Please check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods',
);

Chemical _$ChemicalFromJson(Map<String, dynamic> json) {
  return _Chemical.fromJson(json);
}

mixin _$Chemical {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChemicalCopyWith<Chemical> get copyWith => throw _privateConstructorUsedError;
}

abstract class $ChemicalCopyWith<$Res> {
  factory $ChemicalCopyWith(Chemical value, $Res Function(Chemical) then) =
      _$ChemicalCopyWithImpl<$Res, Chemical>;
  $Res call({String id, String name, String? description, DateTime? lastUpdated});
}

class _$ChemicalCopyWithImpl<$Res, $Val extends Chemical>
    implements $ChemicalCopyWith<$Res> {
  _$ChemicalCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == null ? _value.id : id as String,
      name: name == null ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String?,
      lastUpdated:
          lastUpdated == freezed ? _value.lastUpdated : lastUpdated as DateTime?,
    ) as $Val);
  }
}

abstract class _$$ChemicalCopyWith<$Res> implements $ChemicalCopyWith<$Res> {
  factory _$$ChemicalCopyWith(_Chemical value, $Res Function(_Chemical) then) =
      __$$ChemicalCopyWithImpl<$Res>;
  @override
  $Res call({String id, String name, String? description, DateTime? lastUpdated});
}

class __$$ChemicalCopyWithImpl<$Res>
    extends _$ChemicalCopyWithImpl<$Res, _Chemical>
    implements _$$ChemicalCopyWith<$Res> {
  __$$ChemicalCopyWithImpl(_Chemical _value, $Res Function(_Chemical) _then)
      : super(_value, _then);

  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_Chemical(
      id: id == null ? _value.id : id as String,
      name: name == null ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String?,
      lastUpdated:
          lastUpdated == freezed ? _value.lastUpdated : lastUpdated as DateTime?,
    ));
  }
}

@JsonSerializable()
class _Chemical implements Chemical {
  const _Chemical({
    required this.id,
    required this.name,
    this.description,
    this.lastUpdated,
  });

  factory _Chemical.fromJson(Map<String, dynamic> json) =>
      _$$ChemicalFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'Chemical(id: $id, name: $name, description: $description, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Chemical &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, lastUpdated);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChemicalToJson(this);
  }

  @override
  @JsonKey(ignore: true)
  _$$ChemicalCopyWith<_Chemical> get copyWith =>
      __$$ChemicalCopyWithImpl<_Chemical>(this, _$identity);
}

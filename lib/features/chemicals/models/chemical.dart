import 'package:freezed_annotation/freezed_annotation.dart';

part 'chemical.freezed.dart';
part 'chemical.g.dart';

@freezed
class Chemical with _$Chemical {
  const factory Chemical({
    required String id,
    required String name,
    @JsonKey(name: 'cas_number') required String casNumber,
    @JsonKey(name: 'storage_location') required String storageLocation,
    required int quantity,
  }) = _Chemical;

  factory Chemical.fromJson(Map<String, dynamic> json) =>
      _$ChemicalFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chemical.freezed.dart';
part 'chemical.g.dart';

@freezed
class Chemical with _$Chemical {
  const factory Chemical({
    required String id,
    required String name,
    String? description,
    DateTime? lastUpdated,
  }) = _Chemical;

  factory Chemical.fromJson(Map<String, dynamic> json) => _$ChemicalFromJson(json);
}

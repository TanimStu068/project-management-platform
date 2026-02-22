import 'package:json_annotation/json_annotation.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectModel {
  final int id;
  final String title;
  final String? description;
  @JsonKey(name: 'buyer_id')
  final int buyerId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    this.description,
    required this.buyerId,
    required this.createdAt,
  });

  ProjectModel copyWith({
    int? id,
    String? title,
    String? description,
    int? buyerId,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      buyerId: buyerId ?? this.buyerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

enum TaskStatus {
  @JsonValue('todo')
  TODO,

  @JsonValue('in_progress')
  IN_PROGRESS,

  @JsonValue('submitted')
  SUBMITTED,

  @JsonValue('paid')
  PAID,
}

@JsonSerializable()
class TaskModel {
  final int id;
  final String title;
  final String? description;
  @JsonKey(name: 'project_id')
  final int projectId;
  @JsonKey(name: 'developer_id')
  final int? developerId;
  @JsonKey(name: 'hourly_rate')
  final double hourlyRate;
  @JsonKey(name: 'hours_spent')
  final double? hoursSpent;
  final TaskStatus status;
  @JsonKey(name: 'solution_url')
  final String? solutionUrl;
  @JsonKey(name: 'submission_locked')
  final bool? submissionLocked;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;
  @JsonKey(name: 'paid_at')
  final DateTime? paidAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.projectId,
    this.developerId,
    required this.hourlyRate,
    this.hoursSpent,
    required this.status,
    this.solutionUrl,
    this.submissionLocked,
    required this.createdAt,
    this.submittedAt,
    this.paidAt,
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    int? projectId,
    int? developerId,
    double? hourlyRate,
    double? hoursSpent,
    TaskStatus? status,
    String? solutionUrl,
    bool? submissionLocked,
    DateTime? createdAt,
    DateTime? submittedAt,
    DateTime? paidAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      developerId: developerId ?? this.developerId,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      hoursSpent: hoursSpent ?? this.hoursSpent,
      status: status ?? this.status,
      solutionUrl: solutionUrl ?? this.solutionUrl,
      submissionLocked: submissionLocked ?? this.submissionLocked,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}

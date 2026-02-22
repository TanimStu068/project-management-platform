part of 'task_model.dart';

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  projectId: (json['project_id'] as num).toInt(),
  developerId: (json['developer_id'] as num?)?.toInt(),
  hourlyRate: (json['hourly_rate'] as num).toDouble(),
  hoursSpent: (json['hours_spent'] as num?)?.toDouble(),
  status: $enumDecode(_$TaskStatusEnumMap, json['status']),
  solutionUrl: json['solution_url'] as String?,
  submissionLocked: json['submission_locked'] as bool?,
  createdAt: DateTime.parse(json['created_at'] as String),
  submittedAt: json['submitted_at'] == null
      ? null
      : DateTime.parse(json['submitted_at'] as String),
  paidAt: json['paid_at'] == null
      ? null
      : DateTime.parse(json['paid_at'] as String),
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'project_id': instance.projectId,
  'developer_id': instance.developerId,
  'hourly_rate': instance.hourlyRate,
  'hours_spent': instance.hoursSpent,
  'status': _$TaskStatusEnumMap[instance.status]!,
  'solution_url': instance.solutionUrl,
  'submission_locked': instance.submissionLocked,
  'created_at': instance.createdAt.toIso8601String(),
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'paid_at': instance.paidAt?.toIso8601String(),
};

const _$TaskStatusEnumMap = {
  TaskStatus.TODO: 'todo',
  TaskStatus.IN_PROGRESS: 'in_progress',
  TaskStatus.SUBMITTED: 'submitted',
  TaskStatus.PAID: 'paid',
};

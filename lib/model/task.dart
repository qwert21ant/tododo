import 'dart:io';
import 'dart:ui';

import 'package:uuid/uuid.dart';

import 'package:tododo/utils/utils.dart';

enum TaskImportance { none, low, high }

class TaskData {
  static const _uuid = Uuid();

  String id;
  String text;
  TaskImportance importance;
  DateTime? date;
  bool isDone;
  Color? color;
  DateTime createdAt;
  DateTime changedAt;
  String updatedBy;

  TaskData({
    String? id,
    required this.text,
    this.importance = TaskImportance.none,
    this.date,
    this.isDone = false,
    this.color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? updatedBy,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now(),
        changedAt = changedAt ?? DateTime.now(),
        updatedBy =
            updatedBy ?? (Platform.isAndroid ? 'android' : 'not android');

  TaskData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        importance = importanceFromString(json['importance']),
        date = json.containsKey('deadline')
            ? dateFromTimestamp(json['deadline'])
            : null,
        isDone = json['done'],
        color = json.containsKey('color')
            ? Color(
                int.parse(
                  (json['color'] as String).substring(1),
                  radix: 16,
                ),
              )
            : null,
        createdAt = dateFromTimestamp(json['created_at']),
        changedAt = dateFromTimestamp(json['changed_at']),
        updatedBy = json['last_updated_by'];

  Map<String, Object> toJson() => {
        'id': id,
        'text': text,
        'importance': importanceToString(importance),
        if (date != null) 'deadline': dateToTimestamp(date!),
        'done': isDone,
        if (color != null) 'color': '#${color!.value.toRadixString(16)}',
        'created_at': dateToTimestamp(createdAt),
        'changed_at': dateToTimestamp(changedAt),
        'last_updated_by': updatedBy
      };

  @override
  String toString() {
    return '${text.length > 30 ? text.substring(0, 30) : text} [${isDone ? 'done' : 'not done'}]';
  }

  TaskData copyWith({
    String? id,
    String? text,
    TaskImportance? importance,
    bool? nullDate, // because date has type DateTime?
    DateTime? date,
    bool? isDone,
    bool? nullColor, // because color has type Color?
    Color? color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? updatedBy,
  }) {
    return TaskData(
      id: id ?? this.id,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      date: (nullDate ?? false) ? null : (date ?? this.date),
      isDone: isDone ?? this.isDone,
      color: (nullColor ?? false) ? null : (color ?? this.color),
      createdAt: createdAt ?? this.createdAt,
      changedAt: changedAt ?? this.changedAt,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  TaskData copy() => copyWith();

  bool isEqual(TaskData other) =>
      id == other.id &&
      text == other.text &&
      importance == other.importance &&
      date == other.date &&
      isDone == other.isDone &&
      color == other.color &&
      createdAt == other.createdAt &&
      changedAt == other.changedAt &&
      updatedBy == other.updatedBy;
}

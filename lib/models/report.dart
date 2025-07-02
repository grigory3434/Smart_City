import 'package:flutter/material.dart';

enum ReportStatus {
  new_, // Новый
  inProgress, // В работе
  completed, // Завершён
  rejected, // Отклонён
}

enum ReportCategory {
  road, // Дороги
  lighting, // Освещение
  garbage, // Мусор
  shelter, // Укрытие
  other, // Другое
}

enum ReportPriority {
  low, // Низкий
  medium, // Средний
  high, // Высокий
  critical, // Критический
}

class Report {
  final String id;
  final String title;
  final String description;
  final ReportCategory category;
  final ReportStatus status;
  final ReportPriority priority;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;
  final String reporterName;
  final String? serviceComment;
  final List<String> tags;
  final int likesCount;
  final bool isLiked;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
    required this.reporterName,
    this.serviceComment,
    this.tags = const [],
    this.likesCount = 0,
    this.isLiked = false,
  });

  // Создание из JSON
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: ReportCategory.values.firstWhere(
        (cat) => cat.toString().split('.').last == json['category'],
        orElse: () => ReportCategory.other,
      ),
      status: ReportStatus.values.firstWhere(
        (status) => status.toString().split('.').last == json['status'],
        orElse: () => ReportStatus.new_,
      ),
      priority: ReportPriority.values.firstWhere(
        (priority) => priority.toString().split('.').last == json['priority'],
        orElse: () => ReportPriority.medium,
      ),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      photoUrl: json['photo_url'],
      reporterName: json['reporter_name'],
      serviceComment: json['service_comment'],
      tags: List<String>.from(json['tags'] ?? []),
      likesCount: json['likes_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toString().split('.').last,
      'status': status.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'photo_url': photoUrl,
      'reporter_name': reporterName,
      'service_comment': serviceComment,
      'tags': tags,
      'likes_count': likesCount,
      'is_liked': isLiked,
    };
  }

  // Копирование с изменениями
  Report copyWith({
    String? id,
    String? title,
    String? description,
    ReportCategory? category,
    ReportStatus? status,
    ReportPriority? priority,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? photoUrl,
    String? reporterName,
    String? serviceComment,
    List<String>? tags,
    int? likesCount,
    bool? isLiked,
  }) {
    return Report(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      photoUrl: photoUrl ?? this.photoUrl,
      reporterName: reporterName ?? this.reporterName,
      serviceComment: serviceComment ?? this.serviceComment,
      tags: tags ?? this.tags,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  // Получение строкового представления статуса
  String get statusString {
    switch (status) {
      case ReportStatus.new_:
        return 'Новый';
      case ReportStatus.inProgress:
        return 'В работе';
      case ReportStatus.completed:
        return 'Завершён';
      case ReportStatus.rejected:
        return 'Отклонён';
    }
  }

  // Получение строкового представления категории
  String get categoryString {
    switch (category) {
      case ReportCategory.road:
        return 'Дороги';
      case ReportCategory.lighting:
        return 'Освещение';
      case ReportCategory.garbage:
        return 'Мусор';
      case ReportCategory.shelter:
        return 'Укрытие';
      case ReportCategory.other:
        return 'Другое';
    }
  }

  // Получение строкового представления приоритета
  String get priorityString {
    switch (priority) {
      case ReportPriority.low:
        return 'Низкий';
      case ReportPriority.medium:
        return 'Средний';
      case ReportPriority.high:
        return 'Высокий';
      case ReportPriority.critical:
        return 'Критический';
    }
  }

  // Получение цвета статуса
  Color get statusColor {
    switch (status) {
      case ReportStatus.new_:
        return Colors.blue;
      case ReportStatus.inProgress:
        return Colors.orange;
      case ReportStatus.completed:
        return Colors.green;
      case ReportStatus.rejected:
        return Colors.red;
    }
  }

  // Получение цвета категории
  Color get categoryColor {
    switch (category) {
      case ReportCategory.road:
        return Colors.orange;
      case ReportCategory.lighting:
        return Colors.yellow[700]!;
      case ReportCategory.garbage:
        return Colors.green;
      case ReportCategory.shelter:
        return Colors.blue;
      case ReportCategory.other:
        return Colors.grey;
    }
  }

  // Получение цвета приоритета
  Color get priorityColor {
    switch (priority) {
      case ReportPriority.low:
        return Colors.green;
      case ReportPriority.medium:
        return Colors.orange;
      case ReportPriority.high:
        return Colors.red;
      case ReportPriority.critical:
        return Colors.purple;
    }
  }

  // Проверка, является ли репорт новым
  bool get isNew => status == ReportStatus.new_;

  // Проверка, находится ли репорт в работе
  bool get isInProgress => status == ReportStatus.inProgress;

  // Проверка, завершён ли репорт
  bool get isCompleted => status == ReportStatus.completed;

  // Проверка, отклонён ли репорт
  bool get isRejected => status == ReportStatus.rejected;

  // Проверка высокого приоритета
  bool get isHighPriority => priority == ReportPriority.high;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Report && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Report(id: $id, title: $title, status: $statusString, category: $categoryString)';
  }
}

enum UserRole {
  resident, // Житель
  service, // Коммунальная служба
  admin, // Администратор
  volunteer, // Волонтёр
  employee, // Сотрудник
  trustedReporter, // Доверенный репортёр
}

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isVerified;
  final bool isActive;
  final Map<String, dynamic>? preferences;
  final List<String> achievements;
  final int reportsCount;
  final int volunteerHours;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
    required this.createdAt,
    this.lastLoginAt,
    this.isVerified = false,
    this.isActive = true,
    this.preferences,
    this.achievements = const [],
    this.reportsCount = 0,
    this.volunteerHours = 0,
    this.avatarUrl,
  });

  // Создание из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      role: UserRole.values.firstWhere(
        (role) => role.toString().split('.').last == json['role'],
        orElse: () => UserRole.resident,
      ),
      createdAt: DateTime.parse(json['created_at']),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      preferences: json['preferences'],
      achievements: List<String>.from(json['achievements'] ?? []),
      reportsCount: json['reports_count'] ?? 0,
      volunteerHours: json['volunteer_hours'] ?? 0,
      avatarUrl: json['avatar_url'],
    );
  }

  // Преобразование в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'role': role.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'is_verified': isVerified,
      'is_active': isActive,
      'preferences': preferences,
      'achievements': achievements,
      'reports_count': reportsCount,
      'volunteer_hours': volunteerHours,
      'avatar_url': avatarUrl,
    };
  }

  // Копирование с изменениями
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    UserRole? role,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isVerified,
    bool? isActive,
    Map<String, dynamic>? preferences,
    List<String>? achievements,
    int? reportsCount,
    int? volunteerHours,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
      achievements: achievements ?? this.achievements,
      reportsCount: reportsCount ?? this.reportsCount,
      volunteerHours: volunteerHours ?? this.volunteerHours,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  // Получение строкового представления роли
  String get roleString {
    switch (role) {
      case UserRole.resident:
        return 'Житель';
      case UserRole.service:
        return 'Коммунальная служба';
      case UserRole.admin:
        return 'Администратор';
      case UserRole.volunteer:
        return 'Волонтёр';
      case UserRole.employee:
        return 'Сотрудник';
      case UserRole.trustedReporter:
        return 'Доверенный репортёр';
    }
  }

  // Проверка прав администратора
  bool get isAdmin => role == UserRole.admin;

  // Проверка прав службы
  bool get isService => role == UserRole.service || role == UserRole.admin;

  // Проверка доверенного репортёра
  bool get isTrustedReporter =>
      role == UserRole.trustedReporter || role == UserRole.admin;

  // Проверка волонтёра
  bool get isVolunteer => role == UserRole.volunteer || role == UserRole.admin;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $roleString)';
  }
}

class VolunteerEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final int maxParticipants;
  final int currentParticipants;
  final List<String> participants;
  final String organizerId;
  final String organizerName;
  final bool isActive;

  VolunteerEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.maxParticipants,
    this.currentParticipants = 0,
    this.participants = const [],
    required this.organizerId,
    required this.organizerName,
    this.isActive = true,
  });

  factory VolunteerEvent.fromJson(Map<String, dynamic> json) {
    return VolunteerEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      maxParticipants: json['max_participants'],
      currentParticipants: json['current_participants'] ?? 0,
      participants: List<String>.from(json['participants'] ?? []),
      organizerId: json['organizer_id'],
      organizerName: json['organizer_name'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'participants': participants,
      'organizer_id': organizerId,
      'organizer_name': organizerName,
      'is_active': isActive,
    };
  }

  VolunteerEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? location,
    int? maxParticipants,
    int? currentParticipants,
    List<String>? participants,
    String? organizerId,
    String? organizerName,
    bool? isActive,
  }) {
    return VolunteerEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      participants: participants ?? this.participants,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      isActive: isActive ?? this.isActive,
    );
  }
}

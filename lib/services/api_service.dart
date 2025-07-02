import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report.dart';
import '../models/user.dart';
import '../models/chat_room.dart';

class ApiService {
  static const String baseUrl = 'https://api.smartcity.ru';
  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // Аутентификация
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _authToken = data['token'];
        return {'success': true, 'user': data['user'], 'token': data['token']};
      } else {
        return {'success': false, 'error': 'Неверный email или пароль'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _authToken = data['token'];
        return {'success': true, 'user': data['user'], 'token': data['token']};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['message'] ?? 'Ошибка регистрации'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  // Репорты
  static Future<Map<String, dynamic>> getReports({
    ReportStatus? status,
    ReportCategory? category,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) {
        queryParams['status'] = status.toString().split('.').last;
      }
      if (category != null) {
        queryParams['category'] = category.toString().split('.').last;
      }

      final uri =
          Uri.parse('$baseUrl/reports').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'reports': data['reports']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки репортов'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> createReport({
    required String title,
    required String description,
    required ReportCategory category,
    required double latitude,
    required double longitude,
    String? photoUrl,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reports'),
        headers: _headers,
        body: json.encode({
          'title': title,
          'description': description,
          'category': category.toString().split('.').last,
          'latitude': latitude,
          'longitude': longitude,
          'photo_url': photoUrl,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'report': data['report']};
      } else {
        return {'success': false, 'error': 'Ошибка создания репорта'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateReport(
      String reportId, ReportStatus status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/reports/$reportId'),
        headers: _headers,
        body: json.encode({
          'status': status.toString().split('.').last,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'report': data['report']};
      } else {
        return {'success': false, 'error': 'Ошибка обновления репорта'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  // Волонтерские мероприятия
  static Future<Map<String, dynamic>> getVolunteerEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/volunteer-events'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'events': data['events']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки мероприятий'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> createVolunteerEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required int maxParticipants,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/volunteer-events'),
        headers: _headers,
        body: json.encode({
          'title': title,
          'description': description,
          'date': date.toIso8601String(),
          'location': location,
          'max_participants': maxParticipants,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'event': data['event']};
      } else {
        return {'success': false, 'error': 'Ошибка создания мероприятия'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> joinVolunteerEvent(String eventId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/volunteer-events/$eventId/join'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {
          'success': false,
          'error': 'Ошибка присоединения к мероприятию'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  // Профиль пользователя
  static Future<Map<String, dynamic>> updateProfile(User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: _headers,
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'user': data['user']};
      } else {
        return {'success': false, 'error': 'Ошибка обновления профиля'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    try {
      // В реальном приложении здесь был бы multipart request
      final response = await http.post(
        Uri.parse('$baseUrl/profile/avatar'),
        headers: _headers,
        body: json.encode({
          'avatarUrl':
              'https://via.placeholder.com/150/CCCCCC/FFFFFF?text=Avatar'
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'avatarUrl': data['avatarUrl']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки аватара'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  // Чаты
  static Future<Map<String, dynamic>> getChats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chats'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'chats': data['chats']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки чатов'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> getChatMessages(
    String chatId, {
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();

      final uri = Uri.parse('$baseUrl/chats/$chatId/messages')
          .replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'messages': data['messages']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки сообщений'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chats/$chatId/messages'),
        headers: _headers,
        body: json.encode({
          'message': message,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'error': 'Ошибка отправки сообщения'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  // База знаний
  static Future<Map<String, dynamic>> getKnowledgeBase() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/knowledge-base'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'articles': data['articles']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки базы знаний'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  // Уведомления
  static Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'notifications': data['notifications']};
      } else {
        return {'success': false, 'error': 'Ошибка загрузки уведомлений'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }

  static Future<Map<String, dynamic>> markNotificationAsRead(
      String notificationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Ошибка обновления уведомления'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Ошибка сети: $e'};
    }
  }
}

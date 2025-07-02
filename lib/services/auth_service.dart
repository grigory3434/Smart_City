import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  // Список администраторов (не сохраняются в SharedPreferences)
  static final List<Map<String, String>> _admins = [
    {
      'email': 'admin@smartcity.ru',
      'password': 'admin123',
      'name': 'Администратор',
      'role': 'admin',
    },
    {
      'email': 'moderator@smartcity.ru',
      'password': 'moderator123',
      'name': 'Модератор',
      'role': 'admin',
    },
  ];

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  AuthService() {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userJson = prefs.getString('user_data');

    if (token != null && userJson != null) {
      try {
        _token = token;
        _user = User.fromJson(json.decode(userJson));
        ApiService.setAuthToken(token);
        notifyListeners();
      } catch (e) {
        await _clearTokens();
      }
    }
  }

  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', json.encode(user.toJson()));
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.login(email, password);

      if (result['success']) {
        _token = result['token'];
        _user = User.fromJson(result['user']);
        ApiService.setAuthToken(_token!);
        await _saveAuthData(_token!, _user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Ошибка сети: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await ApiService.register(name, email, password);

      if (result['success']) {
        _token = result['token'];
        _user = User.fromJson(result['user']);
        ApiService.setAuthToken(_token!);
        await _saveAuthData(_token!, _user!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Ошибка сети: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    await _clearTokens();
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    _user = updatedUser;
    await _saveAuthData(_token!, _user!);
    notifyListeners();
  }

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  // Статические методы для работы с локальной авторизацией

  // Получить текущего пользователя
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_currentUserKey);
    if (userJson != null) {
      try {
        return User.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Вход в систему
  static Future<User?> signIn(String email, String password) async {
    // Проверяем администраторов
    for (final admin in _admins) {
      if (admin['email'] == email && admin['password'] == password) {
        final user = User(
          id: 'admin_${admin['email']}',
          name: admin['name']!,
          email: admin['email']!,
          role: UserRole.admin,
          createdAt: DateTime.now(),
          avatarUrl: null,
        );

        // Сохраняем только сессию администратора
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

        return user;
      }
    }

    // Проверяем обычных пользователей
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      for (final userData in usersList) {
        if (userData['email'] == email && userData['password'] == password) {
          final user = User(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
            role: UserRole.resident,
            createdAt: DateTime.parse(userData['createdAt']),
            avatarUrl: userData['avatarUrl'],
          );

          // Сохраняем сессию пользователя
          await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

          return user;
        }
      }
    }

    return null; // Пользователь не найден
  }

  // Регистрация нового пользователя
  static Future<User?> signUp(
      String name, String email, String password) async {
    // Проверяем, не является ли email администратора
    for (final admin in _admins) {
      if (admin['email'] == email) {
        return null; // Email уже занят администратором
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    List<Map<String, dynamic>> users = [];

    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      users = usersList.cast<Map<String, dynamic>>();

      // Проверяем, не занят ли email
      for (final user in users) {
        if (user['email'] == email) {
          return null; // Email уже занят
        }
      }
    }

    // Создаем нового пользователя
    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password':
          password, // В реальном приложении пароль должен быть зашифрован
      'role': 'resident',
      'avatarUrl': null,
      'createdAt': DateTime.now().toIso8601String(),
    };

    users.add(newUser);

    // Сохраняем обновленный список пользователей
    await prefs.setString(_usersKey, jsonEncode(users));

    // Создаем объект пользователя для возврата
    final user = User(
      id: newUser['id']!,
      name: newUser['name']!,
      email: newUser['email']!,
      role: UserRole.resident,
      createdAt: DateTime.parse(newUser['createdAt']!),
      avatarUrl: newUser['avatarUrl'],
    );

    // Сохраняем сессию пользователя
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));

    return user;
  }

  // Выход из системы
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Обновить профиль пользователя
  static Future<bool> updateProfileStatic(
      String userId, String name, String? avatarUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      List<Map<String, dynamic>> users = usersList.cast<Map<String, dynamic>>();

      for (int i = 0; i < users.length; i++) {
        if (users[i]['id'] == userId) {
          users[i]['name'] = name;
          if (avatarUrl != null) {
            users[i]['avatarUrl'] = avatarUrl;
          }

          // Сохраняем обновленный список
          await prefs.setString(_usersKey, jsonEncode(users));

          // Обновляем текущую сессию
          final updatedUser = User(
            id: users[i]['id']!,
            name: users[i]['name']!,
            email: users[i]['email']!,
            role: UserRole.resident,
            createdAt: DateTime.parse(users[i]['createdAt']!),
            avatarUrl: users[i]['avatarUrl'],
          );
          await prefs.setString(
              _currentUserKey, jsonEncode(updatedUser.toJson()));

          return true;
        }
      }
    }

    return false;
  }

  // Изменить пароль
  static Future<bool> changePassword(
      String userId, String oldPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      List<Map<String, dynamic>> users = usersList.cast<Map<String, dynamic>>();

      for (int i = 0; i < users.length; i++) {
        if (users[i]['id'] == userId && users[i]['password'] == oldPassword) {
          users[i]['password'] = newPassword;

          // Сохраняем обновленный список
          await prefs.setString(_usersKey, jsonEncode(users));
          return true;
        }
      }
    }

    return false;
  }

  // Удалить аккаунт
  static Future<bool> deleteAccount(String userId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      List<Map<String, dynamic>> users = usersList.cast<Map<String, dynamic>>();

      for (int i = 0; i < users.length; i++) {
        if (users[i]['id'] == userId && users[i]['password'] == password) {
          users.removeAt(i);

          // Сохраняем обновленный список
          await prefs.setString(_usersKey, jsonEncode(users));

          // Удаляем текущую сессию
          await prefs.remove(_currentUserKey);

          return true;
        }
      }
    }

    return false;
  }

  // Получить список всех пользователей (только для администраторов)
  static Future<List<User>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList
          .map((userData) => User(
                id: userData['id']!,
                name: userData['name']!,
                email: userData['email']!,
                role: UserRole.resident,
                createdAt: DateTime.parse(userData['createdAt']!),
                avatarUrl: userData['avatarUrl'],
              ))
          .toList();
    }

    return [];
  }

  // Проверить, является ли пользователь администратором
  static bool isAdmin(User user) {
    return user.role == UserRole.admin;
  }

  // Проверить, авторизован ли пользователь
  static Future<bool> checkAuthentication() async {
    final user = await getCurrentUser();
    return user != null;
  }
}

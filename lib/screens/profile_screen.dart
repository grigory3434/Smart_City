import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_screen.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import '../services/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'support_screen.dart';
import 'statistics_screen.dart';
import 'user_management_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService auth = AuthService();
  User? _user;
  bool _isLoading = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = await AuthService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки профиля: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    if (_isLoading) {
      return AnimatedTheme(
        data: theme,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        child: Scaffold(
          appBar: AppBar(
            title: Text(loc.profile),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_user == null) {
      return AnimatedTheme(
        data: theme,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        child: Scaffold(
          appBar: AppBar(
            title: Text(loc.profile),
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  loc.userNotFound ?? 'Пользователь не найден',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text('Войти'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedTheme(
      data: theme,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.profile),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _signOut,
              tooltip: 'Выйти',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар и основная информация
              Center(
                child: Column(
                  children: [
                    // Аватар
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _user!.role == UserRole.admin
                              ? Colors.red.shade100
                              : Colors.blue.shade100,
                          border: Border.all(
                            color: _user!.role == UserRole.admin
                                ? Colors.red.shade300
                                : Colors.blue.shade300,
                            width: 3,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : (_user!.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      _user!.avatarUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildDefaultAvatar();
                                      },
                                    ),
                                  )
                                : _buildDefaultAvatar()),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Имя пользователя
                    Text(
                      _user!.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Роль пользователя
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _user!.role == UserRole.admin
                            ? Colors.red.shade100
                            : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _user!.role == UserRole.admin
                                ? Icons.admin_panel_settings
                                : Icons.person,
                            size: 16,
                            color: _user!.role == UserRole.admin
                                ? Colors.red.shade700
                                : Colors.blue.shade700,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _user!.role == UserRole.admin
                                ? 'Администратор'
                                : 'Пользователь',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _user!.role == UserRole.admin
                                  ? Colors.red.shade700
                                  : Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.camera_alt),
                      label: Text(loc.editPhoto ?? 'Изменить фото'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Информация о пользователе
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.info ?? 'Информация',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow(
                        icon: Icons.email,
                        label: loc.email ?? 'Email',
                        value: _user!.email,
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.person,
                        label: loc.name ?? 'Имя',
                        value: _user!.name,
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.badge,
                        label: loc.id ?? 'ID',
                        value: _user!.id,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Выбор темы
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.theme,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      ListTile(
                        title: Text(loc.themeLight),
                        leading: Radio<AppTheme>(
                          value: AppTheme.light,
                          groupValue:
                              Provider.of<ThemeService>(context).currentTheme,
                          onChanged: (value) {
                            Provider.of<ThemeService>(context, listen: false)
                                .setTheme(value!);
                            ThemeSwitcher.of(context).changeTheme(
                              theme: Provider.of<ThemeService>(context,
                                      listen: false)
                                  .getLightTheme(),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(loc.themeDark),
                        leading: Radio<AppTheme>(
                          value: AppTheme.dark,
                          groupValue:
                              Provider.of<ThemeService>(context).currentTheme,
                          onChanged: (value) {
                            Provider.of<ThemeService>(context, listen: false)
                                .setTheme(value!);
                            ThemeSwitcher.of(context).changeTheme(
                              theme: Provider.of<ThemeService>(context,
                                      listen: false)
                                  .getDarkTheme(),
                            );
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(loc.themeHighContrast),
                        leading: Radio<AppTheme>(
                          value: AppTheme.highContrast,
                          groupValue:
                              Provider.of<ThemeService>(context).currentTheme,
                          onChanged: (value) {
                            Provider.of<ThemeService>(context, listen: false)
                                .setTheme(value!);
                            ThemeSwitcher.of(context).changeTheme(
                              theme: Provider.of<ThemeService>(context,
                                      listen: false)
                                  .getHighContrastTheme(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Выбор языка
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.language,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      ListTile(
                        title: Text(loc.languageRu),
                        leading: Radio<Locale>(
                          value: Locale('ru'),
                          groupValue:
                              Provider.of<LocaleProvider>(context).locale,
                          onChanged: (value) => Provider.of<LocaleProvider>(
                                  context,
                                  listen: false)
                              .setLocale(value!),
                        ),
                      ),
                      ListTile(
                        title: Text(loc.languageEn),
                        leading: Radio<Locale>(
                          value: Locale('en'),
                          groupValue:
                              Provider.of<LocaleProvider>(context).locale,
                          onChanged: (value) => Provider.of<LocaleProvider>(
                                  context,
                                  listen: false)
                              .setLocale(value!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Действия
              if (_user!.role == UserRole.resident) ...[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.edit, color: Colors.blue.shade600),
                        title: Text(loc.editProfile),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          _showEditProfileDialog();
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading:
                            Icon(Icons.lock, color: Colors.orange.shade600),
                        title: Text(loc.changePassword ?? 'Изменить пароль'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          _showChangePasswordDialog();
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.delete_forever,
                            color: Colors.red.shade600),
                        title: Text(loc.deleteAccount ?? 'Удалить аккаунт'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          _showDeleteAccountDialog();
                        },
                      ),
                    ],
                  ),
                ),
              ],

              // Административные функции
              if (_user!.role == UserRole.admin) ...[
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.people, color: Colors.green.shade600),
                        title: Text(
                            loc.manageUsers ?? 'Управление пользователями'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => UserManagementScreen()),
                          );
                        },
                      ),
                      Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.analytics,
                            color: Colors.purple.shade600),
                        title: Text(loc.statistics ?? 'Статистика'),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => StatisticsScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              // Действия
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.support_agent,
                          color: Colors.blue.shade600),
                      title: Text(loc.support),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => SupportScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Кнопка выхода
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _signOut,
                  icon: Icon(Icons.logout),
                  label: Text(loc.logout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      _user!.role == UserRole.admin ? Icons.admin_panel_settings : Icons.person,
      size: 60,
      color: _user!.role == UserRole.admin
          ? Colors.red.shade600
          : Colors.blue.shade600,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.editProfile),
        content: Text(loc.editProfileFeatureSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.changePassword),
        content: Text(loc.changePasswordFeatureSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deleteAccount),
        content: Text(
            'Функция удаления аккаунта будет доступна в следующем обновлении'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await AuthService.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Выберите источник'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('Камера'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('Галерея'),
          ),
        ],
      ),
    );
    if (source != null) {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
        // Здесь можно добавить загрузку на сервер или сохранение в профиле
      }
    }
  }
}

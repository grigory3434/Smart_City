import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _selectedRole = 'Все';

  // Демонстрационные данные пользователей
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Иван Иванов',
      'email': 'ivanov@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Мария Смирнова',
      'email': 'smirnova@mail.ru',
      'role': 'Волонтёр',
      'blocked': false
    },
    {
      'name': 'Пётр Петров',
      'email': 'petrov@mail.ru',
      'role': 'Житель',
      'blocked': true
    },
    {
      'name': 'Анна Кузнецова',
      'email': 'kuznetsova@mail.ru',
      'role': 'Администратор',
      'blocked': false
    },
    {
      'name': 'Сергей Волков',
      'email': 'volkov@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Ольга Соколова',
      'email': 'sokolova@mail.ru',
      'role': 'Волонтёр',
      'blocked': false
    },
    {
      'name': 'Алексей Морозов',
      'email': 'morozov@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Екатерина Новикова',
      'email': 'novikova@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Дмитрий Фёдоров',
      'email': 'fedorov@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Татьяна Попова',
      'email': 'popova@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Владимир Лебедев',
      'email': 'lebedev@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
    {
      'name': 'Ирина Козлова',
      'email': 'kozlova@mail.ru',
      'role': 'Житель',
      'blocked': false
    },
  ];

  List<String> get roles => ['Все', 'Житель', 'Волонтёр', 'Администратор'];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final filteredUsers = _selectedRole == 'Все'
        ? users
        : users.where((u) => u['role'] == _selectedRole).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.manageUsers),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Роль:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedRole,
                  items: roles
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedRole = val!),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: filteredUsers.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, i) {
                  final user = filteredUsers[i];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: user['role'] == 'Администратор'
                          ? Colors.red.shade200
                          : user['role'] == 'Волонтёр'
                              ? Colors.orange.shade200
                              : Colors.blue.shade200,
                      child: Icon(
                        user['role'] == 'Администратор'
                            ? Icons.admin_panel_settings
                            : user['role'] == 'Волонтёр'
                                ? Icons.volunteer_activism
                                : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(user['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle:
                        Text('${user['email']}\n${user['role']}', maxLines: 2),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (user['role'] != 'Администратор')
                          IconButton(
                            icon: Icon(
                                user['blocked'] ? Icons.lock_open : Icons.lock,
                                color: user['blocked']
                                    ? Colors.green
                                    : Colors.red),
                            tooltip: user['blocked']
                                ? 'Разблокировать'
                                : 'Заблокировать',
                            onPressed: () {
                              setState(() {
                                user['blocked'] = !user['blocked'];
                              });
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

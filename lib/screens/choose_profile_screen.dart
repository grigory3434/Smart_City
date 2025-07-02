import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user.dart';

class ChooseProfileScreen extends StatelessWidget {
  final List<User> profiles;
  final void Function(User) onSelect;
  const ChooseProfileScreen({required this.profiles, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.chooseProfile),
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(24),
        itemCount: profiles.length,
        separatorBuilder: (_, __) => SizedBox(height: 20),
        itemBuilder: (context, i) {
          final user = profiles[i];
          return Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.role == UserRole.admin
                    ? Colors.red.shade100
                    : Colors.blue.shade100,
                child: user.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(user.avatarUrl!,
                            width: 40, height: 40, fit: BoxFit.cover))
                    : Icon(
                        user.role == UserRole.admin
                            ? Icons.admin_panel_settings
                            : Icons.person,
                        color: user.role == UserRole.admin
                            ? Colors.red
                            : Colors.blue),
              ),
              title: Text(user.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  user.role == UserRole.admin ? 'Администратор' : loc.profile),
              trailing: ElevatedButton(
                onPressed: () => onSelect(user),
                child: Text(loc.save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: user.role == UserRole.admin
                      ? Colors.red.shade600
                      : Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

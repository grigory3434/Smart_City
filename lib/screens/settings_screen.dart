import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_service.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
        leading: BackButton(),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(loc.theme,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: Text(loc.themeLight),
            leading: Radio<AppTheme>(
              value: AppTheme.light,
              groupValue: themeService.currentTheme,
              onChanged: (value) => themeService.setTheme(value!),
            ),
          ),
          ListTile(
            title: Text(loc.themeDark),
            leading: Radio<AppTheme>(
              value: AppTheme.dark,
              groupValue: themeService.currentTheme,
              onChanged: (value) => themeService.setTheme(value!),
            ),
          ),
          ListTile(
            title: Text(loc.themeHighContrast),
            leading: Radio<AppTheme>(
              value: AppTheme.highContrast,
              groupValue: themeService.currentTheme,
              onChanged: (value) => themeService.setTheme(value!),
            ),
          ),
          SizedBox(height: 24),
          Text(loc.language,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: Text(loc.languageRu),
            leading: Radio<Locale>(
              value: Locale('ru'),
              groupValue: localeProvider.locale,
              onChanged: (value) => localeProvider.setLocale(value!),
            ),
          ),
          ListTile(
            title: Text(loc.languageEn),
            leading: Radio<Locale>(
              value: Locale('en'),
              groupValue: localeProvider.locale,
              onChanged: (value) => localeProvider.setLocale(value!),
            ),
          ),
        ],
      ),
    );
  }
}

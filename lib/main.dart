import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'services/theme_service.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'dart:math';
import 'services/locale_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class ThemeAnimatedSwitcher extends StatefulWidget {
  final ThemeData theme;
  final Widget child;
  const ThemeAnimatedSwitcher(
      {required this.theme, required this.child, Key? key})
      : super(key: key);

  @override
  State<ThemeAnimatedSwitcher> createState() => _ThemeAnimatedSwitcherState();
}

class _ThemeAnimatedSwitcherState extends State<ThemeAnimatedSwitcher>
    with SingleTickerProviderStateMixin {
  late ThemeData _oldTheme;
  late ThemeData _newTheme;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _oldTheme = widget.theme;
    _newTheme = widget.theme;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(covariant ThemeAnimatedSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.theme != oldWidget.theme) {
      _oldTheme = oldWidget.theme;
      _newTheme = widget.theme;
      _isAnimating = true;
      _controller.forward(from: 0).then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (!_isAnimating) {
          return Theme(data: _newTheme, child: widget.child);
        }
        return Stack(
          children: [
            Theme(data: _oldTheme, child: widget.child),
            ClipPath(
              clipper: _CircleRevealClipper(
                fraction: _animation.value,
                origin: Offset(0, MediaQuery.of(context).size.height),
                maxRadius: sqrt(pow(MediaQuery.of(context).size.width, 2) +
                    pow(MediaQuery.of(context).size.height, 2)),
              ),
              child: Theme(data: _newTheme, child: widget.child),
            ),
          ],
        );
      },
    );
  }
}

class _CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset origin;
  final double maxRadius;
  _CircleRevealClipper(
      {required this.fraction, required this.origin, required this.maxRadius});

  @override
  Path getClip(Size size) {
    final radius = maxRadius * fraction;
    return Path()..addOval(Rect.fromCircle(center: origin, radius: radius));
  }

  @override
  bool shouldReclip(_CircleRevealClipper oldClipper) =>
      oldClipper.fraction != fraction;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      title: 'Умный Город',
      theme: themeService.getCurrentThemeData(),
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
      themeAnimationDuration: Duration(milliseconds: 500),
      themeAnimationCurve: Curves.easeInOut,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _startSplashAndInit();
  }

  Future<void> _startSplashAndInit() async {
    final start = DateTime.now();
    await _checkAuthStatus();
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    final minSplash = 2000;
    if (elapsed < minSplash) {
      await Future.delayed(Duration(milliseconds: minSplash - elapsed));
    }
    setState(() {});
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await AuthService.checkAuthentication();
      _isAuthenticated = isAuth;
      _isLoading = false;
    } catch (e) {
      _isAuthenticated = false;
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SplashScreen(onFinish: () {});
    }
    return _isAuthenticated ? HomeScreen() : LoginScreen();
  }
}

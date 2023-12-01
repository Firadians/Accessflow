import 'package:flutter/material.dart';
import 'package:accessflow/main_navigation.dart';
import 'package:accessflow/auth/presentation/login_screen.dart';
import 'dart:async';
import 'package:accessflow/auth/data/preferences/shared_preference.dart';
import 'package:accessflow/utils/app_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:accessflow/onboarding/onboarding_screen.dart';
import 'package:accessflow/auth/data/repositories/user_repository.dart';
import 'package:accessflow/utils/strings.dart';

class SplashScreen extends StatefulWidget {
  final AppDependencies dependencies;

  SplashScreen({Key? key, required this.dependencies}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  final SharedPreference sharedPreference = SharedPreference();
  UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen (e.g., 2 seconds)
    Timer(Duration(seconds: 2), () async {
      String? token = await sharedPreference.getTokenFromSharedPreferences();
      String? position =
          await sharedPreference.getPositionFromSharedPreferences();
      bool firstTime = await _isFirstTime();
      int? statusCode = await userRepository.checkLoginAccess(token);

      if (firstTime) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(),
          ),
        );
      } else {
        if (MainAssets.levelOnePosition.contains(position) &&
            statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else if (MainAssets.levelTwoPosition.contains(position) &&
            statusCode == 200) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainNavigation(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        }
      }
    });

    // Start the fade-in animation after a short delay (e.g., 1 second)
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  // Check if it's the first time the app is opened
  Future<bool> _isFirstTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
      if (isFirstTime) {
        prefs.setBool('isFirstTime', false);
      }
      return isFirstTime;
    } catch (error) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          child: Image.asset(UtilsAssets.iconSplashImage),
        ),
      ),
    );
  }
}

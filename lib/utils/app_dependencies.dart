import 'package:shared_preferences/shared_preferences.dart';

class AppDependencies {
  final SharedPreferences sharedPreferences;

  AppDependencies({
    required this.sharedPreferences,
  });
}

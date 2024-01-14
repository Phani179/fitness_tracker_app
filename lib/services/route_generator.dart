
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:fitness_tracker_app/screens/achievements.dart';
import 'package:fitness_tracker_app/screens/profile_edit.dart';
import 'package:fitness_tracker_app/screens/home.dart';
import 'package:fitness_tracker_app/screens/auth.dart';


// For future Scope.
class RouteGenerator {
  Route? onGenerateRoute(RouteSettings settings) {
    Object? arguments;
    if (settings.arguments != null) {
      arguments = settings.arguments;
    }
    switch (settings.name) {
      case AuthScreen.routeName:
        return MaterialPageRoute(
          builder: (ctx) => const AuthScreen(),
          settings: const RouteSettings(
            name: AuthScreen.routeName,
          ),
        );
      case HomeScreen.routeName :
        return MaterialPageRoute(
          builder: (ctx) => HomeScreen(user: arguments as User,),
          settings: const RouteSettings(
            name: HomeScreen.routeName,
          ),
        );
      case AchievementsScreen.routeName :
        return MaterialPageRoute(
          builder: (ctx) => const AchievementsScreen(),
          settings: const RouteSettings(
            name: AchievementsScreen.routeName,
          ),
        );
      case ProfileEditScreen.routeName :
        return MaterialPageRoute(
          builder: (ctx) => const ProfileEditScreen(),
          settings: const RouteSettings(
            name: ProfileEditScreen.routeName,
          ),
        );
    }
    return null;
  }
}

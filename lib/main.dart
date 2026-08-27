import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/teacher/presentation/screens/teacher_home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PrepPilotApp(),
    ),
  );
}

class PrepPilotApp extends ConsumerWidget {
  const PrepPilotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: 'PrepPilot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (user) {
          if (user != null) {
            // Nettoyage et conversion en minuscule de la chaîne
            final role = user.role.toString().toLowerCase();

            // Verification plus souple (gère les enums comme UserRole.teacher ou les sous-chaînes)
            if (role.contains('teacher') || role.contains('professeur') || role.contains('prof')) {
              return const TeacherHomeScreen();
            }
            
            return HomeScreen(user: user);
          }
          return const LoginScreen();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppTheme.accentOrange),
          ),
        ),
        error: (error, stack) {
          debugPrint('Erreur d AuthState: $error');
          return const LoginScreen();
        },
      ),
    );
  }
}
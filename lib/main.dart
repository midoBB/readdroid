import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'pages/signin.dart';
import 'pages/main.dart';
import 'app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            theme: AppColors.lightTheme,
            darkTheme: AppColors.darkTheme,
            themeMode: ThemeMode.system, // Follows system light/dark mode
            home: authProvider.isAuthenticated ? Main() : SignIn(),
          );
        },
      ),
    );
  }
}

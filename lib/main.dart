import 'package:flutter/material.dart';
import 'package:fquery/fquery.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'pages/signin.dart';
import 'pages/main.dart';
import 'app_colors.dart';

final queryClient = QueryClient(
  defaultQueryOptions: DefaultQueryOptions(),
);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return QueryClientProvider(
        queryClient: queryClient,
        child: ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return MaterialApp(
                theme: AppColors.lightTheme,
                darkTheme: AppColors.darkTheme,
                themeMode: ThemeMode.system, // Follows system light/dark mode
                home: authProvider.isLoading
                    ? const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      )
                    : (authProvider.isAuthenticated ? Main() : SignIn()),
              );
            },
          ),
        ));
  }
}

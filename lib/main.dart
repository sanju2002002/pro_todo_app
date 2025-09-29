import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/todo_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart'; // New Import
import 'screens/login_screen.dart'; // New Import
import 'screens/todo_list_screen.dart';
import 'utils/constants.dart';

void main() {
  // Optional: Add WidgetsFlutterBinding.ensureInitialized();
  // if you plan to use local storage or other async features on startup.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Add AuthProvider to the MultiProvider list
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ), // Added AuthProvider
      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            // 2. Apply the dynamic theme from ThemeProvider
            theme: themeProvider.currentTheme,

            // 3. Implement the Auth Gate Widget as the home screen
            home: const AuthGate(),

            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

// 4. The New Impressive Auth Gate Widget
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the AuthProvider to automatically rebuild when isLoggedIn changes
    final authProvider = Provider.of<AuthProvider>(context);

    // Use an AnimatedSwitcher for a smooth, impressive transition between screens
    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 500,
      ), // AppDesign.durationLong for smooth transition
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Use a FadeTransition for a modern, gentle screen change
        return FadeTransition(opacity: animation, child: child);
      },
      // Determine which screen to show
      child: authProvider.isLoggedIn
          ? const TodoListScreen(key: ValueKey('TodoList'))
          : const LoginScreen(key: ValueKey('Login')),
    );
  }
}

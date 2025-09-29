import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Use controllers to manage input fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin(BuildContext context) async {
    // Basic validation
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      // You can show a SnackBar error here
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay for a better loading experience
    await Future.delayed(const Duration(milliseconds: 1500));

    final auth = Provider.of<AuthProvider>(context, listen: false);
    auth.login(_usernameController.text, _passwordController.text);

    // The screen will automatically navigate away since AuthProvider changes state,
    // but if it didn't, we'd stop loading here.
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the current theme for colors
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. Remove AppBar for a full-screen, immersive experience
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 2. Prominent App Logo/Title
              Icon(
                Icons.task_alt, // A relevant icon
                size: 80,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 48),

              // 3. Custom Text Input Fields (using ThemeProvider's styling)
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Username or Email',
                  hintText: 'e.g., user@example.com',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),

              const SizedBox(height: 50),

              // 4. Stylish Login Button with Loading State
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    // Use a primary color or a subtle gradient
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: colorScheme.onPrimary,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          'LOG IN',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. Secondary Action (e.g., Forgot Password)
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password logic
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: colorScheme.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

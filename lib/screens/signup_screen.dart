import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  Future<void> _signUpAndSaveUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Gegg',
                style: theme.textTheme.displayLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                'Sign Up',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Enter Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Enter Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Enter Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Enter Phone Number',
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _signUpAndSaveUser(context),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 16),
              Text(
                "Already have an account?",
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: const Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

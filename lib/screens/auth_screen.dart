import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController(); // Added for name input
  bool isLogin = true;
  bool isLoading = false;

  Future<void> authenticate() async {
    setState(() => isLoading = true);

    try {
      if (isLogin) {
        // ✅ Login user
        final response = await supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (response.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        }
      } else {
        // ✅ Sign up user
        final response = await supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        final user = response.user;
        if (user != null) {
          // ✅ Wait for session to confirm user existence
          await Future.delayed(const Duration(seconds: 2));

          // ✅ Insert user data into the "users" table (Only if email is verified)
          await supabase.from('users').insert({
            'id': user.id, // Ensure "id" in Supabase is a UUID column
            'email': emailController.text.trim(),
            'name': nameController.text.trim(),
            'created_at': DateTime.now().toIso8601String(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-up successful! Please check your email for verification.')),
          );

          setState(() => isLogin = true); // Switch to login mode after sign-up
        }
      }
    } catch (e) {

      print('Error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (!isLogin) // Show name field only for signup
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: authenticate,
                    child: Text(isLogin ? 'Login' : 'Sign Up'),
                  ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Create an account' : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true;

  Future<void> authenticate() async {
    try {
      if (isLogin) {
        await supabase.auth.signInWithPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        await supabase.auth.signUp(
          email: emailController.text,
          password: passwordController.text,
        );
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: authenticate, child: Text(isLogin ? 'Login' : 'Sign Up')),
            TextButton(onPressed: () => setState(() => isLogin = !isLogin), child: Text(isLogin ? 'Create an account' : 'Already have an account? Login')),
          ],
        ),
      ),
    );
  }
}
// key:https://qtyewlbglotrsfdivxms.supabase.co
//  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0eWV3bGJnbG90cnNmZGl2eG1zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5MjY4NjAsImV4cCI6MjA1NjUwMjg2MH0.FvseGcwv3d3Wgua6XQtOJaMuwhcLQW6y7dMitUGpH1I

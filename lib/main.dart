import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthChecker(), 
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return FutureBuilder(
      future: Future.value(supabase.auth.currentUser),
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen(); // ✅ Go to HomeScreen if logged in
        } else {
          return const AuthScreen(); // ✅ Go to AuthScreen if not logged in
        }
      },
    );
  }
}

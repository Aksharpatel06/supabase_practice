import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qtyewlbglotrsfdivxms.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0eWV3bGJnbG90cnNmZGl2eG1zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5MjY4NjAsImV4cCI6MjA1NjUwMjg2MH0.FvseGcwv3d3Wgua6XQtOJaMuwhcLQW6y7dMitUGpH1I',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

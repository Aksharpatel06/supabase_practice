import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await supabase.auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthScreen()));
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rbricks_test/view/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA6PuF5wQVFlczDjvhUnZbm0HyCyTMu1V8",
      appId: "1:577984268051:android:927ffcd5cfe07c15597ce6",
      messagingSenderId: "577984268051",
      projectId: "todoapp-9c7ce",
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
      debugShowCheckedModeBanner: false,
    return const MaterialApp(home: LoginScreen());
  }
}

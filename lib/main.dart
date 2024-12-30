import 'package:flutter/material.dart';
import 'login.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitaplık Uygulaması',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // Navigate to the login page on app launch
    );
  }
}

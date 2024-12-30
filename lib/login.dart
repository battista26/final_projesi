import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'library.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
/*
Future<void> loginUser(
    String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Giriş Yapıldı')),
    );
    print('Giriş Yapıldı');
    // Navigate to the next screen
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Giriş Yapılamadı: ${e.message}')),
    );
  }
}

Future<void> signUpUser(
    String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kayıt Başarılı')),
    );
    print('Kayıt Başarılı');
    // Navigate to the next screen
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kayıt Başarısız: ${e.message}')),
    );
  }
}
*/

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0DC),
      appBar: AppBar(
        title: Text(
          'Giriş Sayfası',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/bookshelf.png', // Ensure this image exists in your assets folder
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              'Kitaplık Uygulaması',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0BB78),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController, // Attach the email controller
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController, // Attach the password controller
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Get the email and password from the controllers
                String email = emailController.text;
                String password = passwordController.text;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LibraryPage()),
                );
              },
              child: Text(
                'Giriş Yap',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Get the email and password from the controllers
                String email = emailController.text;
                String password = passwordController.text;
              },
              child: Text(
                'Kaydol',
                style: GoogleFonts.notoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

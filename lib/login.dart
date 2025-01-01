import 'package:final_projesi/library.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart'; // Import the database helper

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> loginUser(
      String username, String password, BuildContext context) async {
    final user = await DatabaseHelper().getUser(username);
    if (user != null && user['password'] == password) {
      // Successfully logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş Yapıldı')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LibraryPage()),
      );
    } else {
      // Invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Giriş Yapılamadı: Geçersiz kullanıcı adı veya şifre')),
      );
    }
  }

  Future<void> signUpUser(
      String username, String password, BuildContext context) async {
    final existingUser = await DatabaseHelper().getUser(username);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bu kullanıcı adı zaten mevcut')),
      );
      return;
    }

    await DatabaseHelper().insertUser(username, password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kayıt Başarılı')),
    );
  }

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
              controller: usernameController, // Attach the email controller
              decoration: const InputDecoration(
                labelText: 'Kullanıcı Adı',
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
                String username = usernameController.text;
                String password = passwordController.text;

                loginUser(username, password, context);
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
                String username = usernameController.text;
                String password = passwordController.text;

                signUpUser(username, password, context);
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

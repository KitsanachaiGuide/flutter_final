import 'dart:convert';
import 'dart:async';
import 'package:flutter_final/tab_menu_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logoHero',
              child: Material(
                color: Colors.transparent,
                child: Image.asset(
                  'img/logo.png',
                  width: 350,
                  height: 350,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Guide Applications',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontFamily: 'YourCustomFont',
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse('https://www.melivecode.com/api/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': _usernameController.text,
      'password': _passwordController.text
    });

    final res = await http.post(url, headers: headers, body: body);
    final jsonRes = jsonDecode(res.body);
    _showSnackBar(jsonRes['message']);
    if (res.statusCode == 200) {
      _navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => TabeMenuPage(
                username: jsonRes['user']['username'],
                avatar: jsonRes['user']['avatar'],
              )));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => Scaffold(
                    body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'img/logo.png',
                            width: 150,
                            height: 150,
                          ),
                          TextFormField(
                            controller: _usernameController,
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                              onPressed: () {
                                _login();
                              },
                              child: const Text('Login'))
                        ],
                      ),
                    ),
                  ),
                )));
      },
    );
  }
}

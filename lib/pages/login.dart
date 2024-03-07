import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    // ตรวจสอบข้อมูลการเข้าสู่ระบบ
    // ...
    print(_emailController.text);
    print(_passwordController.text);

    String email = _emailController.text;
    String password = _passwordController.text;
    var json = jsonEncode({"email": email, "password": password});

    var url = Uri.parse("https://642021154.pungpingcoding.online/api/login");
    var response = await http.post(url,
        body: json,
        headers: {HttpHeaders.contentTypeHeader: "application/json"});

    print(response.statusCode);

    if (response.statusCode == 200) {
      //
      print(response.body);
      var jsonStr = jsonDecode(response.body);
      print(jsonStr['user']);
      print(jsonStr['token']);

      SharedPreferences _pref = await pref;
      await _pref.setString('username', jsonStr['user']['name']);
      await _pref.setInt('userid', jsonStr['user']['id']);
      await _pref.setInt('token', jsonStr['token']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login'),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Ussernamer'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("เข้าสู่ระบบ"),
            ),
          ],
        ),
      ),
    );
  }
}

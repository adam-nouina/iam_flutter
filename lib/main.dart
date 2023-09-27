import 'package:flutter/material.dart';
import 'package:iam/pages/Home2.dart';
import 'package:iam/pages/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token'); // Retrieve the token

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token; // Make sure token is of type String?
  const MyApp({@required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = false; // Default to not logged in

    if (token != null) {
      try {
        isLoggedIn = !JwtDecoder.isExpired(token!);
      } catch (e) {
        print("Error decoding token: $e");
        // Handle the error, e.g., by treating it as an invalid token
      }
    }

    // Check if the user is logged in and the token is valid
        if (isLoggedIn) {
          return  MaterialApp(
            title: 'Coding with Curry',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: Home2(token: token) ,
          );
        } else {
          // Redirect the user to the login page
          return MaterialApp(
            home:LoginPage(),
          );
        }
      }
  }
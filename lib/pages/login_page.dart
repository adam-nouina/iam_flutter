import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iam/pages/Home2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref () async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Function to send a login request
    Future<void> sendLoginRequest(String username, String password) async {
      try {
        final url = Uri.parse('https://ospc.hashkey.ma/api/auth/login'); // Replace with your API endpoint
        final response = await http.post(
          url,
          body: {
            'email': username,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          // Successful login, handle the response here
          // You can navigate to the Home2 screen or perform other actions
          print('logged in');
          print(jsonResponse['token']);
          prefs.setString('token', jsonResponse['token']);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Home2(token: jsonResponse['token'])));
        } else {
          final snackBar = SnackBar(
            content: Text('Email ou mot de passe incorrect'),
            behavior: SnackBarBehavior.floating, // Display from the top
            margin: EdgeInsets.only(top: 16.0), // Adjust the top margin as needed
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
      } catch (e) {
        print(e.toString());
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg4.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: screenWidth * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                Container(
                  child: Image.asset(
                    'images/logo.png',
                    height: 70,
                  ),
                ),

                const SizedBox(height: 75),

                // username textfield
                Container(
                  child: TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white, // Set your desired background color here
                      hintText: 'Nom d\'utilisateur',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter', // Set your desired font family
                        fontSize: 14, // Set your desired font size
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5), // Set your desired border radius
                        borderSide: BorderSide.none, // Remove the default border
                      ),
                    ),
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 10),

                // password textfield
                Container(
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mot de passe', // Set the different hint text here
                      hintStyle: TextStyle(
                        fontFamily: 'Inter', // Set your desired font family
                        fontSize: 14, // Set your desired font size
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    obscureText: true, // Set this to true for password input
                  ),
                ),

                const SizedBox(height: 10),

                // forgot password?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Mot de passe oublié?',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 55),

                ElevatedButton(
                  onPressed: () {
                    // Call the sendLoginRequest function with the username and password
                    final username = usernameController.text;
                    final password = passwordController.text;
                    sendLoginRequest(username, password);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[800], // Set the background color to blue
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 15), // Set your desired top and bottom padding
                    child: Text(
                      'Se connecter',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white, // Set the text color to white
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

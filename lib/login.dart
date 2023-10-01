import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'register.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gwfront/newsensor.dart';
import 'sensorspage.dart';

Map<String, dynamic> userData = {
  "email": "user_email@example.com",
  "password": "user_password",
};

int userId = 0;

int responseCode = 0;

void checkUser() async {
  final String apiUrl = 'http://192.168.100.29:8000/api/authenticate/';

  String userDataJson = jsonEncode(userData);

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: userDataJson,
  );

  responseCode = response.statusCode;

  if (response.statusCode == 200) {
    print('POST request successful');
  } else {
    print('POST request failed with status code: ${response.statusCode}');
  }
}


class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String? emailText;
  String? passwordText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/image2.png',
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Image.asset(
                'assets/gradient.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3 - 165,
              left: MediaQuery.of(context).size.width / 2 - 175,
              child: Image.asset(
                'assets/logo.png',
                width: 350,
                height: 350,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Center(
                      // Wrap with Center widget
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.07,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: pass,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    InkWell(
                      onTap: () {
                        // Navigate to the Register page here
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Register(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 500)));
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: const TextSpan(
                              text: "Don’t have an account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: "Register here",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18, // Increase font size
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            emailText = email.text;
                            passwordText = pass.text;

                            userData["email"] = emailText;
                            userData["password"] = passwordText;

                            //if responseCode == 200 atunci sa treaca pe urmatoare
                            //pagina, else sa ramana pe pagina de login

                            checkUser();
                          });
                          if (responseCode == 200) {
                            userId = userData["id"];
                            print("USER ID: $userId");
                            if (sensor_id.isEmpty) {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Homepage(),
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      duration: Duration(milliseconds: 500)));
                            } else {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Sensors(),
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      duration: Duration(milliseconds: 500)));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: const Color(0xFF17594A),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

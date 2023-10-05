import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'homepage.dart';
import 'login.dart';
import 'sensorspage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'newsensor.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List sensor_data = [];
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirm = TextEditingController();
  String? nameText;
  String? emailText;
  String? passwordText;
  String? confirmText;

  void getData() async {
    final url = Uri.parse('http://192.168.100.29:8000/apiRest/recommendations/'); // Replace with your Django server URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      setState(() {
        sensor_data = jsonDecode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/image2.png',
                  width: double.infinity,
                  height: 1500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  'assets/Rectangle1.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3 - 320,
              left: MediaQuery.of(context).size.width / 2 - 175,
              child: Image.asset(
                'assets/logo.png',
                width: 350,
                height: 350,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 140,
              bottom: MediaQuery.of(context).size.height * 0.00,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  // Wrap with ListView
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Register',
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
                        controller: name,
                        decoration: InputDecoration(
                          hintText: 'Name',
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
                        controller: confirm,
                        decoration: InputDecoration(
                          hintText: 'Confirm password',
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
                    Center(
                      child: InkWell(
                        onTap: () {
                          // Navigate to the Login page here
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Login(),
                                  type: PageTransitionType.fade,
                                  duration: Duration(milliseconds: 500)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login here",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
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
                            nameText = name.text;
                            emailText = email.text;
                            passwordText = pass.text;
                            confirmText = confirm.text;
                          });
                          if (sensor_id.isEmpty) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Homepage(),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 500)));
                          } else {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Sensors(),
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    duration: Duration(milliseconds: 500)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                              color: const Color(0xFF17594A),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

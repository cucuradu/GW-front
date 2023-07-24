import 'package:flutter/material.dart';
import 'register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
              top: MediaQuery.of(context).size.height / 3 - 175,
              left: MediaQuery.of(context).size.width / 2 - 175,
              child: Image.asset(
                'assets/logo.png',
                width: 350,
                height: 350,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3 +
                  200, // Adjust the vertical position as needed
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32, // Increase font size
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      width: double.infinity, // Adjust width as needed
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: double.infinity, // Adjust width as needed
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // Navigate to the Register page here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Don't have an account? Register here",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      width: double.infinity, // Adjust width as needed
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.yellow,
                        ),
                        child: Text(
                          'SIGN IN',
                          style:
                              TextStyle(color: Color(0xFF17594A), fontSize: 20),
                        ),
                      ),
                    ),
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

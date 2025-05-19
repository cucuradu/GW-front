import 'package:flutter/material.dart';
import 'package:gwfront/homepage.dart';
import 'package:gwfront/newsensor.dart';
import 'package:gwfront/sensorspage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'Theme/theme_provider.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  Profile({super.key});
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  _Profile();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final buttonLabel = isDarkMode ? "Light Mode" : "Dark Mode";

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.035),
          Center(
            child: Image.asset(
              'assets/profileimg.png',
              height: MediaQuery.of(context).size.height * 0.26,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Text(
            'Alex',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Divider(
            height: 3,
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'E-mail',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ap542975@gmail.com',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          Divider(
            height: 3,
            color: Colors.grey,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
              ),
              child: Container(
                width: double.infinity,
                height: 57,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      buttonLabel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: MediaQuery.of(context).size.width * 0.055,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

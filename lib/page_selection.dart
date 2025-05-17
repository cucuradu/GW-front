import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gwfront/sensorspage.dart';
import 'newsensor.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import 'profilepage.dart';
import 'sensordetails.dart';

class PageSelection extends StatefulWidget {
  const PageSelection({super.key});

  @override
  State<PageSelection> createState() => _PageSelectionState();
}

class _PageSelectionState extends State<PageSelection> {
  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    Sensors(
      mySensors: [],
    ),
    NewSensor(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 60,
            height: 60,
            child: Image.asset('assets/profileimg.png'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: "Hi, ",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.normal,
            ),
            children: [
              TextSpan(
                text: "Alex",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Login()),
              // );
            },
            child: Image.asset(
              'assets/minilogo.png',
              height: AppBar().preferredSize.height - 16,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: GNav(
          color: Theme.of(context).colorScheme.background,
          activeColor: const Color.fromARGB(255, 102, 102, 255),
          tabBackgroundColor:
              Colors.transparent, // We'll style backgrounds manually
          gap: 12,
          haptic: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          tabs: [
            // Left Button
            GButton(
              icon: Icons.circle,
              backgroundColor: Colors.transparent,
              leading: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  color: _selectedIndex == 0
                      ? Colors.grey.shade200
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/flower.png',
                    height: 60, // Bigger image
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Middle Button (Always Green, Smaller Icon)
            GButton(
              icon: Icons.circle,
              backgroundColor: Colors.transparent,
              leading: Container(
                height: 75,
                width: 75,
                decoration: const BoxDecoration(
                  color: Color(0xFF8EAC50), // Always green
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/whiteplus.png',
                    height: 20, // Smaller icon inside
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Right Button
            GButton(
              icon: Icons.circle,
              backgroundColor: Colors.transparent,
              leading: Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  color: _selectedIndex == 2
                      ? Colors.grey.shade200
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/profile.png',
                    height: 60, // Bigger image
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

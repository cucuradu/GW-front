import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gwfront/homepage.dart';
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
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      Homepage(
        onNavigate: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      Sensors(
        mySensors: [],
      ),
      NewSensor(
        isNavigated: false,
        onSensorAdded: () {
          setState(() {
            _selectedIndex = 1; // Switch to Sensors tab
          });
        },
      ),
      Profile()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/minilogo.png',
          height: 40,
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Color(0xFF8EAC50),
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color(0xFF8EAC50).withOpacity(0.1),
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.6),
              tabs: [
                GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.local_florist_rounded,
                  text: 'Sensors',
                ),
                GButton(
                  icon: Icons.add_circle_outline,
                  text: 'Add',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
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
        ),
      ),
    );
  }
}

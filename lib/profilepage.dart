import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Theme/theme_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  bool _isCelsius = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _isCelsius = prefs.getBool('isCelsius') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final backgroundColor = isDarkMode ? Color(0xFF17181F) : Colors.grey[100];
    final cardColor = isDarkMode ? Color(0xFF2A2B36) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // Profile Header
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cardColor,
                    image: DecorationImage(
                      image: AssetImage('assets/profileimg.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Alex",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "growwise@gmail.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: subTextColor,
                  ),
                ),
                SizedBox(height: 40),

                // Settings Section
                _buildSectionHeader("Settings", textColor),
                SizedBox(height: 15),
                _buildSettingsTile(
                  context,
                  icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  title: isDarkMode ? "Light Mode" : "Dark Mode",
                  color: Colors.purple,
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeColor: Color(0xFF8EAC50),
                  ),
                ),
                SizedBox(height: 15),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_outlined,
                  title: "Notifications",
                  color: Colors.orange,
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    setState(() {
                      _notificationsEnabled = !_notificationsEnabled;
                    });
                    _saveSetting('notifications', _notificationsEnabled);
                  },
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSetting('notifications', value);
                    },
                    activeColor: Color(0xFF8EAC50),
                  ),
                ),
                SizedBox(height: 15),
                _buildSettingsTile(
                  context,
                  icon: Icons.thermostat,
                  title: "Units",
                  color: Colors.redAccent,
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    setState(() {
                      _isCelsius = !_isCelsius;
                    });
                    _saveSetting('isCelsius', _isCelsius);
                  },
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF8EAC50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      _isCelsius ? "Celsius (°C)" : "Fahrenheit (°F)",
                      style: TextStyle(
                        color: Color(0xFF8EAC50),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                _buildSettingsTile(
                  context,
                  icon: Icons.language,
                  title: "Language",
                  color: Colors.blue,
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    // Cycle languages for demo
                    setState(() {
                      if (_selectedLanguage == 'English') {
                        _selectedLanguage = 'Romanian';
                      } else {
                        _selectedLanguage = 'English';
                      }
                    });
                    _saveSetting('language', _selectedLanguage);
                  },
                  trailing: Text(
                    _selectedLanguage,
                    style: TextStyle(color: subTextColor),
                  ),
                ),

                SizedBox(height: 30),
                _buildSectionHeader("Support", textColor),
                SizedBox(height: 15),
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  color: Colors.green,
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {},
                ),
                SizedBox(height: 15),
                _buildSettingsTile(
                  context,
                  icon: Icons.logout,
                  title: "Log Out",
                  color: Colors.red,
                  cardColor: cardColor,
                  textColor: textColor,
                  onTap: () {
                    // Handle logout
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textColor,
            ),
          ),
          trailing: trailing ??
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gwfront/analysis_page.dart';
import 'package:gwfront/watering_page.dart';
import 'package:gwfront/widgets/system_summary_card.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:gwfront/services/weather_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gwfront/services/ml_prediction_service.dart';
import 'package:gwfront/widgets/smart_recommendation_card.dart';
import 'package:gwfront/widgets/skeleton_loader.dart';

class Homepage extends StatefulWidget {
  final Function(int) onNavigate;

  Homepage({super.key, required this.onNavigate});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double _temp = 0;
  double _humidity = 0;
  bool _loadingWeather = true;
  bool _loadingRecs = true;

  bool _isCelsius = true;
  final _mlService = MLPredictionService();
  List<SmartRecommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _fetchWeatherData();
    _loadRecommendations();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = prefs.getBool('isCelsius') ?? true;
    });
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherService = WeatherService();
      final data = await weatherService.fetchWeather();
      if (data.isNotEmpty && data['current'] != null) {
        setState(() {
          _temp = data['current']['temperature_2m'];
          _humidity =
              (data['current']['relative_humidity_2m'] as num).toDouble();
          _loadingWeather = false;
        });
      }
    } catch (e) {
      print("Error fetching weather for homepage: $e");
      setState(() {
        _loadingWeather = false;
      });
    }
  }

  Future<void> _loadRecommendations() async {
    try {
      print('🔍 DEBUG: Loading recommendations...');
      // Simulate sensor data - in real app, fetch from API
      final recs = _mlService.generateRecommendations(
        sensorData: {
          'moisture': 28.0,
          'temperature': _temp > 0 ? _temp : 25.0,
          'nitrogen': 45.0,
        },
        todayWeather: null, // Can integrate with weather forecast
      );

      print('✅ DEBUG: Got ${recs.length} recommendations');
      setState(() {
        _recommendations = recs;
        _loadingRecs = false;
      });
    } catch (e) {
      print("❌ ERROR loading recommendations: $e");
      setState(() {
        _loadingRecs = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back,",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Alex",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: AssetImage('assets/profileimg.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // System Summary
                SystemSummaryCard(
                  activeSensors: 4,
                  avgTemp: _loadingWeather
                      ? 0
                      : (_isCelsius ? _temp : (_temp * 9 / 5) + 32),
                  avgHumidity: _loadingWeather ? 0 : _humidity,
                  alerts: 1,
                  isCelsius: _isCelsius,
                ),
                SizedBox(height: 30),

                // Smart Recommendations
                if (_loadingRecs)
                  SkeletonRecommendation()
                else if (_recommendations.isNotEmpty)
                  SmartRecommendationsCarousel(
                    recommendations: _recommendations,
                  ),
                if (_recommendations.isNotEmpty) SizedBox(height: 30),

                // Critical Insights Section
                _buildCriticalInsights(context),
                SizedBox(height: 30),

                // Quick Actions Label
                Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                SizedBox(height: 15),

                // Action Buttons Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                  children: [
                    _buildActionCard(
                      context,
                      "Add Sensor",
                      Icons.add_circle_outline,
                      Color(0xFF8EAC50),
                      () => widget.onNavigate(2), // Switch to Add Sensor tab
                    ),
                    _buildActionCard(
                      context,
                      "Watering",
                      Icons.water_drop_outlined,
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: WateringPage(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      "Analysis",
                      Icons.analytics_outlined,
                      Color(0xFFF0AD4E),
                      () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: AnalysisPage(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      context,
                      "Settings",
                      Icons.settings_outlined,
                      Colors.grey,
                      () => widget.onNavigate(3), // Switch to Profile tab
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalInsights(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Color(0xFF8EAC50).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Color(0xFF8EAC50), size: 24),
              SizedBox(width: 10),
              Text(
                "Action Required",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          _buildInsightItem(
            context,
            Icons.water_drop,
            "Watering Needed",
            "Tomato Plant 1 is below 30% moisture.",
            Colors.blue,
          ),
          SizedBox(height: 10),
          _buildInsightItem(
            context,
            Icons.science,
            "Nutrient Deficit",
            "Nitrogen levels low in Garden Bed A.",
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(BuildContext context, IconData icon, String title,
      String description, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

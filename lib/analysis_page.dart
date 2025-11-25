import 'package:flutter/material.dart';
import 'package:gwfront/widgets/sensor_history_chart.dart';
import 'package:gwfront/services/weather_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  bool _isCelsius = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCelsius = prefs.getBool('isCelsius') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final WeatherService _weatherService = WeatherService();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.tertiary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Smart Analysis",
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Insight Card
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8EAC50), Color(0xFF6B8E23)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF8EAC50).withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text(
                        "AI Insights",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Your plants are growing well! The nitrogen levels in Sensorino 1 have stabilized. Consider increasing watering frequency for the Tomato plants due to the upcoming heatwave.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Weather Forecast Card
            FutureBuilder<Map<String, dynamic>>(
              future: _weatherService.fetchWeather(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text("Error loading weather");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No weather data available");
                }

                final current = snapshot.data!['current'];
                final daily = snapshot.data!['daily'];
                final temp = current['temperature_2m'];
                final humidity = current['relative_humidity_2m'];
                final weatherCode = current['weather_code'];
                final description =
                    _weatherService.getWeatherDescription(weatherCode);

                // Prepare data for graph
                List<double> maxTemps =
                    List<double>.from(daily['temperature_2m_max']);
                List<double> minTemps =
                    List<double>.from(daily['temperature_2m_min']);
                List<int> rainChances = List<int>.from(
                    daily['precipitation_probability_max'] ?? []);

                List<String> days = [];
                DateTime now = DateTime.now();
                for (int i = 0; i < 7; i++) {
                  days.add(DateFormat('E').format(now.add(Duration(days: i))));
                }

                // Get today's rain chance (index 0)
                int todayRainChance =
                    rainChances.isNotEmpty ? rainChances[0] : 0;

                return Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_isCelsius ? temp : (temp * 9 / 5 + 32).toStringAsFixed(1)}°${_isCelsius ? 'C' : 'F'}",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Icon(Icons.water_drop,
                                      size: 16, color: Colors.blue),
                                  SizedBox(width: 5),
                                  Text(
                                    "$humidity%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Icon(Icons.cloudy_snowing, // Rain icon
                                      size: 16,
                                      color: Colors.blueGrey),
                                  SizedBox(width: 5),
                                  Text(
                                    "$todayRainChance%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Icon(
                            weatherCode == 0 ? Icons.wb_sunny : Icons.cloud,
                            size: 50,
                            color:
                                weatherCode == 0 ? Colors.orange : Colors.grey,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        "7-Day Forecast",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 150,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    int index = value.toInt();
                                    if (index >= 0 && index < days.length) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          days[index],
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                                .withOpacity(0.5),
                                            fontSize: 10,
                                          ),
                                        ),
                                      );
                                    }
                                    return Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: maxTemps.asMap().entries.map((e) {
                                  return FlSpot(e.key.toDouble(), e.value);
                                }).toList(),
                                isCurved: true,
                                color: Colors.orange,
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.orange.withOpacity(0.1),
                                ),
                              ),
                              LineChartBarData(
                                spots: minTemps.asMap().entries.map((e) {
                                  return FlSpot(e.key.toDouble(), e.value);
                                }).toList(),
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // Charts Section
            Text(
              "Growth Trends",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 300,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SensorHistoryChart(isShowingMainData: true),
            ),
            SizedBox(height: 30),

            // Detailed Stats
            Text(
              "System Health",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 15),
            _buildHealthItem(
                context, "Overall System Status", "Excellent", Colors.green),
            _buildHealthItem(
                context, "Sensor Connectivity", "100%", Colors.blue),
            _buildHealthItem(context, "Battery Levels", "Good", Colors.orange),

            SizedBox(height: 30),
            Text(
              "Nutrient Levels",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildNutrientBar(
                      context, "Nitrogen (N)", 0.7, Color(0xFF8EAC50)),
                  SizedBox(height: 15),
                  _buildNutrientBar(
                      context, "Phosphorus (P)", 0.4, Colors.orange),
                  SizedBox(height: 15),
                  _buildNutrientBar(
                      context, "Potassium (K)", 0.8, Colors.purple),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientBar(
      BuildContext context, String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthItem(
      BuildContext context, String label, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

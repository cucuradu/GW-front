import 'package:flutter/material.dart';
import 'package:gwfront/recomendationspage.dart';
import 'package:gwfront/widgets/sensor_history_chart.dart';
import 'package:gwfront/config.dart';

class SensorDetails extends StatefulWidget {
  final String sensorName;

  SensorDetails({required this.sensorName});

  @override
  _SensorDetailsState createState() => _SensorDetailsState();
}

class _SensorDetailsState extends State<SensorDetails> {
  Map<String, dynamic> sensorData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  Future<void> fetchSensorData() async {
    // In a real app, you would fetch data based on widget.sensorName
    // For now, we'll simulate a delay and use dummy data or the existing API structure
    // final url = Uri.parse('${Config.baseUrl}/apiRest/recommendations/');

    // Simulating network delay
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Dummy data for visualization
        sensorData = {
          "temperature": 24.5,
          "humidity": 60,
          "soil_moisture": 45,
          "nitrogen": 120,
          "phosphorus": 40,
          "potassium": 150,
        };
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/backbutton.png', height: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.sensorName,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF8EAC50)))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // History Chart
                    Container(
                      height: 300,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SensorHistoryChart(isShowingMainData: true),
                    ),
                    SizedBox(height: 25),

                    // Current Readings Label
                    Text(
                      "Current Readings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 15),

                    // Stats Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.5,
                      children: [
                        _buildStatCard(
                            "Temperature",
                            "${sensorData['temperature']}°C",
                            Icons.thermostat,
                            Colors.orange),
                        _buildStatCard("Humidity", "${sensorData['humidity']}%",
                            Icons.water_drop, Colors.blue),
                        _buildStatCard(
                            "Soil Moisture",
                            "${sensorData['soil_moisture']}%",
                            Icons.grass,
                            Colors.green),
                        _buildStatCard(
                            "Nitrogen",
                            "${sensorData['nitrogen']} mg/kg",
                            Icons.science,
                            Colors.purple),
                      ],
                    ),
                    SizedBox(height: 25),

                    // Recommendations Section
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFF8EAC50),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF8EAC50).withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI Analysis",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "3 New Recommendations",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Recomandations(Name: widget.sensorName),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF8EAC50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text("View All"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

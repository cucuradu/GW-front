import 'package:flutter/material.dart';

class SystemSummaryCard extends StatelessWidget {
  final int activeSensors;
  final double avgTemp;
  final double avgHumidity;
  final int alerts;
  final bool isCelsius;

  const SystemSummaryCard({
    Key? key,
    required this.activeSensors,
    required this.avgTemp,
    required this.avgHumidity,
    required this.alerts,
    this.isCelsius = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "System Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                "Sensors",
                "$activeSensors",
                Icons.sensors,
                Colors.blue,
              ),
              _buildStatItem(
                context,
                "Avg Temp",
                "${avgTemp.toStringAsFixed(1)}${isCelsius ? '°C' : '°F'}",
                Icons.thermostat,
                Colors.orange,
              ),
              _buildStatItem(
                context,
                "Avg Hum",
                "${avgHumidity.toStringAsFixed(0)}%",
                Icons.water_drop,
                Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

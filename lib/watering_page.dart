import 'package:flutter/material.dart';

class WateringPage extends StatelessWidget {
  const WateringPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          "Watering Schedule",
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
            // Next Watering Card
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.water_drop, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Next Watering",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Today, 6:00 PM",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Tomatoes & Basil",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Text(
              "My Plants",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            SizedBox(height: 15),

            _buildPlantItem(
              context,
              "Tomatoes",
              "Every 2 days",
              "Today",
              0.8,
              Colors.red,
            ),
            _buildPlantItem(
              context,
              "Basil",
              "Every 3 days",
              "Today",
              0.4,
              Colors.green,
            ),
            _buildPlantItem(
              context,
              "Cucumbers",
              "Every 2 days",
              "Tomorrow",
              0.2,
              Colors.lightGreen,
            ),
            _buildPlantItem(
              context,
              "Peppers",
              "Every 4 days",
              "In 2 days",
              0.6,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantItem(BuildContext context, String name, String frequency,
      String nextWater, double moisture, Color color) {
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.local_florist, color: color, size: 24),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      Text(
                        frequency,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Next: $nextWater",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                          nextWater == "Today" ? Colors.blue : Colors.grey[600],
                    ),
                  ),
                  if (nextWater == "Today")
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Watered $name!")),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("Water Now"),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.water_drop, size: 16, color: Colors.grey[400]),
              SizedBox(width: 5),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: moisture,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 6,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "${(moisture * 100).toInt()}% Moisture",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

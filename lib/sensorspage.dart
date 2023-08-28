import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gwfront/sensorlist.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'login.dart';
import 'dart:convert';

class SensorObject {
  int? id;
  String? name;
  bool? humidity;
  double? temperature;
  double? nitrogen;
  double? phosphorous;
  double? potassium;

  SensorObject({
    required this.id,
    required this.name,
    required this.humidity,
    required this.temperature,
    required this.nitrogen,
    required this.phosphorous,
    required this.potassium,
  });

  factory SensorObject.fromJson(Map<String, dynamic> json) {
    return SensorObject(
      id: json['id'],
      name: json['name'],
      humidity: json['humidity'],
      temperature: json['temperature'],
      nitrogen: json["nitrogen"],
      phosphorous: json["phosphorus"],
      potassium: json["potassium"],
    );
  }
}

Future<List<SensorObject>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://192.168.0.125:8000/sensors/'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    List<SensorObject> mySensors =
        jsonData.map((data) => SensorObject.fromJson(data)).toList();
    return mySensors;
  } else {
    // Error fetching data
    print('Request failed with status: ${response.statusCode}');
    return [];
  }
}

class Sensors extends StatefulWidget {

  String? userName;
  List<SensorObject>? mySensors;
  Sensors({this.userName, this.mySensors});
  @override
  _Sensors createState() => _Sensors(userName: userName);
}

class _Sensors extends State<Sensors> {
  String? userName;
  List<SensorObject>? mySensorsList;
  List sensor_data = [];
  _Sensors({this.userName});

  void getData() async {
    final url = Uri.parse('http://192.168.100.29:8000/sensors/'); // Replace with your Django server URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      sensor_data = jsonDecode(response.body);
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');

    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    mySensorsList = widget.mySensors;
    if (mySensorsList == null) {
      fetchData().then((sensors) {
        setState(() {
          mySensorsList = sensors;
        });
      });
    }
  }


  void addSensor(SensorObject newSensor) {
    setState(() {
      mySensorsList!.add(newSensor);
    });
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Sensor"),
          content: TextField(
            onChanged: (value) {
              // String? sensorName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Here, you can create a new SensorObject instance with the entered data
                SensorObject newSensor = SensorObject(
                  id: 1, // Provide the ID here as per your requirement
                  name:
                      "New Sensor", // Example name, you can replace it with the actual input from the TextField
                  humidity: true,
                  temperature: 25.0,
                  nitrogen: 10.0,
                  phosphorous: 5.0,
                  potassium: 3.0,
                );

                addSensor(
                    newSensor); // Call the addSensor function to add the new sensor to the list
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF8EAC50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              text: "Hi, ",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: userName ?? "Name",
                  style: const TextStyle(
                    color: Colors.black,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: Image.asset(
                'assets/minilogo.png',
                height: AppBar().preferredSize.height - 16,
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.white, // Background color
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.035),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/map.png',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height *
                            0.25, // Adjust the height here
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    Row(
                      // Use a Row to align the text to the left
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0,
                          ),
                          child: Text(
                            "Sensor list",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    Column(
                      children: [
                        Text(sensor_data.isNotEmpty ? sensor_data[0]['name'] : 'Nothing at the moment:(')
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Row(
                      // Use a Row to align the text to the left
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.0,
                          ),
                          child: Text(
                            'Alerts',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(color: Color(0xFFFAE392)),
                        height: MediaQuery.of(context).size.height *
                            0.25, // Adjust the height here
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height *
              0.097, // Adjust the height here
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Colors.white, // Set the button color here
                  elevation: 0,
                  child: Image.asset(
                    'assets/flower.png',
                    height: 77,
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                height: 75,
                child: FloatingActionButton(
                  onPressed:
                    () {

                    },// Call the _showAddDialog function when the button is pressed
                  backgroundColor:
                      const Color(0xFF8EAC50), // Set the button color here
                  child: const Icon(Icons.add),
                ),
              ),
              SizedBox(
                width: 72,
                height: 72,
                child: FloatingActionButton(
                  onPressed: () {
                    // Your right button action goes here
                  },
                  backgroundColor: Colors.white, // Set the button color here
                  elevation: 0,
                  child: Image.asset(
                    'assets/profile.png',
                    height: 77,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

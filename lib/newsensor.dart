import 'package:flutter/material.dart';
import 'package:gwfront/sensorspage.dart';

class NewSensor extends StatefulWidget {
  @override
  _NewSensorState createState() => _NewSensorState();
}

class _NewSensorState extends State<NewSensor> {
  String selectedItem = 'Tomato'; // Default selected item
  TextEditingController IDcontroller = TextEditingController();
  TextEditingController NameController = TextEditingController();
  String? SensorID;
  String? SensorName;
  String? SensorPlant;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
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
                    text: "Name",
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
                    MaterialPageRoute(
                      builder: (context) => Sensors(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/minilogo.png',
                  height: AppBar().preferredSize.height - 16,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent, // Set background to transparent
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/image2.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Image.asset(
                  'assets/Rectangle1.png',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.topCenter, // Center align the content
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.02),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.13),
                      Center(
                        child: Text(
                          'Add new sensor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width *
                                0.09, // Increase font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.084),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: IDcontroller,
                          decoration: InputDecoration(
                            hintText: 'Sensor ID',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: NameController,
                          decoration: InputDecoration(
                            hintText: 'Sensor name',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.08,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF8EAC50),
                          value: selectedItem,
                          onChanged: (newValue) {
                            setState(() {
                              selectedItem = newValue!;
                            });
                          },
                          icon: Icon(
                            Icons
                                .arrow_drop_down, // Set the dropdown arrow to white
                            color: Colors.white,
                          ),
                          underline: Container(
                            // Remove the underline by providing an empty container
                            height: 0,
                            color: Colors.transparent,
                          ),
                          items: <String>[
                            'Tomato',
                            'Cucumber',
                            'Carrot', // Change 'Carrots' to 'Carrot'
                            'Potato', // Change 'Potatoes' to 'Potato'
                            'Another',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 75,
              height: 75,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    SensorID = IDcontroller.text;
                    SensorName = NameController.text;
                    SensorPlant = selectedItem;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Sensors(),
                    ),
                  );
                },
                backgroundColor: const Color(0xFF8EAC50),
                child: Image.asset(
                  'assets/whiteplus.png',
                  height: 30,
                ),
              ),
            ),
          ),
        ));
  }
}

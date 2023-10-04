import 'package:flutter/material.dart';
import 'sensordetails.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Recomandationss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Recomandations(Name: "www"),
    );
  }
}

class Recomandations extends StatefulWidget {
  String? Name;
  Recomandations({required this.Name});
  State<Recomandations> createState() => _RecommendationsPageState(sensorName: '');
}

class _RecommendationsPageState extends State<Recomandations> {

  List sensor_data = [];
      String? sensorName;
      String plant = "";
      List<String> text = [];
      _RecommendationsPageState(
         {required this.sensorName}
      );

      @override
    void initState() {
      super.initState();
      plant = findID(sensorName ?? "");
      print(plant+"ddddddddddddddddddd");
      //text = recomandationFun(plant);
      //plantRecomandationText = text[0];
      //funFactText = text[1];
      plant = "Potatoes";
      Random random = new Random();
      if(plant == "Tomato"){
        plantRecomandationText = plantRecomandation[0];
        int i = random.nextInt(6);
        funFactText = tomatoFunFact[i];
      }else if(plant == "Cucumber"){
        plantRecomandationText = plantRecomandation[1];
        int i = random.nextInt(5);
        funFactText = cucumberFunFact[i];
      }else if(plant == "Carrots"){
        plantRecomandationText = plantRecomandation[2];
        int i = random.nextInt(6);
        funFactText = carrotFunFact[i];
      }else if(plant == "Potatoes"){
        plantRecomandationText = plantRecomandation[3];
        int i = random.nextInt(4);
        funFactText = potatoFunFact[i];
      }else if(plant == "Apple"){
        plantRecomandationText = plantRecomandation[4];
        int i = random.nextInt(4);
        funFactText = appleFunFact[i];
      }
    }

      void getData() async {
    final url = Uri.parse(
        'http://192.168.68.102:8000/apiRest/recommendations/'); // Replace with your Django server URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response, handle the data
      print('Response body: ${response.body}');
      final newData = jsonDecode(response.body);

      setState(() {
        for(final newSensor in newData){
          final newSensorId = newSensor['sensor_data']['id'];
          final index = sensor_data.indexWhere((sensor) => sensor['sensor_data']['id'] == newSensorId);

          if (index != -1) {
            // If the sensor already exists in the list, update its measurements and recommendations.
            sensor_data[index] = newSensor;
          } else {
            // If the sensor doesn't exist in the list (shouldn't happen as per your clarification), you can decide whether to add it or handle as an anomaly.
            print('Unexpected sensor found with id: $newSensorId');
            sensor_data.add(newSensor);
          }
        }
      });


      // for (var newItem in newData) {
      //   if (!sensor_data.contains(newItem)) {
      //     updatedData.add(newItem);
      //   }
      // }
      //
      // if (updatedData.isNotEmpty) {
      //   setState(() {
      //     sensor_data.addAll(updatedData);
      //   });
      // }
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
    }

  }

  String funFactText = "";
  String plantRecomandationText = "";
    List <String> plantRecomandation = ["Tomatoes love the sun, so make sure to plant them in a location with good sun exposure (at least 6-8 hours per day). Tomatoes need regular watering, but avoid excessive watering as it can lead to the development of fungal diseases. Water the tomatoes directly at the base of the plant to prevent leaf wetting. If you have indeterminate tomatoes, provide sturdy supports to help them grow vertically. This helps avoid leaf contact with the soil and prevents diseases.",
    "Plant cucumbers in a location with direct sunlight, as they require at least 6-8 hours of sunlight per day. Feed cucumbers with balanced fertilizers containing nitrogen, phosphorus, and potassium. Follow the instructions on the package for the correct dosage. Water the plant regularly, ensuring that water reaches the roots, not the leaves. Cucumbers are climbing plants, so provide them with vertical support such as a fence or trellis to allow the plant to grow upwards. Harvest cucumbers when they reach the appropriate size and have a uniform color.",
    "Carrots prefer sandy or sandy-loam soils rich in organic matter. The soil should be deeply tilled to allow the roots to grow freely. Plant carrot seeds in spring, usually after the danger of frost has passed. Maintain distance between plants to provide adequate space for growth. Carrots can break if left to dry or subjected to large fluctuations in humidity. Carrots need space to develop, so protect your carrot crops against pests such as carrot rust fly and aphids to avoid damage. Carrots are sweeter if left to mature in the soil for a longer period.",
    "Potatoes prefer soils rich in organic matter and well-drained. Enrich the soil with compost before planting to improve fertility. Choose to plant potato pieces (tubers) with eyes to allow the roots to develop. Plant potatoes in a part of the garden that receives direct sunlight and provides enough space for the plants to grow. Potatoes need fertilizers rich in potassium. You can use specific fertilizers for root vegetables or add wood ash to the soil to ensure sufficient potassium. Keep the soil consistently moist but not too wet.",
    "Regular watering is essential, especially during drought periods. Prune annually to remove dead or diseased branches and promote ventilation. In areas with cold winters, protect trees from severe frost with roofs or protective material. Apples can be stored for a longer time in a cool and humid environment. Regularly check them to remove any fruits that may deteriorate and affect others."];
    List <String> tomatoFunFact = ["There are two main types of tomatoes: determinate and indeterminate. Determinate tomatoes are smaller and grow as a bush, while indeterminate tomatoes are larger and grow like vines.",
    "Tomatoes are rich in vitamin C, potassium and lycopene, an antioxidant that has numerous health benefits.",
    "There are tomatoes of many colors, not just red. You can find yellow, orange, green, black and even blue tomatoes.",
    "Tomatoes come from South America and were brought to Europe in the 16th century.",
    "There are more than 10,000 varieties and varieties of tomatoes cultivated all over the world, and their number is constantly increasing, due to continuous selection and hybridization.",
    "Two of the most widespread and appreciated varieties of tomatoes worldwide are the Beefsteak Tomato and the Cherry Tomato."],
    cucumberFunFact = ["Cucumbers are native to India and have been cultivated for thousands of years in regions such as South Asia and Europe.",
    "Cucumbers have a high water content (almost 95%), which makes them an excellent hydrating snack on hot summer days.",
    "Cucumbers are used in a variety of dishes, from salads to pickles and sandwiches.",
    "Choose the right cucumber varieties for your garden. There are varieties for pickling and varieties for fresh consumption.",
    "In Romania and in the world, two of the most widespread and appreciated varieties of cucumbers are the cornichon cucumber and the English cucumber."],
    carrotFunFact = ["Carrots were first cultivated in Afghanistan and Iran more than 1,000 years ago and were known as white or purple roots, not orange.",
    "The orange carrots we eat today were created through selection and hybridization in Europe in the 17th century.",
    "Carrots are known for their high content of vitamin A, which is essential for eye health.",
    "The carrot root grows deep in the soil to protect the root from the sun and to maintain the flavor.",
    "In the world, two of the most famous and appreciated carrot varieties are the Nantes carrot and the Danvers carrot.",
    "It is estimated that there are more than 100 species and thousands of varieties of carrots cultivated throughout the world."],
    potatoFunFact = ["Potatoes were domesticated in South America thousands of years ago, and were one of the main food crops of pre-Columbian civilizations such as the Incas and Aztecs.",
    "Potatoes can be different colors, including white, red, purple and even blue.",
    "Potatoes are an excellent source of vitamin C, potassium and dietary fiber. (They are part of the staple diet of many people around the world.)",
    "The name potato comes from the Spanish word patata, which in turn comes from the Quechua word papa, used by the inhabitants of South America."],
    appleFunFact = ["Apples have a long history of cultivation, with a tradition of over 3,000 years. These fruits were an integral part of mythology, religion and history, and are associated with the story Adam and Eve's apple.",
    "There are over 7,500 apple varieties worldwide, each with different flavors and textures.",
    "Depending on the variety, apples can be harvested at different times of the year, so you can have fresh apples almost all the time.",
    "Most apple trees require another variety to ensure pollination and fruit production. Therefore, it is important to plant at least two compatible varieties to have a rich harvest."];
    //funFactText = tomatoFunFact[0];
    String findID(String sensorName){
      String plantType = "";
      for (final sensor in sensor_data)
          if (sensorName == sensor['sensor_data']['name']){
              plantType = sensor['sensor_data']['plant'];
              print("yes");
          }
      return plantType;
    }
    List<String> recomandationFun(String plant){
      Random random = new Random();
      if(plant == "Tomato"){
        plantRecomandationText = plantRecomandation[0];
        int i = random.nextInt(6);
        funFactText = tomatoFunFact[i];
      }else if(plant == "Cucumber"){
        plantRecomandationText = plantRecomandation[1];
        int i = random.nextInt(5);
        funFactText = cucumberFunFact[i];
      }else if(plant == "Carrots"){
        plantRecomandationText = plantRecomandation[2];
        int i = random.nextInt(6);
        funFactText = carrotFunFact[i];
      }else if(plant == "Potatoes"){
        plantRecomandationText = plantRecomandation[3];
        int i = random.nextInt(4);
        funFactText = potatoFunFact[i];
      }else if(plant == "Apple"){
        plantRecomandationText = plantRecomandation[4];
        int i = random.nextInt(4);
        funFactText = appleFunFact[i];
      }
      print(funFactText+" afawwwwwwwwwwwwwwwwwwwwwwwwwww"+ plantRecomandationText+plant);
      return [plantRecomandationText, funFactText];
    }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        
      ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Color(0xFFFAE392),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Align children at the start (left) horizontally
            children: [
              SizedBox(height: 15), // Empty space to position the image lower
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/image6.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height *
                        0.25, // Adjust the height here to make it larger
                    width: MediaQuery.of(context).size.width *
                        0.93, // Adjust the width here to make it larger
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Align children at the start (top) vertically
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15), // Add space to the left of the small image
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SensorDetails()),
                        );
                      },
                      child: Image.asset(
                        'assets/backbutton.png', // Small image on the left
                        height: 50, // Adjust the height of the small image
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ), // Space between the small image and the text
                  Expanded(
                    child: Text(
                      "Nutrients recommendations",
                      style: const TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff000000),
                        height: 32 / 24,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.transparent, // Set the color to transparent
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0), // Equal vertical spacing
                        child:
    
                        Text(
                          "Recommendations:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8), // Equal vertical spacing
                          child: Text(
                            plantRecomandationText,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              8), // Add space between the title and the next text
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0), // Equal vertical spacing
                        child: Text(
                          "Fun fact:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8), // Equal vertical spacing
                          child: Text(
                            funFactText,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
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

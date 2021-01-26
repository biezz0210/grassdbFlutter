import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Grass {
  final String commonName;
  final String cultivar;
  final String scientificName;
  final String growthType;

  Grass({this.commonName, this.cultivar, this.scientificName, this.growthType});

  factory Grass.fromJson(Map<String, dynamic> json) {
    return Grass(
      commonName: json['commonName'],
      cultivar: json['cultivar'],
      scientificName: json['scientificName'],
      growthType: json['growthType'],
    );
  }
}

Future<Grass> fetchGrass() async {
  final response = await http.get('http://192.168.1.132:8000/');

  if (response.statusCode == 200) {
    return Grass.fromJson(jsonDecode(response.body)[0]);
  } else {
    throw Exception('Failed to load Data');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Grass> futureGrass;

  @override
  void initState() {
    super.initState();
    futureGrass = fetchGrass();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GrassDB layout Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Grass Database Demo'),
            backgroundColor: Colors.green[200],
          ),
          body: ListView(
            children: [
              Image.asset(
                'images/grass.jpg',
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
              titleSection,
              textSection,
            ],
          ),
        ));
  }
}

Widget titleSection = Container(
  padding: const EdgeInsets.all(32),
  child: Row(
    children: [
      Expanded(
        /*1*/
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*2*/
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Oeschinen Lake Campground',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Kandersteg, Switzerland',
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);

Widget textSection = Container(
  padding: const EdgeInsets.all(32),
  child: Text(
    'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
    'Alps. Situated 1,578 meters above sea level, it is one of the '
    'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
    'half-hour walk through pastures and pine forest, leads you to the '
    'lake, which warms to 20 degrees Celsius in the summer. Activities '
    'enjoyed here include rowing, and riding the summer toboggan run.',
    softWrap: true,
  ),
);

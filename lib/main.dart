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
              Container(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: FutureBuilder<Grass>(
                              future: futureGrass,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.commonName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: FutureBuilder<Grass>(
                              future: futureGrass,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.scientificName +
                                        ', ' +
                                        snapshot.data.cultivar,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(32),
                child: FutureBuilder<Grass>(
                  future: futureGrass,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'Growth Type : ' + snapshot.data.growthType,
                        softWrap: true,
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

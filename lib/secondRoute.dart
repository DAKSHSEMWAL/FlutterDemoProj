import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lear_intermed_flutter/fruitList.dart';
import 'package:lear_intermed_flutter/main.dart';

Future<List<Fruit>> fetchAlbum() async {
  final response =
      await http.get(Uri.https('my-json-server.typicode.com', '/DAKSHSEMWAL/FruitJsonRepository/fruits'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    return decodeFruit(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
List<Fruit> decodeFruit(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Fruit>((json) => Fruit.fromMap(json)).toList();
}
class Fruit {
  final int id;
  final String title;
  final String imgUrl;
  final int quantity;

  Fruit(
      this.id,
      this.title,
      this.imgUrl,
      this.quantity,
      );
  factory Fruit.fromMap(Map<String, dynamic> json) {
    return Fruit(json['id'], json['title'], json['imgUrl'], json['quantity']);
  }
  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(json['id'], json['title'], json['imgUrl'], json['quantity']);
  }
}

class SecondRoute extends StatefulWidget {
  SecondRoute({Key key}) : super(key: key);

  @override
  _SecondRoute createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  final Future<List<Fruit>> products = fetchAlbum();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: createMaterialColor(Color(0xFFFEDBD0)).shade100,
        ),
        body: Center(
          child: FutureBuilder<List<Fruit>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? FruitList(items: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
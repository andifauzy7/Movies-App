import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moviesapp/constant/constant.dart';
import 'package:toast/toast.dart';

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  List data;

  Future getData() async {
    var res = await http.get(Uri.encodeFull(constant.URL_API),
        headers: {'accept': 'application/json'});
    setState(() {
      var content = json.decode(res.body);
      data = content['results'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData().catchError((error)=> Toast.show("Pesan : $error", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  Widget build(context) {
    return MaterialApp(
      title: 'List Movie',
      home: Scaffold(
          appBar: AppBar(
            title: Text('List Movie'),
            leading: Icon(Icons.movie),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      constant.IMAGE_URL + data[index]['poster_path'],
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      data[index]['title'],
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Language : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data[index]['original_language'],
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15.0),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Vote : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(data[index]['vote_average'].toString()),
                            Icon(
                              Icons.star,
                              size: 20.0,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Popular : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data[index]['popularity'].toString(),
                              softWrap: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
    );
  }
}

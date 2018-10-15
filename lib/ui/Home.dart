import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo App"),
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
        future: _fetchPhotos(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showDialogOnTab(
                        context: context,
                        imageUrl: snapshot.data[index]["url"],
                        title: snapshot.data[index]["title"],
                      ),
                  child: Image.network(
                    snapshot.data[index]["thumbnailUrl"],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List> _fetchPhotos() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/photos");

    return json.decode(data.body);
  }

  void _showDialogOnTab({BuildContext context, String imageUrl, String title}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Image.network(imageUrl),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Ok")),
          ],
        );
      },
    );
  }
}

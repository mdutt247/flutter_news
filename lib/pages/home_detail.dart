import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/HomeDetailModel.dart';


class HomeDetail extends StatefulWidget {
  final String categoryID;

  HomeDetail(this.categoryID);

  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  Future<List<HomeDetailModel>> _getHomeDetailData() async {
    var response = await http.get(
        "http://10.0.2.2:8000/api/categories/" + widget.categoryID + "/posts");
    List<HomeDetailModel> hdlist = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      for (var item in body['data']) {
        HomeDetailModel post = HomeDetailModel.fromJson(item);
        hdlist.add(post);
      }
    }
    return hdlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Detail"),
        ),
        body: FutureBuilder(
          future: _getHomeDetailData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Container(
                child: Text(snapshot.error),
              );
            } else if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          // onTap: () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               (snapshot.data[index].id))); // To do: next page
                          // },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              snapshot.data[index].title,
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}

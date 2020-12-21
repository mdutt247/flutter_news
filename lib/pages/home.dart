import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/util/shared_preference.dart';
import '../models/HomeModel.dart';
import 'home_detail.dart';

class HomeList extends StatefulWidget {
  @override
  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {

  Future<List<HomeModel>> _getHomeData() async {
    var response = await http.get("http://10.0.2.2:8000/api/categories");
    List<HomeModel> hlist = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      for (var item in body['data']) {
        HomeModel home = HomeModel.fromJson(item);
        hlist.add(home);
      }
    }
    return hlist;
  }

  String token;
  getToken() async{
    token = await UserPreferences().getToken(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              onPressed: ()  {

                if (token != null) {
                  Navigator.pushReplacementNamed(context, '/profile');
                }
                else{
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            )
          ],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),

        body: FutureBuilder(
          future: _getHomeData(),
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 6,
                            child: Container(
                              color: Color(int.parse(snapshot.data[index].color
                                  .replaceAll('#', '0xFF'))),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeDetail(snapshot.data[index].id)));
                          },
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

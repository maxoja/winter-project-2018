import 'package:flutter/material.dart';

import 'pages/profile.dart';
import 'pages/feed.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking App',
      home: TabScaffold(),
    );
  }
}

class TabScaffold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabScaffoldState();
  }
}

class _TabScaffoldState extends State<TabScaffold> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text('App Title')),
        bottomNavigationBar: 
        Container(
          color: Theme.of(context).accentColor,
          child:TabBar(
            indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(icon: Icon(Icons.account_circle)),
            Tab(icon: Icon(Icons.receipt)),
          ],
        ),),
        body: TabBarView(
          children: <Widget>[
            ProfilePage(),
            FeedPage(),
          ],
        ),
      ),
    );
  }
}

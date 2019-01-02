import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './profile.dart';
import './feed.dart';

class TabsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabsPageState();
  }
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    ));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(title: Text('App Title')),
        bottomNavigationBar: Container(
          color: Theme.of(context).accentColor,
          child: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.account_circle)),
              Tab(icon: Icon(Icons.receipt)),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 25),
          child: TabBarView(
            children: <Widget>[
              ProfilePanel(),
              FeedPage(),
            ],
          ),
        ),
      ),
    );
  }
}

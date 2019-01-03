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
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.orange,
            tabs: <Widget>[
              // Tab(icon: Icon(Icons.account_circle),text: 'Your Book',),
              Tab(
                
                // text:'Cook Book',
                // child:Container(),
                  child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2,),
                    Icon(Icons.book),
                    SizedBox(height: 0,),
                    Text('Your Book'),
                    SizedBox(height: 2,),
                  ],
                ),
              ),Tab(
                // text: 'Explore',
                // child:Container(),
                  child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 2,),
                    Icon(Icons.find_in_page),
                    SizedBox(height: 0,),
                    Text('Explore'),
                    SizedBox(height: 2,),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 25),
          child: TabBarView(
            children: <Widget>[
              ProfilePanel(),
              FeedPanel(),
            ],
          ),
        ),
      ),
    );
  }
}

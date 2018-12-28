import 'package:flutter/material.dart';

import 'tabs.dart';

class LandingPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(color:Colors.red),
        floatingActionButton: FloatingActionButton(onPressed: (){
          //do http request here and navigate when recieved
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return TabsPage();
          }));
        },),
      );
    }
}
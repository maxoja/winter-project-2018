import 'package:flutter/material.dart';

class InitUserPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body:Container(color:Colors.teal),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            
            //do http request and navigate when success
          },
        ),
      );
    }
}
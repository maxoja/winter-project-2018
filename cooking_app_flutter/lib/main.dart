import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/landing.dart';
import 'scoped_models/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: AppModel(),
      child: MaterialApp(
        theme: ThemeData(
          // bottomAppBarColor: Color(0xffd24019),
          // accentColor: Color(0xffd24019),
          // accentColor: Color(0xffea7c46),
          accentColor: Color(0xffd24019),
          primaryColor: Color(0xffd24019),
          // backgroundColor: Color(0xffd24019),
          // scaffoldBackgroundColor: Color(0xffffdd9c),
          scaffoldBackgroundColor: Color(0xffffe6bc),
          buttonColor: Colors.white,
          ),
        title: 'Cooking App',
        home: LandingPage(),
      ),
    );
  }
}

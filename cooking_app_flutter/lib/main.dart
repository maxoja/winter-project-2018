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
        title: 'Cooking App',
        home: LandingPage(),
      ),
    );
  }
}

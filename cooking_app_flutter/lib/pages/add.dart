import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/app.dart';

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            iconTheme: IconThemeData.fallback(),
            title: Text(
              'Add Your Recipe',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: Column(),
        );
      },
    );
  }
}

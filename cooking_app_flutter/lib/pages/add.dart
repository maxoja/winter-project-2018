import 'package:flutter/material.dart';

import '../models/user.dart';

class AddPage extends StatelessWidget {
  final UserModel user;

  AddPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData.fallback(),
        title: Text('Add Your Recipe',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
      ),
      body: Column(),
    );
  }
}

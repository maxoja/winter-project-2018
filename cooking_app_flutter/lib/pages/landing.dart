import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'tabs.dart';
import '../api.dart' as api;

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.red),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          api.callRequestAccount(
            success: (Map responseMap) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TabsPage();
                  },
                ),
              );
            },
            failed: (String error) {
              showDialog(
                context: context,
                builder: (context) {
                  Text('error occurred : $error');
                },
              );
//stay this page and promp something
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/app.dart';
import 'tabs.dart';
import '../api.dart' as api;
import 'init_account.dart';
import '../models/user.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.red),
      floatingActionButton: ScopedModelDescendant<AppModel>(
        builder: (context, child, AppModel model) {
          return _buildFloatButton(context, model);
        },
      ),
    );
  }

  Widget _buildFloatButton(context, model) {
    return FloatingActionButton(
      onPressed: () {
        api.callRequestAccount(
          success: (Map responseMap) => _onSuccess(context, model, responseMap),
          failed: (String error) => _onFailed(context, model, error),
        );
      },
    );
  }

  void _onSuccess(context, AppModel model, Map responseMap) {
    Map newUserMap = responseMap['newUser'];
    User newUser = User.fromJson(newUserMap);
    model.setUser(newUser);
    model.setToken(newUserMap['token']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TabsPage();
        },
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return InitAccountDialog();
      },
    );
  }

  void _onFailed(context, AppModel model, String error) {
    showDialog(
      context: context,
      builder: (context) {
        Text('error occurred : $error');
      },
    );
  }
}

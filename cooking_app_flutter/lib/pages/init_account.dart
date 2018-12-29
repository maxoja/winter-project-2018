import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../api.dart' as api;
import '../scoped_models/app.dart';

class InitAccountDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InitAccountDialogState();
  }
}

class _InitAccountDialogState extends State<InitAccountDialog> {
  String _newUserName = '';

  String _validate(String input) {
    if (input.trim() == '') return 'name must not be empty';
    if (input.trim().length > 15) return 'name must not be larger than 15';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, AppModel model) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                //validation need textformfield
                decoration: InputDecoration(
                    labelText: 'Account Nickname', hintText: 'mock name'),
                onChanged: (String value) {
                  _newUserName = value.trim();
                  return _validate(_newUserName);
                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    child: Text('Skip'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_validate(_newUserName) != null) {
                        print('[ invalid name ]');
                        return;
                      }

                      api.callChangeName(
                        model.user.id,
                        model.token,
                        _newUserName,
                        success: (r) {},
                        failed: (r) {},
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

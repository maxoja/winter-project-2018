import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../api.dart' as api;
import '../models/user.dart';
import '../scoped_models/app.dart';
import '../widgets/two_options.dart';

class InitAccountDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InitAccountDialogState();
  }
}

class _InitAccountDialogState extends State<InitAccountDialog> {
  String _newUserName = '';
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, AppModel model) {
        return Dialog(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextInput(context, model),
                SizedBox(height: 30),
                _buildButtonBar(context, model),
              ],
            ),
          ),
        );
      },
    );
  }

  String _validate(String input) {
    if (input == '') return null;
    input = input.trim();
    if (input == '') return 'name must contain characters';
    if (input.length > 15) return 'name must not be larger than 15';
    return null;
  }

  void _onSubmit(AppModel model) {
    print('submit');
    if (!_formKey.currentState.validate()) {
      print('[ invalid name ]');
      return;
    }

    _formKey.currentState.save();

    //if user want to use default name
    if (_newUserName == '') {
      print('[ user default name ]');
      Navigator.pop(context);
      return;
    }

    api.callChangeName(
      model.user.id,
      model.token,
      _newUserName,
      success: (r) {
        User prevUser = model.user;
        model.setUser(User(prevUser.id, r['name']));
        Navigator.pop(context);
      },
      failed: (r) {},
    );
  }

  Widget _buildTextInput(BuildContext context, AppModel model) {
    var decoration = InputDecoration(
      labelText: 'Account Nickname',
      hintText: model.user.name,
    );

    return TextFormField(
      decoration: decoration,
      validator: _validate,
      onSaved: (String value) {
        _newUserName = value.trim();
      },
    );
  }

  Widget _buildButtonBar(BuildContext context, AppModel model) {
    return TwoOptionsButtonBar(
      leftText: 'Skip',
      rightText: 'Submit',
      onLeft: () => Navigator.pop(context),
      onRight: () => _onSubmit(model),
    );
  }
}

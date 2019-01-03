import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/app.dart';
import '../models/recipe.dart';
import '../api.dart' as api;

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String _title;
  List<String> _tags; //instruction and ingredient
  int _difficulty;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            iconTheme: IconThemeData.fallback(),
            title: Text(
              'Search Recipe',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
          body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                    onSaved: (String val) {
                      _title = val.trim();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tags (Separated by commas)',
                    ),
                    onSaved: (String val) {
                      if (val.trim() == '')
                        _tags = [];
                      else
                        _tags = val.trim().split(',');
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Skill Level',
                    ),
                    onSaved: (String val) {
                      if (val == '')
                        _difficulty = 10;
                      else
                        _difficulty = int.parse(val.trim());
                    },
                    validator: (String val) {
                      if (val == '') return null;
                      int n = int.tryParse(val);
                      if (n == null) return 'must be a number';
                      if (n == 10) return null;
                      if (n < 0 || n > 2) return 'number out of skill range';
                    },
                  ),
                  RaisedButton(
                    child: Text('Confirm'),
                    onPressed: () {
                      /*
          todo
          create a request to backend
          retrieve the data and set data to the page
          */
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        api.callSearch(_title, _tags, _difficulty,
                            success: (response) {
                          List<Recipe> r = [];
                          response['recipes'].forEach((a) {
                            r.add(Recipe.fromJson(a));
                          });
                          model.setSearchedRecipes(r);
                          Navigator.pop(context);
                        }, failed: (error) {});
                      }
                    },
                  ),
                ],
              )),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/app.dart';
import '../models/recipe.dart';
import '../api.dart' as api;
import 'recipe.dart';

class AddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPageState();
  }
}

class _AddPageState extends State<AddPage> {
  String _title;
  String _description; //instruction and ingredient
  int _difficulty;
  List<String> _tags = [];
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            // brightness: Brightness.light,
            // iconTheme: IconThemeData(color:Colors.brown),
            // iconTheme: IconThemeData.fallback(),
            title: Text(
              'Add Your Recipe',
              // style: TextStyle(color: Colors.brown),
            ),
            // backgroundColor: Color(0xffffe6bc),
          ),
          // backgroundColor: Color(0xfffff6e7),
          body: ListView(
            children: [
              Form(
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
                      validator: (String val) {
                        if (val.trim().length < 3)
                          return 'title must long enough';
                        if (val.trim().length > 30) return 'title too long';
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      onSaved: (String val) {
                        _description = val.trim();
                      },
                      validator: (String val) {
                        if (val.trim().length < 10)
                          return 'title must long enough';
                        if (val.trim().length > 500) return 'title too long';
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
                        _difficulty = int.parse(val.trim());
                      },
                      validator: (String val) {
                        int n = int.tryParse(val);
                        if (n == null) return 'must be a number';
                        if (n == 10) return null;
                        if (n < 0 || n > 2) return 'number out of skill range';
                      },
                    ),
                    RaisedButton(
                      child: Text('Confirm'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          api.callPostRecipe(
                            model.user.id,
                            model.token,
                            _title,
                            'assets/temp_food.jpg',
                            _description,
                            _tags,
                            _difficulty,
                            success: (Map responseMap) {
                              Recipe newRecipe = Recipe(
                                model.user,
                                _title,
                                _description,
                                _difficulty,
                                0,
                                0,
                                responseMap['rid'].toString(),
                              );
                              model.addUserRecipe(newRecipe);
                              // Navigator.pop(context);
                              // Navigator.push(context, MaterialPageRoute(builder: (context){
                              //   return RecipePage(newRecipe);
                              // }));
                              int i = 0;
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return RecipePage(newRecipe, model);
                              }), (Route route) {
                                i += 1;
                                return i >= 2;
                              });
                            },
                            failed: (String error) {},
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

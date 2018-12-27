import 'package:flutter/material.dart';

import '../widgets/recipe_grid.dart';
import '../models/recipe.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String _userIdentity = null;
  String _userName = null;
  List<RecipeModel> _recipes = [];

  void _setUserIdentity(String value) {
    setState(() {
      _userIdentity = value;
    });
  }

  void _setUserName(String value) {
    setState(() {
      _userName = value;
    });
  }

  void _setRecipes(List newRecipes) {
    setState(() {
      this._recipes = newRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    _userIdentity = 'asdf';
    _userName = 'aasldkfj';
    _recipes = [
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
    ];

    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('assets/temp_profile.jpeg'),
        ),
        Text('user name : ' + _userName),
        Text('user id : ' + _userIdentity),
        Text('recipes : ' + _recipes.toString()),
        Divider(),
        Expanded(child: RecipeGrid(_recipes, 'No Recipe Recorded')),
      ],
    );
  }
}

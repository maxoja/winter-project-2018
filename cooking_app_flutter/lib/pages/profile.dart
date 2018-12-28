import 'package:flutter/material.dart';

import './add.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/user_band.dart';
import '../models/recipe.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel _user = UserModel.mock();
  List<RecipeModel> _recipes = [];

  void _setUser(UserModel value) {
    setState(() {
      _user = value;
    });
  }

  void _setRecipes(List<RecipeModel> newRecipes) {
    setState(() {
      this._recipes = newRecipes;
    });
  }

  void _onPressedAdd(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder:(context){
      return AddPage(_user);
    }));
  }

  @override
  Widget build(BuildContext context) {
    _recipes = [
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
      RecipeModel.mock(),
    ];

    return Scaffold(
      // appBar: AppBar(title:Text('Profile')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>_onPressedAdd(context),
      ),
      body: Column(
        children: <Widget>[
          EpicUserBand(_user),
          Divider(),
          Expanded(child: RecipeGrid(_recipes, 'No Recipe Recorded')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/recipe_grid.dart';
import '../widgets/search_button.dart';
import '../models/recipe.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  List<RecipeModel> _recipes = [];
  //filters information should be here
  //because it's supposed to be easy to manage
  //since this page would not be destroyed after a search is executed

  void _setRecipes(List newRecipes) {
    setState(() {
      this._recipes = newRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // SizedBox(height: 5,),
        SearchButton(this),
        SizedBox(height: 10,),
        Expanded(child:RecipeGrid(_recipes)),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/recipe_grid.dart';
import '../widgets/search_button.dart';
import '../models/recipe.dart';
import '../scoped_models/app.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, AppModel model) {
        return Column(
          children: <Widget>[
            // SizedBox(height: 5,),
            SearchButton(this),
            SizedBox(
              height: 10,
            ),
            Expanded(child: RecipeGrid(model.searchedRecipes)),
          ],
        );
      },
    );
  }
}

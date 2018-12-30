import 'package:flutter/material.dart';

import '../pages/recipe.dart';
import '../models/recipe.dart';
import 'user_band.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final String noRecipeText;

  RecipeGrid(this.recipes, [this.noRecipeText = 'Loading ...']);

  Widget _buildCookCard(BuildContext context, int index) {
    return _RecipeCard(recipes[index]);
  }

  @override
  Widget build(BuildContext context) {
    if (recipes.length == 0) return Center(child: Text('Loading ...'));

    return GridView.builder(
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: _buildCookCard,
      itemCount: recipes.length,
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;

  _RecipeCard(this.recipe);

  void _onPressedCard(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return RecipePage(recipe);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MaterialButton(
        child: Column(
          children: <Widget>[
            TinyUserBand(recipe.owner),
            Divider(),
            Text(recipe.description),
            Text(recipe.difficulty.toString()),
            Divider(),
            Text('${recipe.likes} - ${recipe.dislikes}'),
          ],
        ),
        onPressed: () => _onPressedCard(context),
      ),
    );
  }
}

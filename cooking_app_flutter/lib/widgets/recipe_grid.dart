import 'package:flutter/material.dart';

import '../models/recipe.dart';

class RecipeGrid extends StatelessWidget {
  final List<RecipeModel> recipes;
  final String noRecipeText;

  RecipeGrid(this.recipes, [this.noRecipeText='Loading ...']);

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
  final RecipeModel recipe;

  _RecipeCard(this.recipe);

  @override
    Widget build(BuildContext context) {
      return Card(
        child: Column(
          children: <Widget>[
            //owner/ing/instr/score
            CircleAvatar(backgroundImage: AssetImage(recipe.owner.imageUrl),),
            Text(recipe.owner.name),
            Divider(),
            Text(recipe.ingredients),
            Divider(),
            Text(recipe.instructions),
            Divider(),
            Text(recipe.score.toString()),
          ],
        ),
      );
    }
}

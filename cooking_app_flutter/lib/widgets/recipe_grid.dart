import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../pages/recipe.dart';
import '../models/recipe.dart';
import 'user_band.dart';
import '../scoped_models/app.dart';

class RecipeGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final String noRecipeText;
  final bool minimal;

  RecipeGrid(this.recipes,
      {this.noRecipeText = 'Loading ...', this.minimal = false});

  Widget _buildCookCard(BuildContext context, int index) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, AppModel model) {
    Recipe recipe = recipes[index];
        return minimal ? _MiniRecipeCard(recipe, model) : _FullRecipeCard(recipe, model);
      },
    );
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

class _FullRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final AppModel model;

  _FullRecipeCard(this.recipe, this.model);

  void _onPressedCard(BuildContext context) {
    model.setSelectedRecipe(recipe);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
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

class _MiniRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final AppModel model;

  _MiniRecipeCard(this.recipe, this.model);

  void _onPressedCard(BuildContext context) {
    model.setSelectedRecipe(recipe);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RecipePage(recipe);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: MaterialButton(
        child: Column(
          children: <Widget>[
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

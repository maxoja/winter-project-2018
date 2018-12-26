import 'package:flutter/material.dart';

class RecipeGrid extends StatelessWidget {
  final List recipes;
  final String noRecipeText;

  RecipeGrid(this.recipes, [this.noRecipeText='Loading ...']);

  Widget _buildCookCard(BuildContext context, int index) {
    return Card();
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

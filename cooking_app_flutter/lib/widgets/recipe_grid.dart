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
        return Padding(
            padding: EdgeInsets.only(bottom: 5, top: 0),
            child: _FullRecipeCard(recipe, model));
        // return minimal ? _MiniRecipeCard(recipe, model) : _FullRecipeCard(recipe, model);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (recipes.length == 0) return Center(child: Text('Loading ...'));

    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
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
      return RecipePage(recipe, model);
    }));
  }

  @override
  Widget build(BuildContext context) {
    String difficultyString;
    if (recipe.difficulty == 0)
      difficultyString = 'For Everyone';
    else if (recipe.difficulty == 1)
      difficultyString = 'Family Dad';
    else if (recipe.difficulty == 2)
      difficultyString = 'Gordon Ramsey';
    else if (recipe.difficulty == 10) difficultyString = 'Unspecified';

    double likeWidth = 10;
    List<Widget> diffBar = [];
    double size = 12;
    double space = 8;
    Widget yesBox = Container(
      
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(7),
      ),
        margin: EdgeInsets.only(left: space),
        width: size,
        height: size,
        );
    Widget noBox = Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
        margin: EdgeInsets.only(left: space),
        width: size,
        height: size,);
    int i = 0;
    for (i = 0; i < recipe.difficulty + 1; i++) {
      if (recipe.difficulty == 10) break;
      diffBar.add(yesBox);
    }
    while (i++ < 3) {
      diffBar.add(noBox);
    }
    diffBar.add(Text('Difficulty'));
    diffBar.add(Expanded(child: Container()));
    diffBar.add(Text('${recipe.likes + recipe.dislikes} Reactions'));
    diffBar = diffBar.reversed.toList();

    return Card(
      elevation: 6,
      // color: Colors.yellow[50],
      color: Color(0xfffff3e0),
      child: MaterialButton(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 6),

            // TinyUserBand(recipe.owner),

            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 6),
            //   child: Text(
            //     recipe.title,
            //     style: TextStyle(
            //       fontWeight: FontWeight.bold,
            //       fontSize: 17,
            //     ),
            //   ),
            // ),

            // recipe.imageUrl == null ? Divider() : Image.asset(recipe.imageUrl),
            // Text(recipe.description.length > 30 ? recipe.description.substring(30) : recipe.description),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      recipe.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Image.asset('assets/temp_food.jpg'),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: diffBar,
            ),
            SizedBox(
              height: 4,
            ),
             Row(
              children: <Widget>[
                Expanded(
                    flex: recipe.likes,
                    child: Container(
                      color: Colors.green,
                      height: likeWidth,
                    )),
                Expanded(
                    flex: recipe.dislikes,
                    child: Container(
                      color: Colors.red,
                      height: likeWidth,
                    )),
                Expanded(
                  flex: (recipe.likes + recipe.dislikes == 0) ? 1 : 0,
                  child: Container(
                    color: Colors.grey,
                    height: likeWidth,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            // SizedBox(
            //   height: 8,
            // ),
          ],
        ),
        onPressed: () => _onPressedCard(context),
      ),
    );
  }
}

// class _MiniRecipeCard extends StatelessWidget {
//   final Recipe recipe;
//   final AppModel model;

//   _MiniRecipeCard(this.recipe, this.model);

//   void _onPressedCard(BuildContext context) {
//     model.setSelectedRecipe(recipe);
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return RecipePage(recipe);
//     }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: MaterialButton(
//         child: Column(
//           children: <Widget>[
//             Text(recipe.title),
//             Text(recipe.description),
//             Text(recipe.difficulty.toString()),
//             // recipe.imageUrl == null ? Divider() : Image.asset(recipe.imageUrl),
//             Text('${recipe.likes} - ${recipe.dislikes}'),
//           ],
//         ),
//         onPressed: () => _onPressedCard(context),
//       ),
//     );
//   }
// }

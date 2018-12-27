import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../widgets/user_band.dart';
import '../widgets/reaction_bar.dart';


class RecipePage extends StatefulWidget {
  final RecipeModel recipe;

  RecipePage(this.recipe);

  @override
    State<StatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  RecipeModel _recipe;

  @override
    void initState() {
      super.initState();
      _recipe = widget.recipe;
    }

  void _onReactionChanged(Reaction newReaction){
    print('[ Reaction changed to $newReaction ]');
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title:Text(_recipe.title)),
        body: ListView(
          children: <Widget>[
            TinyUserBand(_recipe.owner),
            Divider(),
            Text(_recipe.ingredients),
            Divider(),
            Text(_recipe.instructions),
            Divider(),
            Text(_recipe.score.toString()),
            Divider(),
            ReactionBar(Reaction.None, _onReactionChanged),
          ],
        ),
      );
    }
}
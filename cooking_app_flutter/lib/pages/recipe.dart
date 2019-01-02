import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../widgets/user_band.dart';
import '../widgets/reaction_bar.dart';
import '../api.dart' as api;
import '../scoped_models/app.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  RecipePage(this.recipe);

  @override
  State<StatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Recipe _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  void _onReactionChanged(Reaction newReaction) {
    print('[ Reaction changed to $newReaction ]');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_recipe.title)),
      body: ListView(
        children: <Widget>[
          TinyUserBand(_recipe.owner),
          Divider(),
          Text(_recipe.description),
          Divider(),
          Text(_recipe.difficulty.toString()),
          Divider(),
          Text(_recipe.likes.toString()),
          Divider(),
          Text(_recipe.dislikes.toString()),
          Divider(),
          ReactionBar(Reaction.None, _onReactionChanged),
        ],
      ),
    );
  }
}

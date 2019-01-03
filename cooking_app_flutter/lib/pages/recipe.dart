import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/recipe.dart';
import '../widgets/user_band.dart';
import '../widgets/reaction_bar.dart';
import '../api.dart' as api;
import '../scoped_models/app.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  final AppModel model;

  RecipePage(this.recipe, this.model);

  @override
  State<StatefulWidget> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Recipe _recipe;

  Reaction _reactionFromString(String reaction){
      switch (reaction) {
        case 'LIKE':
        return Reaction.Like;
        case 'DISLIKE':
        return Reaction.Dislike;
        default:
        return Reaction.None;
      }
  }

  void _fetchReaction(){
    if(_recipe.rid != widget.model.selectedRecipe.rid)
      return;
    api.callCurrentReaction(
        widget.model.user.id, widget.model.token, _recipe.rid,
        success: (response) {
      Reaction currentReaction = Reaction.None;
      switch (response['reaction']) {
        case 'LIKE':
          currentReaction = Reaction.Like;
          break;
        case 'DISLIKE':
          currentReaction = Reaction.Dislike;
          break;
        case 'NONE':
          currentReaction = Reaction.None;
          break;
      }

      // sleep(const Duration(seconds: 2));
      widget.model.setCurrentReaction(currentReaction);
      setState(() {
              
            });

      // _fetchReaction();
    }, failed: (error) {
      //todo later
    });
  }

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    widget.model.setSelectedRecipe(_recipe);
    widget.model.setCurrentReaction(Reaction.None);
    _fetchReaction();
  }

  void _onReactionChanged(Reaction newReaction) {
    print('[ Reaction changed to $newReaction ]');

    widget.model.setCurrentReaction(newReaction);
    api.callSetReaction(widget.model.user.id, widget.model.token, newReaction, widget.model.selectedRecipe.rid,
    success: (response){
      // widget.model.setCurrentReaction(_reactionFromString(response['response']));
    },
    failed:(error){

    });
  }

  @override
  Widget build(BuildContext context) {
    print(' REBUILD LIKESSSS ');
    var result = Scaffold(
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
          ScopedModelDescendant(builder: (context, child, AppModel model){
            return ReactionBar(_onReactionChanged, widget.model);
          }),
        ],
      ),
    );

    return result;
  }
}

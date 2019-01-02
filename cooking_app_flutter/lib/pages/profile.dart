import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './add.dart';
import '../widgets/recipe_grid.dart';
import '../widgets/user_band.dart';
import '../scoped_models/app.dart';

class ProfilePanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePanelState();
  }
}

class _ProfilePanelState extends State<ProfilePanel> {
  void _onPressedAdd(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, AppModel model) {
        return Scaffold(
          // appBar: AppBar(title:Text('Profile')),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _onPressedAdd(context),
          ),
          body: Column(
            children: <Widget>[
              EpicUserBand(model.user),
              Divider(),
              Expanded(
                child: RecipeGrid(
                  model.userRecipes,
                  noRecipeText: 'No Recipe Recorded',
                  minimal: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

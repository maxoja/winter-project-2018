import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/recipe_grid.dart';
import '../widgets/search_button.dart';
import '../scoped_models/app.dart';
import '../api.dart' as api;

//todo random feed implementation
//call api at init state method

class FeedPanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPanelState();
  }
}

class _FeedPanelState extends State<FeedPanel> {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, AppModel model) {
        print('[ REBUILD FEED PAGE ]');
        print(model.searchedRecipes);
        return Column(
          children: <Widget>[
            // SizedBox(height: 5,),
            SearchButton(model),
            // SizedBox(
            //   height: 10,
            // ),
            Expanded(child: RecipeGrid(model.searchedRecipes)),
          ],
        );
      },
    );
  }
}

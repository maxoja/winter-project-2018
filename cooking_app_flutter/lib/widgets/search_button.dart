import 'package:flutter/material.dart';

import '../api.dart' as api;
import '../models/recipe.dart';
import '../scoped_models/app.dart';
import '../pages/search.dart';

//can refactor by letting some page that support search
//to implement an interface instead
class SearchButton extends StatelessWidget {
  final AppModel model;

  SearchButton(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        color: Colors.orange,
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            SizedBox(
              width: 30,
            ),
            Text('Search')
          ],
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SearchPage();
          }));
        },
      ),
    );
  }
}

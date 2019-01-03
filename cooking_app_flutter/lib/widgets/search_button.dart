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
        elevation: 5,
        padding: EdgeInsets.only(left: 10),
        // color: Colors.white,
        color:Colors.yellow[50],
        child: Padding(padding:EdgeInsets.only(left: 5,right:5),child:Row(
          // mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Icon(Icons.search),
            // Expanded(child: Container(),),
          Center(child:Text('Pick Your Desires', style: TextStyle(fontWeight:FontWeight.w400,fontSize: 15)),),
            Expanded(child: Container(),),
          Icon(Icons.chevron_right,size: 30,),
          ],
        ),),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SearchPage();
          }));
        },
      ),
    );
  }
}

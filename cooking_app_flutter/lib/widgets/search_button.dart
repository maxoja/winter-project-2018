import 'package:flutter/material.dart';

//can refactor by letting some page that support search
//to implement an interface instead
class SearchButton extends StatelessWidget {
  final State targetPageState;

  SearchButton(this.targetPageState);

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
        onPressed: () {
          print('[ ON PRESSED SEARCH BUTTON ]');
          /*
          todo
          create a request to backend
          retrieve the data and set data to the page
          */
        },
      ),
    );
  }
}

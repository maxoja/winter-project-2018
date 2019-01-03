import 'package:flutter/material.dart';

import '../models/user.dart';

class TinyUserBand extends StatelessWidget {
  final User user;

  TinyUserBand(this.user);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          maxRadius: 15,
          backgroundImage: AssetImage(user.imageUrl),
        ),
        Text(user.name),
      ],
    );
  }
}

class EpicUserBand extends StatelessWidget {
  final User user;

  EpicUserBand(this.user);

  ShapeBorder _cardShape(context) {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(25));
  }

  Widget _buildImageBlob(context) {
    return Card(
      elevation: 5,
      shape: _cardShape(context),
      child: Padding(
        padding: EdgeInsets.all(0),
        child: CircleAvatar(
          backgroundImage: AssetImage(user.imageUrl),
          radius: 25,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10),
        _buildImageBlob(context),
        SizedBox(
          width: 5,
        ),
        Card(
          elevation: 5,
          shape: _cardShape(context),
          child: Container(
            height: 40,
            width: 220,
            child: Center(
              child: Text(
                '(  Chef ${user.name}   )',
                textScaleFactor: 1.3,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color:Colors.brown,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    // Card(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
    //   child: Padding(
    //     padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         CircleAvatar(
    //           backgroundImage: AssetImage(user.imageUrl),
    //           radius: 20,
    //         ),
    //         Expanded(
    //           child: Center(
    //             child: Text(
    //               user.name.toUpperCase(),
    //               textScaleFactor: 1.5,
    //               style: TextStyle(fontWeight: FontWeight.w500),
    //             ),
    //           ),
    //         ),
    //         CircleAvatar(
    //           backgroundImage: AssetImage(user.imageUrl),
    //           radius: 20,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

/*
return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(user.imageUrl),
              radius: 20,
            ),
            Expanded(
              child: Center(
                child: Text(
                  user.name.toUpperCase(),
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage(user.imageUrl),
              radius: 20,
            ),
          ],
        ),
      ),
    );*/

import 'package:flutter/material.dart';

import '../models/user.dart';

class TinyUserBand extends StatelessWidget {
  final User user;

  TinyUserBand(this.user);

  @override
    Widget build(BuildContext context) {
      return Row(
        children: <Widget>[
          CircleAvatar(backgroundImage: AssetImage(user.imageUrl),),
          Text(user.name),
        ],
      );
    }
}


class EpicUserBand extends StatelessWidget {
  final User user;

  EpicUserBand(this.user);

  @override
    Widget build(BuildContext context) {
      return Row(
        children: <Widget>[
          CircleAvatar(backgroundImage: AssetImage(user.imageUrl),radius: 50,),
          Text(user.name),
        ],
      );
    }
}
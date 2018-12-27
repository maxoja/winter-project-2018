import 'package:flutter/material.dart';

import '../models/user.dart';

class TinyUserBand extends StatelessWidget {
  final UserModel user;

  TinyUserBand(this.user);

  @override
    Widget build(BuildContext context) {
      return Row(
        children: <Widget>[
          CircleAvatar(backgroundImage: AssetImage(user.imageUrl),),
          Text(user.id),
        ],
      );
    }
}


class EpicUserBand extends StatelessWidget {
  final UserModel user;

  EpicUserBand(this.user);

  @override
    Widget build(BuildContext context) {
      return Row(
        children: <Widget>[
          CircleAvatar(backgroundImage: AssetImage(user.imageUrl),radius: 50,),
          Text(user.id),
        ],
      );
    }
}
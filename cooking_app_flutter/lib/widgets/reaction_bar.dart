import 'package:flutter/material.dart';

enum Reaction { Like, Dislike, None }

class ReactionBar extends StatefulWidget {
  final Reaction initialReaction;
  final Function(Reaction) onChanged;

  ReactionBar(this.initialReaction, this.onChanged);

  @override
  State<StatefulWidget> createState() {
    return _ReactionBarState(initialReaction);
  }
}

class _ReactionBarState extends State<ReactionBar> {
  Reaction _reaction = Reaction.None;

  _ReactionBarState(this._reaction);

  void _setReaction(Reaction newReaction) => setState(() {
        if (_reaction != newReaction)
          _reaction = newReaction;
        else
          _reaction = Reaction.None;

        widget.onChanged(_reaction);
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _ReactionButton(Reaction.Dislike, _reaction, _setReaction),
        _ReactionButton(Reaction.Like, _reaction, _setReaction),
      ],
    );
  }
}

class _ReactionButton extends StatelessWidget {
  final Reaction targetReaction;
  final Reaction currentReaction;
  final Function setReaction;

  _ReactionButton(this.targetReaction, this.currentReaction, this.setReaction);

  @override
  Widget build(BuildContext context) {
    bool highlight = targetReaction == currentReaction;
    Color iconColor = highlight ? Colors.white : Colors.white;
    Color buttonColor = highlight ? Colors.grey : null;

    IconData iconData;

    switch (targetReaction) {
      case Reaction.Like:
        iconData = Icons.thumb_up;
        break;
      case Reaction.Dislike:
        iconData = Icons.thumb_down;
        break;
      default:
        print('[ ReactionButton got NON-DEFINED target reaction ]');
    }

    return RaisedButton(
      onPressed: () => setReaction(targetReaction),
      color: buttonColor,
      child: Icon(iconData, color: iconColor),
    );
  }
}

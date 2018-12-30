import 'user.dart';

import 'dart:convert';

class Recipe {
  final User owner;
  final String rid;
  final String title;
  final String description;
  final List<String> tags;
  final int difficulty;
  final int likes;
  final int dislikes;
  static const List<String> initialString = [];

  Recipe(this.owner, this.title, this.description, this.difficulty, this.likes,
      this.dislikes,[this.rid='',this.tags=initialString]);
  Recipe.mock() : this(User.mock(), 'ttitle', 'tdescription', 1, 0, 0);
  Recipe.fromJson(Map<String, dynamic> json)
      : owner = User.fromJson(json['owner']),
        title = json['title'],
        description = json['description'],
        difficulty = json['difficulty'],
        likes = json['likes'],
        dislikes = json['dislikes'],
        rid = json['rid'].toString(),
        tags = List<String>.from(jsonDecode('["asd"]'));

  Map<String, dynamic> toJson() => {
        'rid': rid,
        'owner': owner.toJson(),
        'title': title,
        'description': description,
        'difficulty': difficulty.toString(),
        'likes': likes.toString(),
        'dislikes': dislikes.toString(),
        'tags': tags == null ? [] : jsonEncode(tags),
      };
      
  @override
    String toString() {
      return toJson().toString();
    }
}

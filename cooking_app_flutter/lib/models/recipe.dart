import 'user.dart';

class Recipe {
  //user model of owner -> id/name/profile
  //title
  //ingredients
  //steps
  //like/dislike status

  final User owner;
  final String title;
  final String description;
  final int difficulty;
  final int likes;
  final int dislikes;

  Recipe(this.owner, this.title, this.description, this.difficulty, this.likes,
      this.dislikes);
  Recipe.mock() : this(User.mock(), 'ttitle', 'tdescription', 1, 0, 0);
  Recipe.fromJson(Map<String, dynamic> json)
      : owner = User.fromJson(json['owner']),
        title = json['title'],
        description = json['description'],
        difficulty = json['difficulty'],
        likes = json['likes'],
        dislikes = json['dislikes'];

  Map<String, dynamic> toJson() => {
        'owner': owner.toJson(),
        'title': title,
        'description': description,
        'difficulty': difficulty,
        'likes': likes,
        'dislikes': dislikes,
      };
}

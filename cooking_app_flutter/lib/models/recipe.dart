import 'user.dart';

class Recipe {
  //user model of owner -> id/name/profile
  //title
  //ingredients
  //steps
  //like/dislike status

  final User owner;
  final String title;
  final String ingredients;
  final String instructions;
  final int score;

  Recipe(this.owner, this.title, this.ingredients, this.instructions, this.score);
  Recipe.mock():this(User.mock(), 'ttitle', 'tingre', 'tinstructions', 0);
  Recipe.fromJson(Map<String, dynamic> json)
      : owner = User.fromJson(json['owner']),
        title = json['title'],
        ingredients = json['ingredients'],
        instructions = json['instructions'],
        score = json['score'];

  Map<String, dynamic> toJson() => {
    'owner': owner.toJson(),
    'title': title,
    'ingredients': ingredients,
    'instructions' : instructions,
    'score' : score
  };
}

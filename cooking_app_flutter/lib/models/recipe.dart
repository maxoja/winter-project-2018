import 'user.dart';

class RecipeModel {
  //user model of owner -> id/name/profile
  //title
  //ingredients
  //steps
  //like/dislike status

  UserModel owner;
  String title;
  String ingredients;
  String instructions;
  int score;

  RecipeModel(this.owner, this.title, this.ingredients, this.instructions, this.score);
  RecipeModel.mock():this(UserModel.mock(), 'ttitle', 'tingre', 'tinstructions', 0);
  RecipeModel.fromJson(Map<String, dynamic> json)
      : owner = UserModel.fromJson(json['owner']),
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

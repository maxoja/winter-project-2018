import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';
import '../models/recipe.dart';

class AppModel extends Model {
  User _user = User.mock();
  List<Recipe> _recipes = [];

  User get user {
    return User.fromJson(_user.toJson()); //todo do it properly
  }

  List<Recipe> get recipes {
    return List<Recipe>.from(_recipes);
  }

  AppModel() {
    _recipes = [
      Recipe.mock(),
      Recipe.mock(),
      Recipe.mock(),
      Recipe.mock(),
      Recipe.mock(),
      Recipe.mock(),
      Recipe.mock(),
    ];
  }

  void setUser(User value) {
    _user = value;
  }

  void setRecipes(List<Recipe> newRecipes) {
    this._recipes = newRecipes;
  }
}

import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';
import '../models/recipe.dart';

class AppModel extends Model {
  User _user = User.mock();
  List<Recipe> _userRecipes = [];
  List<Recipe> _searchedRecipes = [];
  //filters information should be here
  //because it's supposed to be easy to manage
  //since this page would not be destroyed after a search is executed

  User get user {
    return User.fromJson(_user.toJson()); //todo do it properly
  }

  List<Recipe> get userRecipes {
    return List<Recipe>.from(_userRecipes);
  }

  List<Recipe> get searchedRecipes => List.from(_searchedRecipes);

  AppModel() {
    for(int i = 0 ; i < 10 ; i++)
      _userRecipes.add(Recipe.mock());
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  void setUserRecipes(List<Recipe> newRecipes) {
    _userRecipes = List.from(newRecipes);
    notifyListeners();
  }

    void setSearchedRecipes(List<Recipe> newRecipes) {
      _userRecipes = List.from(newRecipes);
      notifyListeners();
  }
}
import 'package:scoped_model/scoped_model.dart';

import '../models/user.dart';
import '../models/recipe.dart';
import '../widgets/reaction_bar.dart';

class AppModel extends Model {
  User _user = User.mock();
  List<Recipe> _userRecipes = [];
  List<Recipe> _searchedRecipes = [];
  String _token;
  Recipe _selectedRecipe;
  Reaction _currentReaction;
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

  String get token => _token;

  Recipe get selectedRecipe => _selectedRecipe;

  Reaction get currentReaction => _currentReaction;

  AppModel() {
    // for(int i = 0 ; i < 10 ; i++)
    //   _userRecipes.add(Recipe.mock());
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setUser(User value) {
    _user = value;
    notifyListeners();
  }

  void setUserRecipes(List<Recipe> newRecipes) {
    _userRecipes = List.from(newRecipes);
    notifyListeners();
  }

  void setSelectedRecipe(Recipe recipe){
    _selectedRecipe = recipe;
    notifyListeners();
  }

  void setCurrentReaction(Reaction reaction){
    _currentReaction = reaction;
    notifyListeners();
  }

  void addUserRecipe(Recipe newRecipe) {
    _userRecipes.add(newRecipe);
    notifyListeners();
  }

  void setSearchedRecipes(List<Recipe> newRecipes) {
    _searchedRecipes = List.from(newRecipes);
    notifyListeners();
  }
}

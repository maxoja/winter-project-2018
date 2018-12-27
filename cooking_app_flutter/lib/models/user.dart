//??? can these models converted to immutable classes

class UserModel {
  //id
  //name
  //(later) profile image

  /* 
  there should be no posts here 
  since it would be meaningless to have only post ids without content 
  */

  String id;
  String name;
  String imageUrl;

  UserModel(this.id, this.name, [this.imageUrl='assets/temp_profile.jpeg']);
  UserModel.fromJson(Map<String, dynamic> json) :
  id = json['id'], name = json['name'];
  UserModel.mock(): this('12392','abaran');

  Map<String, dynamic> toJson() => {
    'id':id,
    'name':name,
  };
}
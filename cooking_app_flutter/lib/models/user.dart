//??? can these models converted to immutable classes

class User {
  //id
  //name
  //(later) profile image

  /* 
  there should be no posts here 
  since it would be meaningless to have only post ids without content 
  */

  final String id;
  final String name;
  final String imageUrl;

  User(this.id, this.name, [this.imageUrl='assets/temp_profile.jpeg']);
  User.fromJson(Map<String, dynamic> json) :this(json['id'].toString(), json['name']);
  User.mock(): this('12392','abaran');

  Map<String, dynamic> toJson() => {
    'id':id,
    'name':name,
  };

  @override
    String toString() {
      return toJson().toString();
    }
}
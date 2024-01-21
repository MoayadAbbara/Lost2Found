class UserModel {
  String? id;
  String username;
  String email;

  UserModel({this.id ,required this.username,required this.email});

  Map <String , dynamic> tojson()
  {
    return {
      'UserName' : username,
      'Email' : email
    };
  }
}

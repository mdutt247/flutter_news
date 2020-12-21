class UserModel {
  String id;
  String fname;
  String lname;
  String email;
  String avatar;
  String token;

  UserModel({this.id, this.fname, this.lname, this.email, this.avatar, this.token});

  UserModel.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['author_id'].toString();
    this.fname = jsonObject['first_name'];
    this.lname = jsonObject['last_name'];
    this.email = jsonObject['author_email'];
    this.avatar = jsonObject['avatar'];
    this.token = jsonObject['token'];
  }
}


// factory User.fromJson(Map<String, dynamic> responseData) {
// return User(
// userId: responseData['id'],
// name: responseData['name'],
// email: responseData['email'],
// phone: responseData['phone'],
// type: responseData['type'],
// token: responseData['access_token'],
// renewalToken: responseData['renewal_token']
// );
// }
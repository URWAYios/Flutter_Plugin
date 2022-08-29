class Post {
  final String strUsername;
  final String strPassword;

  Post({required this.strUsername, required this.strPassword});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      strUsername: json['userid'],
      strPassword: json['password'],

    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["userId"] = strUsername;
    map["password"] =strPassword;
    return map;
  }
}

class User {
  final int? id;
  final String? email;
  final String? password;

  User(this.email, this.password, this.id);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['email'], json['password'], json['id']);
  }
}

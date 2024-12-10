class User {
  final int userId;
  final String username;
  final String email;

  User(this.userId, this.username, this.email);

  // Для того, чтобы можно было создавать объекты из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['user_id'],
      json['username'],
      json['email'],
    );
  }
}

late User? currentUser;

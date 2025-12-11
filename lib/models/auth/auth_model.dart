class AuthModel {
  String? refreshToken, accessToken;
  User? user;
  AuthModel({this.accessToken, this.refreshToken, this.user});
  factory AuthModel.fromJson(Map<String, dynamic> jsonData) {
    return AuthModel(
        accessToken: jsonData['accessToken'],
        refreshToken: jsonData['refreshToken'],
        user: User.fromjson(jsonData['user']));
  }
}

class User {
  String? userId, userName, email, createdAt, role;
  bool? isDeleted, isBlocked;
  User({
    this.createdAt,
    this.email,
    this.isBlocked,
    this.isDeleted,
    this.role,
    this.userId,
    this.userName,
  });
  factory User.fromjson(Map<String, dynamic> jsonData) {
    return User(
      createdAt: jsonData['createdAt'],
      email: jsonData['email'],
      isBlocked: jsonData['isBlocked'],
      isDeleted: jsonData['isDeleted'],
      role: jsonData['role'],
      userId: jsonData['_id'],
      userName: jsonData['name'],
    );
  }
}

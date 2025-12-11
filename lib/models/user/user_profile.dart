class UserProfile {
  String? uid, name, email, role, createdAt;
  int? treasurePosted, treasureCollected, tipGiven, tipReceived;
  UserProfile(
      {this.createdAt,
      this.email,
      this.name,
      this.role,
      this.tipGiven,
      this.tipReceived,
      this.treasureCollected,
      this.treasurePosted,
      this.uid});
  factory UserProfile.fromJson(Map<String, dynamic> jsonData) {
    return UserProfile(
      createdAt: jsonData['createdAt'],
      email: jsonData['email'],
      name: jsonData['name'],
      role: jsonData['role'],
      tipGiven: jsonData['totalTipsGivenAmount'],
      tipReceived: jsonData['totalTipsReceivedAmount'],
      treasureCollected: jsonData['totalTreasuresCollected'],
      treasurePosted: jsonData['totalTreasuresPosted'],
      uid: jsonData['_id'],
    );
  }
}

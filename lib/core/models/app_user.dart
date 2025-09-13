class AppUser {
  final String uid;
  final String fullName;
  final String email;

  AppUser({required this.uid, required this.fullName, required this.email});

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      fullName: data['fullName'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> data) {
    return AppUser(
      uid: data['id'] ?? '',
      fullName: data['fullName'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
    );
  }
}

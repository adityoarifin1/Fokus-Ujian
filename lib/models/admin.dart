class Admin {
  final int? idAdmin;
  final String username;
  final String passwordHash;
  final String role; // 'admin' atau 'guru'

  Admin({
    this.idAdmin,
    required this.username,
    required this.passwordHash,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_admin': idAdmin,
      'username': username,
      'password_hash': passwordHash,
      'role': role,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      idAdmin: map['id_admin'],
      username: map['username'],
      passwordHash: map['password_hash'],
      role: map['role'] ?? 'guru',
    );
  }
}

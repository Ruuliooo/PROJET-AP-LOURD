class Utilisateur {
  final int id;
  final String email;
  final bool isAdmin;

  Utilisateur({required this.id, required this.email, required this.isAdmin});

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      email: json['email'],
      isAdmin: json['admin'] == 1,
    );
  }
}

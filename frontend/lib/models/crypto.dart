class Crypto {
  final int id;
  final String nom;
  final String tag;
  final double quantite;
  final int prix; // en dollars

  Crypto({
    required this.id,
    required this.nom,
    required this.tag,
    required this.quantite,
    required this.prix,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      nom: json['nom'],
      tag: json['tag'],
      quantite: double.parse(json['quantite'].toString()),
      prix: json['prix'], // pas besoin de parse si c'est un int
    );
  }
}

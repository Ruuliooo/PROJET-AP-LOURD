class TransactionModel {
  final int id;
  final int utilisateurId;
  final int cryptoId;
  final double quantite;
  final String typeOperation;
  final double prixUnitaire;
  final String dateOperation;
  final String email; // 👈 ajouté

  TransactionModel({
    required this.id,
    required this.utilisateurId,
    required this.cryptoId,
    required this.quantite,
    required this.typeOperation,
    required this.prixUnitaire,
    required this.dateOperation,
    required this.email,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      utilisateurId: json['utilisateur_id'],
      cryptoId: json['crypto_id'],
      quantite: double.parse(json['quantite'].toString()),
      typeOperation: json['type_operation'],
      prixUnitaire: double.parse(json['prix_unitaire'].toString()),
      dateOperation: json['date_operation'],
      email: json['email'], // 👈 récupéré depuis jointure
    );
  }
}

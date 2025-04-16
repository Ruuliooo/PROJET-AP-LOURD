// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/crypto.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  
  // Récupérer les cryptos depuis l'API Node
  static Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse('$baseUrl/cryptos'));

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Crypto.fromJson(data))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des cryptomonnaies.');
    }
  }
}

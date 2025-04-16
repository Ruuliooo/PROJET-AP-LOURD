import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/crypto.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  late Future<List<Crypto>> _cryptoList;
  List<Crypto> _allCryptos = []; // ✅ on garde la liste complète
  List<Crypto> _filteredCryptos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cryptoList = fetchCryptos();
    _searchController.addListener(_filterCryptos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse('http://localhost:3000/cryptos'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Crypto> cryptos = data.map((json) => Crypto.fromJson(json)).toList();
      setState(() {
        _allCryptos = cryptos;
        _filteredCryptos = cryptos;
      });
      return cryptos;
    } else {
      throw Exception('Erreur de chargement des cryptomonnaies');
    }
  }

  void _filterCryptos() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredCryptos = _allCryptos;
      } else {
        _filteredCryptos = _allCryptos
            .where((crypto) =>
                crypto.nom.toLowerCase().contains(query) ||
                crypto.tag.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 75, 72, 72),
      appBar: AppBar(
        title: const Text('Liste des cryptomonnaies'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: _cryptoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune cryptomonnaie trouvée.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Rechercher une crypto...",
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _filteredCryptos.length,
                  itemBuilder: (context, index) {
                    final crypto = _filteredCryptos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const Icon(Icons.rocket_launch,
                            color: Color.fromARGB(255, 228, 105, 5), size: 32),
                        title: Text(
                          crypto.nom,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "Tag : ${crypto.tag}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Quantité : ${crypto.quantite.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            Text(
                              "Valeur : \$${crypto.prix}",
                              style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

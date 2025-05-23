import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction.dart';

class TransacScreen extends StatefulWidget {
  const TransacScreen({super.key});

  @override
  State<TransacScreen> createState() => _TransacScreenState();
}

class _TransacScreenState extends State<TransacScreen> {
  late Future<List<TransactionModel>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = fetchTransactions();
  }

  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await http.get(Uri.parse('http://localhost:3000/transactions'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 36, 36),
      appBar: AppBar(
        title: const Text('Historique des Transactions'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}',
                  style: const TextStyle(color: Colors.white)),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucune transaction trouvée.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final transac = snapshot.data![index];
              final isAchat = transac.typeOperation.toLowerCase() == 'achat';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction ID: ${transac.id}',
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email : ${transac.email}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Crypto ID : ${transac.cryptoId}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Quantité : ${transac.quantite.toStringAsFixed(4)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Type : ${transac.typeOperation}',
                      style: TextStyle(
                        color: isAchat ? Colors.greenAccent : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Prix unitaire : ${transac.prixUnitaire.toStringAsFixed(2)} \$',
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                    Text(
                      'Date : ${transac.dateOperation}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

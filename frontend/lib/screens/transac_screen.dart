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
      appBar: AppBar(title: const Text('Historique des Transactions')),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune transaction trouvée.'));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Crypto ID')),
                DataColumn(label: Text('Quantité')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Prix')),
                DataColumn(label: Text('Date')),
              ],
              rows: snapshot.data!.map((transac) {
                return DataRow(cells: [
                  DataCell(Text(transac.id.toString())),
                  DataCell(Text(transac.email)),
                  DataCell(Text(transac.cryptoId.toString())),
                  DataCell(Text(transac.quantite.toStringAsFixed(4))),
                  DataCell(Text(transac.typeOperation)),
                  DataCell(Text('${transac.prixUnitaire.toStringAsFixed(2)} \$')),
                  DataCell(Text(transac.dateOperation)),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:projeto_final/src/transaction/transaction.dart';

class Account {
  final int? id;
  final String? conta;
  final String? data;
  final String? descricao;
  final String? saldo;
  final List<Transaction>? movimentacoes;

  Account(
      {this.id,
        this.conta,
        this.data,
        this.descricao,
        this.saldo,
        this.movimentacoes,
      });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      conta: json['conta'],
      data: json['data_criacao'],
      descricao: json['descricao'],
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'conta': conta,
      'data_criacao': data,
      'descricao': descricao,
    });
  }
}

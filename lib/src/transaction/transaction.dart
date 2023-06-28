import 'dart:convert';

class Transaction {
  final int? id;
  final String? dataMovimentacao;
  final String valor;
  final String? acao;
  final String? conta;
  final String descricao;
  final String? saldo;


  Transaction({
    this.id,
    this.dataMovimentacao,
    required this.valor,
    this.acao,
    this.conta,
    required this.descricao,
    this.saldo,
  });


  String toJson() {
    return jsonEncode({
      'conta': conta,
      'descricao': descricao,
      'valor': valor,
    });
  }
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      conta: json['conta'],
      dataMovimentacao: json['data_movimentacao'],
      descricao: json['descricao'],
      valor: json['valor'].toString(),
      saldo: json['saldo'].toString(),
    );
  }

}

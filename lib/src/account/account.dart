import 'dart:convert';

class Account {
  final int? id;
  final String? conta;
  final String? data;
  final String? descricao;

  Account(
      {this.id,
        this.conta,
        this.data,
        this.descricao,
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

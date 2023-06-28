class Transaction {
  final int? id;
  final DateTime? dataMovimentacao;
  final double valor;
  final String acao;
  final String descricao;

  Transaction({
    this.id,
    this.dataMovimentacao,
    required this.valor,
    required this.acao,
    required this.descricao,
  });
}

import 'package:flutter/material.dart';
import 'package:projeto_final/src/account/account.dart';
import 'package:projeto_final/src/account/account_service.dart';
import 'package:projeto_final/src/lib/component/app_scaffold.dart';
import 'package:projeto_final/src/transaction/transaction.dart';
import 'package:projeto_final/src/transaction/transaction_form.dart';

class TransactionView extends StatefulWidget {
  final Account? account;

  const TransactionView({super.key, this.account});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionViewState createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  late Future<List<Transaction>> transaction;
  late String? accountNumber;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Container(
        width: 402,
        height: 503,
        decoration: const BoxDecoration(),
        child: _buildTransactionView(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    accountNumber = widget.account?.conta;
    transaction = fetchTransaction();
  }

  Future<List<Transaction>> fetchTransaction() async {
    try {
      transaction = AccountService().getTransactions(accountNumber!);

      setState(() {
        transaction = transaction;
      });
      return transaction;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _refreshAccounts() async {
    setState(() {
      transaction = fetchTransaction();
    });
  }

  Widget _buildTransactionView() {

    return FutureBuilder<List<Transaction>>(
      future: transaction,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              Center(
                child: Text('Algo inesperado aconteceu: ${snapshot.error}'),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          final transactions = snapshot.data!;
          if (transactions.isEmpty) {
            return const SingleChildScrollView(
                child: Column(
              children: [
                Center(child: Text('Nenhuma Conta foi encontrada.')),
              ],
            ));
          } else {
            return Column(
              children: [
                Center(
                  child: Center(
                    child: Text(
                        'Conta: ${transactions[0].conta}\nSaldo Atual : ${transactions[0].saldo.toString().replaceAll('.', ',')} '),
                  ),
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransactionFormPage(account: accountNumber),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('NOVA MOVIMENTAÇÃO',
                      style: TextStyle(color: Colors.white)),
                ),
                const Divider(),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];

                      return Column(
                        children: [
                          ListTile(

                              title: Text(
                                'R\$ ${transaction.valor.replaceAll('.', ',')}',
                              ),
                              subtitle: Text(
                                  'Descrição: ${transaction.descricao} \nData: ${transaction.dataMovimentacao}')),
                          const Divider(
                             height: 1.0,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        } else {
          return const SizedBox(
            height: 100,
            child: Text('Gerar Nova Conta'),
          );
        }
      },
    );
  }
}

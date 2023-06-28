import 'package:flutter/material.dart';
import 'package:projeto_final/src/transaction/transaction.dart';
import 'package:projeto_final/src/transaction/transaction_service.dart';
import 'package:projeto_final/src/transaction/transaction_view.dart';


class TransactionFormPage extends StatefulWidget {
  final Transaction? transaction;
  final String? account;

  const TransactionFormPage({super.key, this.transaction, this.account});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionFormPageState createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String? _conta;
  late TextEditingController _valorController;
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _conta = widget.account!;
    _valorController = TextEditingController();
    _descricaoController = TextEditingController();
  }

  @override
  void dispose() {

    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final Transaction transaction = Transaction(
        valor: _valorController.text,
        descricao: _descricaoController.text,
        conta: _conta,
      );

      try {
        await TransactionService().createTransaction(transaction).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movimentação salva com sucesso.')),
          );
          // ignore: use_build_context_synchronously
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const TransactionView(),
              ));
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Movimentação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatorio!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo Obrigatorio!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

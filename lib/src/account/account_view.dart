import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_final/src/account/account.dart';
import 'package:projeto_final/src/account/account_service.dart';
import 'package:projeto_final/src/auth/auth_service.dart';
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late Future<List<Account>> accounts;
  late int idPessoa = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAccountView(),
        _floatButton(),
      ],
    );
  }

  int present = 0;
  int perPage = 15;

  @override
  void initState() {
    super.initState();
    accounts = fetchAccounts();
  }

  void start() {
    final authService = Provider.of<AuthService>(context);
    idPessoa = authService.user!.id;
  }

  Future<List<Account>> fetchAccounts() async {
    try {
      accounts = AccountService().getAccounts(idPessoa);

      setState(() {
        accounts = accounts;
      });
      return accounts;
    } catch (e) {
      throw Exception(e);
    }
  }

  Widget _floatButton() {
    final TextEditingController textFieldController = TextEditingController();
    void showcontent() {
      showDialog(
        context: context, barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Criação da conta'),
            content: TextFormField(
              controller: textFieldController,
              decoration: const InputDecoration(hintText: "Descrição da conta"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  print(textFieldController.text);
                  if (textFieldController.text != '') {
                    AccountService()
                        .createAccount(textFieldController.text, idPessoa).then((value) {
                          if(value){
                            _refreshAccounts();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Conta Criada com sucesso.')),
                            );
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Não Foi possível criar a Conta.')),
                            );
                          }
                          Navigator.of(context).pop();
                    });

                  }

                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Builder(builder: (context) {
      FloatingActionButtonLocation.endDocked;
      return Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              showcontent();
            },
            tooltip: 'Novo',
            shape: const CircleBorder(),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add,
                color: Colors.white, size: 30, weight: 950),
          ),
        ],
      );
    });
  }

  Future<void> _refreshAccounts() async {
    setState(() {
      accounts = fetchAccounts();
    });
  }

  Widget _buildAccountView() {
    start();
    void showDialogEdit(Account account) {
      final TextEditingController textFieldControllerEdit =
          TextEditingController(text: account.descricao);
      showDialog(
        context: context, barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edição da Descrição da Conta '),
            content: TextField(
              controller: textFieldControllerEdit,
              decoration: const InputDecoration(hintText: "Descrição"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  AccountService()
                      .updateAccount(textFieldControllerEdit.text, account.id)
                      .then((value) {
                    if (value) {
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Conta Editada com sucesso.')),
                      );
                      _refreshAccounts();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Não Foi possivel editar a Conta.')),
                      );
                    }
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<List<Account>>(
      future: accounts,
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
          final accpunts = snapshot.data!;
          if (accpunts.isEmpty) {
            return const SingleChildScrollView(
                child: Column(
              children: [
                Center(child: Text('Nenhuma Conta foi encontrada.')),
              ],
            ));
          } else {
            return Expanded(
              child: ListView.builder(
                itemCount: accpunts.length,
                itemBuilder: (context, index) {
                  final account = accpunts[index];
                  return ListTile(
                    title: Text(
                        'Conta : ${account.conta ?? ''} \nCriação : ${account.data ?? ''}'),
                    subtitle: Text('Descrição: ${account.descricao}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showDialogEdit(account);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Deletar conta?'),
                                content: const Text(
                                    'Tem certeza de que deseja excluir esta Conta, todos os registros serão perdidos?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: const Text('Deletar'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      AccountService()
                                          .deleteAccount(account.conta!)
                                          .then(
                                        (value) {
                                          if (value) {
                                            _refreshAccounts();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Conta excluida com sucesso.')),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
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

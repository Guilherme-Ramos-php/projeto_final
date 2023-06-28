import 'package:flutter/material.dart';
import 'package:projeto_final/src/account/account_view.dart';
import 'package:projeto_final/src/lib/component/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: 'Página Inicial',
      child: Container(
        width: 402,
        height: 503,
        decoration: const BoxDecoration(),
        child: AccountView(),
      ),
    );
  }
}
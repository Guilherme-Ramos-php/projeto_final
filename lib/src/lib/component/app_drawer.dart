import 'package:flutter/material.dart';
import 'package:projeto_final/src/auth/auth_service.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person_2_outlined)
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                    authService.user?.name ?? '-',
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('DashBoard'),
            onTap: () {
              Navigator.of(context)
                  .popUntil((route) => !Navigator.of(context).canPop());
              Navigator.popAndPushNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              authService.logout().then((value) {
                Navigator.of(context)
                    .popUntil((route) => !Navigator.of(context).canPop());
                Navigator.of(context).popAndPushNamed('/auth/login');
              });
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projeto_final/src/lib/component/app_drawer.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_service.dart';

class AppScaffold extends StatelessWidget {
  final String? pageTitle;
  final Widget? child;

  const AppScaffold({super.key, this.child, this.pageTitle});


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(pageTitle ?? 'Easy Money'),
      ),
      body:SafeArea(
        top: true,
        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: 399,
                  height: 130,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 8, 22, 171),
                        Color.fromARGB(255, 101, 108, 236),

                      ],
                      stops: [0, 1],
                      begin: AlignmentDirectional(0, -1),
                      end: AlignmentDirectional(0, 1),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: const AlignmentDirectional(-0.01, -0.79),
              child: Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://imageproxy.ifunny.co/crop:x-20,resize:640x,quality:90x75/images/e4227d4f98903493503bbae8cabb1347b41bdfbb76473b04181f54af521c2d90_1.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, -0.48),
              child: Container(
                width: 390,
                height: 51,
                decoration: const BoxDecoration(

                ),
              ),
            ),
            Align(
                alignment: const AlignmentDirectional(-0.83, -0.46),
                child: Text('Seja Bem Vindo ${authService.user?.name ?? ' '}')
            ),
            Align(
              alignment: const AlignmentDirectional(-31.11, 0.11),
              child: Container(
                width: 100,
                height: 318,
                decoration: const BoxDecoration(

                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 1.5),
              child: child
            ),
          ],
        ),
      ),
    );
  }
}

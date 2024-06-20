import 'package:bitirme_tezi/View/anaSayfa.dart';
import 'package:bitirme_tezi/ViewModel/AnaSayfaViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth.dart';
import '../View/anaSayfa_userActive.dart';

class OnBoardWidget extends StatefulWidget {
  const OnBoardWidget({super.key});

  @override
  State<OnBoardWidget> createState() => _OnBoardWidgetState();
}

class _OnBoardWidgetState extends State<OnBoardWidget> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);

    return StreamBuilder<User?>(
      stream: _auth.authStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.data != null
              ? ChangeNotifierProvider(
                  create: (context) => AnaSayfaViewModel(),
                  builder: (context, child) =>
                      const anaSayfaUserActive(title: 'Bul Al'))
              : ChangeNotifierProvider(
                  create: (context) => AnaSayfaViewModel(),
                  builder: (context, child) => const AnaSayfa(title: 'Bul Al'));
        } else {
          return const SizedBox(
            height: 300,
            width: 300,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

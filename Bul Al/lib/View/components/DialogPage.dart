import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class DialogPage extends StatelessWidget {
  final String mailText;
  final String normalText;
  final String sifreText;
  final bool logout;

  const DialogPage({super.key, required this.mailText, required this.normalText, required this.sifreText, required this.logout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(sifreText),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(mailText),
            Text(normalText),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('TAMAM'),
          onPressed: () {
            if(logout == true) {
              Provider.of<Auth>(context, listen: false).signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
            }
            else {
              Navigator.pop(context);
            }
          },
        ),
        TextButton(
          child: const Text('İPTAL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

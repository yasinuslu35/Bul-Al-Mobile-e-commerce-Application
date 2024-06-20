import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/LoggedInViewModel.dart';
import '../UserInformationPages/loggedInBilgiler.dart';

class IconPerson extends StatelessWidget {
  final Widget widget;

  const IconPerson({
    super.key,
    required String? name, required this.widget,
  }) : _name = name;

  final String? _name;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => LoggedInViewModel(),
              builder: (context, child) => widget,
            ),
          ),
        );
      },
      icon: Icon(Icons.person),
    );
  }
}
import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final String title;
  final String subTitle;
  final Icon icon;

  const Cards({
    super.key, required this.title, required this.subTitle,  required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          print("listtile tıklandı");
        },
        leading: icon,
        title: Text(title),
        subtitle:  Text(subTitle),
        trailing: const Icon(Icons.navigate_next),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnaSayfaViewModel extends ChangeNotifier {
  List<String> mapToString(Map<String, dynamic> data) {
    List<String> keys = data.values.map((value) => value.toString()).toList();
    print('keys = $keys');
    print(keys.runtimeType);
    return keys;
  }

  Icon buildIconFromFirestoreData(Map<String, dynamic> data) {
    String iconData = data['icon'];

    IconData? icon = getIconFromString(iconData);
    Icon iconWidget = Icon(
      icon,
      size: 56,
    );

    return iconWidget;
  }

  IconData? getIconFromString(String iconName) {
    switch (iconName) {
      case 'Icons.tv':
        return Icons.tv;
      // Diğer icon isimleri buraya eklenebilir
      case 'Icons.settings_remote':
        return Icons.settings_remote;
      default:
        return null;
    }
  }
}

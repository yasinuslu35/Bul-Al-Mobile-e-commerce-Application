import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Model/LoggedInModel.dart';

class LoggedInViewModel extends ChangeNotifier {
  List<LoggedInModel> _titles = [
    LoggedInModel(title: 'Sepetim'),
    LoggedInModel(title: 'Siparişlerim'),
    LoggedInModel(title: 'Kişisel Bilgilerim'),
    LoggedInModel(title: 'Şifre Değişikliği'),
    LoggedInModel(title: '2 aşamalı doğrulama'),
    LoggedInModel(title: 'Hesap İptali'),

  ];

  List<LoggedInModel> get titles => _titles;

  List<LoggedInModel> _titlesDiger = [
    LoggedInModel(title: 'Yardım'),
    LoggedInModel(title: 'Sorun/ Öneri Bildirimi'),
    LoggedInModel(title: 'Hakkında'),
    LoggedInModel(title: 'Dil Tercihi'),
  ];

  List<LoggedInModel> get titlesDiger => _titlesDiger;
}

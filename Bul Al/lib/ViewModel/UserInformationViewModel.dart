import 'package:bitirme_tezi/Model/UserInformationModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../services/auth.dart';

class UserInformationViewModel extends ChangeNotifier {
  final Auth _auth = Auth();
  TextEditingItems _items = TextEditingItems();
  late List<UserInformationModel> _model;
  late UserInformationModel _phoneModel;

  UserInformationViewModel() {
    _items = TextEditingItems();
    _model = _initializemodel();
    _phoneModel = _initializePhoneModel();
  }

  List<UserInformationModel> get model => _model;

  UserInformationModel get phoneModel => _phoneModel;

  _initializePhoneModel() {
    return UserInformationModel(
      yazi: '',
      controller: _items.phoneController,
    );
  }

  List<UserInformationModel> _initializemodel() {
    return [
      UserInformationModel(
        yazi: getName()!,
        controller: _items.nameController,
      ),
      UserInformationModel(
        yazi: getSurname()!,
        controller: _items.surnameController,
      ),
    ];
  }

  String? NameSurnameValidator(String value) {
    final RegExp ozelKarakterler = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (value == null || value.isEmpty) {
      return 'Bu alanı doldurun.';
    }
    if (ozelKarakterler.hasMatch(value) || value.length < 2) {
      return 'Adınız en az 2 harften oluşmalıdır ve izin verilmeyen karakter içermemelidir.';
    } else {
      return null;
    }
  }

  List<String?> getNameSurname() {
    String? nameSurname = _auth.getName();
    List<String?> nameSurnameDizisi = nameSurname!.split(' ');
    return nameSurnameDizisi;
  }

  String? getName() {
    return getNameSurname().first;
  }

  String? getSurname() {
    return getNameSurname().last;
  }

  Future<void> Btn_Click(Function showToast) async {
    final user = await updateUserData();

    showToast('Kullanıcı bilgileri başarıyla güncellendi');
  }

  Future<void> updateUserData() async {
    print(int.parse(_phoneModel.controller.text));
    String? displayName =
        '${_model[0].controller.text} ${_model[1].controller.text}';
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        print(_auth.getEmail());
        await user.updateDisplayName(displayName);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.getEmail())
            .update({
          'name': _model[0].controller.text,
          'surname': _model[1].controller.text,
          'PhoneNumber': int.parse(_phoneModel.controller.text),
        });
        print('Kullanıcı verileri başarıyla güncellendi.');
      } catch (e) {
        print('Kullanıcı verilerini güncellerken bir hata oluştu: $e');
      }
    } else {
      print('Oturum açık bir kullanıcı bulunamadı.');
    }
  }
}



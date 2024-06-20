import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/loginPageModel.dart';
import '../services/auth.dart';

class NameSurnameViewModel extends ChangeNotifier {
  TextEditingItems _textEditingitems = TextEditingItems();
  late List<LoginPageInputBoxModel> _textFieldNameSurname;
  Auth auth = Auth();

  NameSurnameViewModel() {
    _textEditingitems = TextEditingItems();
    _textFieldNameSurname = _initializeTextFieldNameSurname();
  }

  List<LoginPageInputBoxModel> get textFieldNameSurname => _textFieldNameSurname;

  List<LoginPageInputBoxModel> _initializeTextFieldNameSurname() {
    return [
      LoginPageInputBoxModel(
        yazi: 'Ad',
        isPassword: false,
        boyut: 0.38,
        controller: _textEditingitems.nameController,
        validator: (value) {
          return NameSurnameValidator(value!);
        },
      ),
      LoginPageInputBoxModel(
        yazi: 'Soyad',
        isPassword: false,
        boyut: 0.38,
        controller: _textEditingitems.surnameController,
        validator: (value) {
          return NameSurnameValidator(value!);
        },
      ),
    ];

  }

  String? NameSurnameValidator(String value) {
    final RegExp ozelKarakterler = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (value == null || value.isEmpty) {
      return 'Bu alanı doldurun.';
    }
    if(ozelKarakterler.hasMatch(value) || value.length < 2) {
      return 'Adınız en az 2 harften oluşmalıdır ve izin verilmeyen karakter içermemelidir.';
    }
    else {
      return null;
    }
  }

  Future<void> btn_Click(String? email) async{
    try {
      await writeToFirestore(_textFieldNameSurname[0].controller.text,
          _textFieldNameSurname[1].controller.text, email);

      await updateUserData(email);
    } on FirebaseAuthException catch (e) {
      print(
        'Kayıt formu içerisinde hata yakalandı, ${e.message}',
      );
      if (e.code == 'email-already-in-use') {
        print('email zaten kullanılıyor.');
      } else if (e.code == 'invalid-email') {
        print('geçersiz email.');
      }
    }

  }

  Future<void> updateUserData(String? email) async{
    await auth.updateUserData(email!, _textFieldNameSurname[0].controller.text,
      _textFieldNameSurname[1].controller.text);
  }

  Future<void> writeToFirestore(String name,String surname,String? email) async {
    try {
      String? customId = email;
      // Firestore veritabanı referansı
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Veriyi Firestore'a yazma
      await firestore.collection('users').doc(customId).set({
        'name': name,
        'surname': surname,
        'email': email,
      });

      print('Veri Firestore\'a başarıyla yazıldı.');
    } catch (e) {
      print('Firestore\'a veri yazarken hata oluştu: $e');
    }
  }
}
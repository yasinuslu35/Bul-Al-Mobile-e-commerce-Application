import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/ChangePasswordModel.dart';

class ChangePswordViewModel extends ChangeNotifier {
  late List<ChangePasswordModel> _models;
  late TextEditingItems _textEditingItems;

  ChangePswordViewModel() {
    _textEditingItems = TextEditingItems();
    _models = _initializeModel();
  }

  List<ChangePasswordModel> get models => _models;

  List<ChangePasswordModel> _initializeModel() {
    return [
      ChangePasswordModel(
        text: 'Mevcut Şifre',
        controller: _textEditingItems.oldPasswordController,
        validator: (value) => passwordValidator(value!),
      ),
      ChangePasswordModel(
        text: 'Yeni Şifre',
        controller: _textEditingItems.newPasswordController,
        validator: (value) => passwordValidator(value!),
      ),
      ChangePasswordModel(
        text: 'Yeni Şifre (Tekrar)',
        controller: _textEditingItems.newPasswordConfirmController,
        validator: (value) => passwordConfirmValidator(
            value!, _textEditingItems.newPasswordController),
      ),
    ];
  }

  Future<void> Btn_Click(Function showErrorDialog) async {
    try {
      await changePassword();
    } on FirebaseAuthException catch (e) {
      print(
        'Kayıt formu içerisinde hata yakalandı, ${e.message}',
      );
      print(e.code);
      if (e.code == 'invalid-credential') {
        print('Şifre yanlışşş');
        showErrorDialog('hataaaa');
      }
      if (e.code == 'too-many-requests') {
        showErrorDialog('Çok fazla hatalı giriş yaptınız..');
      }
    }
  }

  Future<void> changePassword() async {
    String oldPassword = _textEditingItems.oldPasswordController.text;
    String newPassword = _textEditingItems.newPasswordController.text;
    // Mevcut kullanıcıyı al
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Eski parola ile kullanıcıyı yeniden doğrula
      AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!, password: oldPassword);
      await user.reauthenticateWithCredential(credential);

      // Yeni parolayı ayarla
      await user.updatePassword(newPassword);

      print('Parola başarıyla güncellendi.');
    } else {
      print('Kullanıcı oturumu yok.');
    }
  }

  String? passwordValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş olamaz';
    }
    // Şifre doğrulama regex'i
    RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Geçersiz şifre.';
    }
    return null; // Geçerli
  }

  String? passwordConfirmValidator(
      String value, TextEditingController passwordController) {
    if (value == null || value.isEmpty) {
      return 'Şifre onay kısmı boş olamaz.';
    }
    if (passwordController.text != value) {
      return 'Şifreler aynı değil';
    } else {
      return null;
    }
  }
}

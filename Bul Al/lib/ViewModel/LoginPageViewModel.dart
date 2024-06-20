import 'package:bitirme_tezi/View/components/showDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/loginPageModel.dart';
import '../services/auth.dart';

class LoginPageViewModel extends ChangeNotifier {
  late TextEditingItems _textEditingitems;
  late List<LoginPageInputBoxModel> _textFieldLogin;
  late List<LoginPageInputBoxModel> _textFieldRegister;


  LoginPageViewModel() {
    _textEditingitems = TextEditingItems();
    _textFieldLogin = _initializeTextFieldLogin();
    _textFieldRegister = _initializeTextFieldRegister();
  }

  List<LoginPageInputBoxModel> get textFieldLogin => _textFieldLogin;

  List<LoginPageInputBoxModel> get textFieldRegister => _textFieldRegister;

  List<LoginPageInputBoxModel> _initializeTextFieldLogin() {
    return [
      LoginPageInputBoxModel(
        yazi: 'E-posta adresi',
        isPassword: false,
        boyut: 0.8,
        controller: _textEditingitems.emailController,
        validator: (value) => eMailLoginValidator(value!),
      ),
      LoginPageInputBoxModel(
        yazi: 'Şifre',
        isPassword: true,
        boyut: 0.8,
        controller: _textEditingitems.passwordController,
        validator: (value) => passwordLoginValidator(value!),
      ),
    ];
  }

  List<LoginPageInputBoxModel> _initializeTextFieldRegister() {
    return [
      LoginPageInputBoxModel(
        yazi: 'E-posta adresi',
        isPassword: false,
        boyut: 0.8,
        controller: _textEditingitems.registerEmailController,
        validator: (value) {
          return eMailValidator(value!);
        },
      ),
      LoginPageInputBoxModel(
        yazi: 'Şifre',
        isPassword: true,
        boyut: 0.8,
        controller: _textEditingitems.registerPasswordController,
        validator: (value) {
          return passwordValidator(value!);
        },
      ),
      LoginPageInputBoxModel(
        yazi: 'Şifre Onay',
        isPassword: true,
        boyut: 0.8,
        controller: _textEditingitems.registerPasswordConfirmController,
        validator: (value) {
          return passwordConfirmValidator(
              value!,
              _textEditingitems.registerPasswordController,
              _textEditingitems.registerPasswordConfirmController);
        },
      ),
    ];
  }

  Auth _auth = Auth();

  Future<User?> createUserWithEmailAndPasswordData() async {
    print('textFieldRegister = ${textFieldRegister[0].controller.text}');
    print('textFieldRegister = ${textFieldRegister[1].controller.text}');
    return await _auth.createUserWithEmailAndPasswordData(
        textFieldRegister[0].controller.text,
        textFieldRegister[1].controller.text);
  }

  Future<User?> signInWithEmailAndPasswordData() async {
    print('loginController = ${textFieldLogin[0].controller.text}');
    if (textFieldLogin[0].controller.text.isEmpty) {
      return await _auth.signInWithEmailAndPasswordData(
          textFieldRegister[0].controller.text,
          textFieldRegister[1].controller.text);
    } else {
      return await _auth.signInWithEmailAndPasswordData(
          textFieldLogin[0].controller.text, textFieldLogin[1].controller.text);
    }
  }

  Future<void> signOut() async {
    _auth.signOut();
  }

  String? eMailValidator(String value) {
    print('e-mail value = $value');
    if (value == null || value.isEmpty) {
      return 'E-posta adresi boş olamaz';
    }
    // E-posta doğrulama regex'i
    RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçersiz e-posta adresi';
    }
    return null; // Geçerli
  }

  String? eMailLoginValidator(String value) {
    print('e-mail value = $value');
    if (value == null || value.isEmpty) {
      return 'E-posta adresi boş olamaz.';
    }
    return null;
  }

  String? passwordLoginValidator(String value) {
    print('e-mail value = $value');
    if (value == null || value.isEmpty) {
      return 'Şifre boş olamaz.';
    }
    return null;
  }

  Future<User?> btn_ClickRegister(Function showErrorDialog) async {
    try {
      final user = await createUserWithEmailAndPasswordData();

      await signInWithEmailAndPasswordData();

      return user;

    } on FirebaseAuthException catch (e) {
      print(
        'Kayıt formu içerisinde hata yakalandı, ${e.message}',
      );
      print("e.code = ${e.code}");
      if (e.code == 'email-already-in-use') {
        print('email zaten kullanılıyor.');
        showErrorDialog('Email zaten kullanılıyor.');

      } else if (e.code == 'invalid-email') {
        print('geçersiz email.');
        showErrorDialog('Geçersiz email');
      } else if (e.code == 'invalid-credential') {
        print('kullanıcı adı veya şifre hatalı..');
        showErrorDialog('Kullanıcı adı veya şifre hatalı');
      } else if (e.code == 'too-many-requests') {
        print(
            'Çok fazla hatalı giriş yaptınız. Lütfen daha sonra tekrar deneyiniz...');
        showErrorDialog('Çok fazla hatalı giriş yaptınız.');
      }
      else if (e.code == 'network-request-failed') {
        print('internet bağlantınızı kontrol ediniz..');
        showErrorDialog('internet bağlantınızı kontrol ediniz.');
      }
      rethrow;
    }
  }

  Future<void> btn_ClickLogin(Function showErrorDialog) async {
    try {
      await signInWithEmailAndPasswordData();
    } on FirebaseAuthException catch (e) {
      print(
        'Kayıt formu içerisinde hata yakalandı, ${e.message}',
      );
      print("e.code = ${e.code}");
      if (e.code == 'email-already-in-use') {
        print('email zaten kullanılıyor.');
        showErrorDialog('Email zaten kullanılıyor.');

      } else if (e.code == 'invalid-email') {
        print('geçersiz email.');
        showErrorDialog('Geçersiz email');
      } else if (e.code == 'invalid-credential') {
        print('kullanıcı adı veya şifre hatalı..');
        showErrorDialog('Kullanıcı adı veya şifre hatalı');
      } else if (e.code == 'too-many-requests') {
        print(
            'Çok fazla hatalı giriş yaptınız. Lütfen daha sonra tekrar deneyiniz...');
        showErrorDialog('Çok fazla hatalı giriş yaptınız.');
      }
      else if (e.code == 'network-request-failed') {
        print('internet bağlantınızı kontrol ediniz..');
        showErrorDialog('internet bağlantınızı kontrol ediniz.');
      }
      rethrow;
    }
  }

  User? getUser(User? user) {
    return user;
  }

  String? passwordValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş olamaz';
    }
    // Şifre doğrulama regex'i
    RegExp passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d\W]{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return 'Geçersiz şifre.';
    }
    return null; // Geçerli
  }

  String? passwordConfirmValidator(
      String value,
      TextEditingController passwordController,
      TextEditingController passwordConfirmController) {
    if (value == null || value.isEmpty) {
      return 'Şifre onay kısmı boş olamaz.';
    }
    if (passwordController.text != passwordConfirmController.text) {
      return 'Şifreler aynı değil';
    } else {
      return null;
    }
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

  void resetTextFields() {
    _textEditingitems.emailController.clear();
    _textEditingitems.registerEmailController.clear();
    _textEditingitems.passwordController.clear();
    _textEditingitems.registerPasswordController.clear();
    _textEditingitems.registerPasswordConfirmController.clear();
  }
}

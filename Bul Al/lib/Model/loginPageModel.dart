import 'package:flutter/material.dart';

class LoginPageInputBoxModel {
  final String yazi;
  final bool isPassword;
  final double boyut;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  LoginPageInputBoxModel(
      {required this.yazi,
      required this.isPassword,
      required this.boyut,
      required this.controller,
      this.validator});
}

class TextEditingItems {
  final TextEditingController _emailController = TextEditingController();

  TextEditingController get emailController => _emailController;

  final TextEditingController _registerEmailController =
      TextEditingController();

  TextEditingController get registerEmailController => _registerEmailController;

  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get passwordController => _passwordController;

  final TextEditingController _registerPasswordController =
      TextEditingController();

  TextEditingController get registerPasswordController =>
      _registerPasswordController;

  final TextEditingController _registerPasswordConfirmController =
      TextEditingController();

  TextEditingController get registerPasswordConfirmController =>
      _registerPasswordConfirmController;

  final TextEditingController _nameController = TextEditingController();

  TextEditingController get nameController => _nameController;

  final TextEditingController _surnameController =
      TextEditingController();

  TextEditingController get surnameController =>
      _surnameController;
}

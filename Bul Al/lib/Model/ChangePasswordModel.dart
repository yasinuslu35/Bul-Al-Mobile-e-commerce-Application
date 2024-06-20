import 'package:flutter/material.dart';

class ChangePasswordModel {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  ChangePasswordModel({required this.text, required this.controller, this.validator});
}

class TextEditingItems {
  final TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController get oldPasswordController => _oldPasswordController;


  final TextEditingController _newPasswordController = TextEditingController();
  TextEditingController get newPasswordController => _newPasswordController;


  final TextEditingController _newPasswordConfirmController = TextEditingController();
  TextEditingController get newPasswordConfirmController => _newPasswordConfirmController;
}
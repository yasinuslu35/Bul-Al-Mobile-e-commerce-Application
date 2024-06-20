import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../services/auth.dart';

class UserInformationModel {
  final String yazi;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  UserInformationModel( {required this.yazi, required this.controller, this.validator,});
}

class TextEditingItems {
  Auth _auth = Auth();

  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;

  // Inşa metodu
  TextEditingItems() {
    _nameController = TextEditingController(text: _auth.getName());
    _surnameController = TextEditingController(text: _auth.getSurname());
    _phoneController = TextEditingController(text: ''); // Geçici olarak boş bir değer atıyoruz
    // phoneNumber'ı al ve _phoneController'ı güncelle
    _updatePhoneNumber();
  }

  Future<void> _updatePhoneNumber() async {
    String? phoneNumber = await _auth.getPhoneNumber();
    _phoneController.text = phoneNumber!;
  }

  TextEditingController get nameController => _nameController;
  TextEditingController get surnameController => _surnameController;
  TextEditingController get phoneController => _phoneController;
}



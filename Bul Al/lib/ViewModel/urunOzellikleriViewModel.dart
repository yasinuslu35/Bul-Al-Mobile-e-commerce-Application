import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/auth.dart';

class UrunOzellikleriViewModel extends ChangeNotifier {
  Auth auth = Auth();

  bool _isPressed = false;
  bool _isPressedYorumlar = false;
  int _siparisAdedi = 1;

  int _toplamsiparis = 0;

  int getToplamSiparis() {
    return _toplamsiparis;
  }

  void toplamSiparisArttir() {
    _toplamsiparis++;
  }

  void toplamSiparisAzalt() {
    _toplamsiparis--;
  }

  Future<int> getSepettekiUrun() async {
    await getUrunAdedi();
    return _toplamsiparis;
  }

  bool getisPressed() {
    return _isPressed;
  }

  bool getisPressedYorumlar() {
    return _isPressedYorumlar;
  }

  int getSiparisAdedi() {
    return _siparisAdedi;
  }

  void siparisArttir() {
    _siparisAdedi++;
  }

  void siparisAzalt() {
    if (_siparisAdedi > 1) {
      _siparisAdedi--;
    } else {
      print("hata");
    }
  }

  void btnUrun() {
    _isPressed = false;
    _isPressedYorumlar = true;
  }

  void btnYorumlar() {
    _isPressed = true;
    _isPressedYorumlar = false;
  }

  String convertTurkishChars(String input) {
    final Map<String, String> turkishToEnglish = {
      'Ç': 'C',
      'ç': 'c',
      'Ğ': 'G',
      'ğ': 'g',
      'İ': 'I',
      'ı': 'i',
      'Ö': 'O',
      'ö': 'o',
      'Ş': 'S',
      'ş': 's',
      'Ü': 'U',
      'ü': 'u'
    };
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      String char = input[i];
      buffer.write(turkishToEnglish[char] ?? char);
    }

    return buffer.toString();
  }

  Future<void> deleteAllDocuments() async {
    CollectionReference collection = FirebaseFirestore.instance
        .collection('sepet')
        .doc(auth.getEmail())
        .collection('ürünler');

    QuerySnapshot querySnapshot = await collection.get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteDocument(String documentId) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    String tdocid = convertTurkishChars(documentId);
    try {
      await _db
          .collection('sepet')
          .doc(auth.getEmail())
          .collection('ürünler')
          .doc(tdocid)
          .delete();
      print("Döküman başarıyla silindi.");
    } catch (e) {
      print("Döküman silinirken hata oluştu: $e");
    }
  }

  Future<void> setUrunAdedi(
      int sepettekiUrun, String urunismi, double price, String photoUrl) async {
    String convertedText = convertTurkishChars(urunismi);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('sepet')
            .doc(auth.getEmail())
            .collection('ürünler')
            .doc(convertedText)
            .set({
          'sepettekiurunadedi': sepettekiUrun,
          'ürünadi': urunismi,
          'Price': price * sepettekiUrun,
          'photoUrl': photoUrl,
        });
        print('Kullanıcı verileri başarıyla güncellendi.');
      } catch (e) {
        print('Kullanıcı verilerini güncellerken bir hata oluştu: $e');
      }
    } else {
      print('Oturum açık bir kullanıcı bulunamadı.');
    }
  }

  Future<void> hemenAlBtn(
      int sepettekiUrun, String urunismi, double price, String photoUrl) async {
    User? user = FirebaseAuth.instance.currentUser;

    //String docid = DateTime.now().millisecondsSinceEpoch.toString();
    DateTime now = DateTime.now();
    DateTime turkiyeSaati = now.add(Duration(hours: 3));
    String formattedDate =
        DateFormat('yyyy-MM-dd_HH:mm:ss').format(turkiyeSaati);
    Timestamp timestamp = Timestamp.fromDate(now);
    if (user != null) {
      try {
        DateTime now = DateTime.now();
        DateTime turkiyeSaati = now.add(Duration(hours: 3));
        String formattedDate =
            DateFormat('yyyy-MM-dd_HH:mm:ss').format(turkiyeSaati);
        Timestamp timestamp = Timestamp.fromDate(now);
        await FirebaseFirestore.instance
            .collection('siparisler')
            .doc(auth.getEmail())
            .collection('ürünler')
            .doc(formattedDate)
            .set({
          'siparisSayisi': sepettekiUrun,
          'ürünadi': urunismi,
          'Fiyat': price * sepettekiUrun,
          'Siparis Saati': timestamp,
          'photoUrl': photoUrl,
        });
        print('Kullanıcı verileri başarıyla güncellendi.');
      } catch (e) {
        print('Kullanıcı verilerini güncellerken bir hata oluştu: $e');
      }
    } else {
      print('Oturum açık bir kullanıcı bulunamadı.');
    }
  }

  Future<void> siparisiTamamla(List<int> sepettekiUrun, List<String> urunismi,
      List<double> price, int elemanadedi, List<String> photoUrl) async {
    User? user = FirebaseAuth.instance.currentUser;

    DateTime now = DateTime.now();
    DateTime turkiyeSaati = now.add(Duration(hours: 3));
    String formattedDate =
        DateFormat('yyyy-MM-dd_HH:mm:ss').format(turkiyeSaati);
    Timestamp timestamp = Timestamp.fromDate(now);
    if (user != null) {
      try {
        for (int i = 0; i < elemanadedi; i++) {
          DateTime now = DateTime.now();
          DateTime turkiyeSaati = now.add(Duration(hours: 3));
          String formattedDate =
              DateFormat('yyyy-MM-dd_HH:mm:ss').format(turkiyeSaati);
          Timestamp timestamp = Timestamp.fromDate(now);
          await FirebaseFirestore.instance
              .collection('siparisler')
              .doc(auth.getEmail())
              .collection('ürünler')
              .doc(formattedDate + "$i")
              .set({
            'siparisSayisi': sepettekiUrun[i],
            'ürünadi': urunismi[i],
            'Fiyat': price[i],
            'Siparis Saati': timestamp,
            'photoUrl': photoUrl[i],
          });
        }
        print('Kullanıcı verileri başarıyla güncellendi.');
      } catch (e) {
        print('Kullanıcı verilerini güncellerken bir hata oluştu: $e');
      }
    } else {
      print('Oturum açık bir kullanıcı bulunamadı.');
    }
  }

  Future<int?> getUrunAdedi() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Firestore koleksiyonunu ve belirli bir belgeyi referans al
      QuerySnapshot snapshot = await firestore
          .collection('sepet')
          .doc(auth.getEmail())
          .collection('ürünler')
          .get();

      List<DocumentSnapshot> documentSnapshot = snapshot.docs;

      // Belge varsa veriyi al
      if (documentSnapshot.isNotEmpty) {
        int? urunlerinAdetToplami = 0;
        // Belgeden veriyi alma
        for (int i = 0; i < documentSnapshot.length; i++) {
          Map<String, dynamic> data =
              documentSnapshot[i].data() as Map<String, dynamic>;

          urunlerinAdetToplami =
              urunlerinAdetToplami! + data['sepettekiurunadedi'] as int?;
        }

        _toplamsiparis = (urunlerinAdetToplami! as int?)!;

        print('_toplamsiparis = ${_toplamsiparis}');
        return urunlerinAdetToplami;
        // vb.
      } else {
        print('Belge bulunamadı.');
        _toplamsiparis = 0;
        return 0;
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getSepetBilgileri() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Firestore koleksiyonunu ve belirli bir belgeyi referans al
      QuerySnapshot snapshot = await firestore
          .collection('sepet')
          .doc(auth.getEmail())
          .collection('ürünler')
          .get();

      List<DocumentSnapshot> documentSnapshot = snapshot.docs;

      // Belge varsa veriyi al
      if (documentSnapshot.isNotEmpty) {
        List<Map<String, dynamic>> sepettekiurunListesi = [];

        // Belgeden veriyi alma
        for (int i = 0; i < documentSnapshot.length; i++) {
          Map<String, dynamic> data =
              documentSnapshot[i].data() as Map<String, dynamic>;
          sepettekiurunListesi.add(data);
        }
        print("sepettekiurunlistesi = $sepettekiurunListesi");

        return sepettekiurunListesi;
        // vb.
      } else {
        print('Belge bulunamadı.');
        return [];
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return [];
    }
  }
}

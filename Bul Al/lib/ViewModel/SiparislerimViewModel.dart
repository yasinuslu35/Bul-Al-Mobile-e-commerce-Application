import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../services/auth.dart';

class SiparislerimViewModel extends ChangeNotifier {
  Auth _auth = Auth();

  int _toplamsiparis = 0;

  int getToplamSiparis() {
    return _toplamsiparis;
  }

  Future<int> getSepettekiUrun() async {
    await getUrunAdedi();
    return _toplamsiparis;
  }

  Future<int?> getUrunAdedi() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Firestore koleksiyonunu ve belirli bir belgeyi referans al
      QuerySnapshot snapshot = await firestore
          .collection('siparisler')
          .doc(_auth.getEmail())
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
          .collection('siparisler')
          .doc(_auth.getEmail())
          .collection('ürünler')
          .get();

      List<DocumentSnapshot> documentSnapshot = snapshot.docs;

      // Belge varsa veriyi al
      if (documentSnapshot.isNotEmpty) {
        List<Map<String, dynamic>> siparislerListesi = [];

        print("döküman sayısı = ${documentSnapshot.length}");
        // Belgeden veriyi alma
        for (int i = 0; i < documentSnapshot.length; i++) {
          Map<String, dynamic> data =
              documentSnapshot[i].data() as Map<String, dynamic>;
          siparislerListesi.add(data);
        }

        return siparislerListesi;
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

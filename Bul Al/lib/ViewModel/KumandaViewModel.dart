import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class KumandaViewModel with ChangeNotifier {
  Future<List<String>> getFilesFromStorage() async {
    List<String> fileURLs = [];

    try {
      // Depolama konumunu belirtin (örneğin, 'images' klasörü)
      final ListResult result = await FirebaseStorage.instance
          .ref()
          .child("photos/kumanda/")
          .listAll();
      for (final Reference ref in result.items) {
        // Dosya URL'lerini alın ve listeye ekleyin
        final url = await ref.getDownloadURL();

        fileURLs.add(url);
      }
      //await setUrunAdedi();
    } catch (e) {
      print('Dosyaları alırken hata oluştu: $e');
    }
    //await setUrunAdedi(fileURLs);
    return fileURLs;
  }
}

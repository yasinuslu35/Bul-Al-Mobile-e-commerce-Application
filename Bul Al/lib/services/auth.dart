import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  final _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }



  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  String? getEmail() {
    return _firebaseAuth.currentUser?.email;
  }

  String? NameSurname() {
    return _firebaseAuth.currentUser?.displayName;
  }

  List<String?> getNameSurname() {
    String? nameSurname = _firebaseAuth.currentUser?.displayName;
    nameSurname ??= 'gecici isim';
    List<String?> nameSurnameDizisi = nameSurname!.split(' ');
    return nameSurnameDizisi;
  }

  String? getName() {
    return getNameSurname().first;
  }

  String? getSurname() {
    return getNameSurname().last;
  }


  Future<List<DocumentSnapshot>> getDocuments(String collectionPath) async {
    try {
      // Firestore koleksiyonundan belge almak için referans oluşturun
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionPath) // Firestore koleksiyon adı
          .get();

      // Firestore'dan belgeyi al ve geri döndür
      return querySnapshot.docs;
    } catch (e) {
      // Hata durumunda null döndürülebilir veya hata yönetimi yapılabilir
      print('Hata: $e');
      return Future.error('Veri alınamadı');
    }
  }



  Future<String?> getPhoneNumber() async {
    // Firestore referansını al
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Firestore koleksiyonunu ve belirli bir belgeyi referans al
      DocumentSnapshot documentSnapshot =
          await firestore.collection('users').doc(getEmail()).get();

      // Belge varsa veriyi al
      if (documentSnapshot.exists) {
        // Belgeden veriyi alma
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        // Veriyi kullan
        print('Name: ${data['PhoneNumber']}');

        int phoneNumber = data['PhoneNumber'];
        return phoneNumber.toString();
        // vb.
      } else {
        print('Belge bulunamadı.');
        return '5';
      }
    } catch (e) {
      print('Hata oluştu: $e');
      return '5';
    }
  }

  Stream<User?> authStatus() {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> updateUserData(
      String email, String newName, String newSurname) async {
    String? displayName = '$newName $newSurname';
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(displayName);
        await FirebaseFirestore.instance.collection('users').doc(email).update({
          'email': email,
          'name': newName,
          'surname': newSurname,
        });
        print('Kullanıcı verileri başarıyla güncellendi.');
      } catch (e) {
        print('Kullanıcı verilerini güncellerken bir hata oluştu: $e');
      }
    } else {
      print('Oturum açık bir kullanıcı bulunamadı.');
    }
  }

  Future<User?> createUserWithEmailAndPasswordData(
      String email, String password) async {
    UserCredential? userCredentials;
    try {
      userCredentials = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredentials?.user;
    } on FirebaseAuthException catch (e) {
      print(
        'Kayıt formu içerisinde hata yakalandı, ${e.message}',
      );
      if (e.code == 'email-already-in-use') {
        print('email zaten kullanılıyor.');
      } else if (e.code == 'invalid-email') {
        print('geçersiz email.');
      }
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPasswordData(
      String email, String password) async {
    final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredentials.user;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.delete();
        print('Kullanıcı başarıyla silindi.');
      } catch (e) {
        print('Kullanıcıyı silerken bir hata oluştu: $e');
      }
    } else {
      print('Oturum açık bir kullanıcı bulunamadı.');
    }
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } else {
      return null;
    }
  }
}

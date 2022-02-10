import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageMethod {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file, {
    required bool isPost,
  }) async {
    try {
      log(_firebaseAuth.currentUser!.uid, name: "Storage");
      Reference ref =
          _firebaseStorage.ref(childName).child(_firebaseAuth.currentUser!.uid);
      final UploadTask uploadTask = ref.putData(file);
      final snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      log(e.message!, name: "Storage");
      return "";
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Sign In
  Future<UserCredential> signInUser(email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _fireStore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
        SetOptions(merge: true),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign Up
  Future<UserCredential> signUpUser(email, password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code);
    }
  }

  ///LOGOUT
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

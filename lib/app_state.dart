import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import "package:firebase_core/firebase_core.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  //this chacks if the user is loggin in or not

  //we create our init fun
  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }

  // Future<DocumentReference> addMessageToGuestBook(String message) {
  //   if (!_loggedIn) {
  //     throw Exception('Must be logged in');
  //   }

  //   return FirebaseFirestore.instance
  //       .collection('guestbook')
  //       .add(<String, dynamic>{
  //     'text': message,
  //     'timestamp': DateTime.now().toString(),
  //     'name': FirebaseAuth.instance.currentUser!.displayName,
  //     'userId': FirebaseAuth.instance.currentUser!.uid,
  //   });
  // }
  Future<DocumentReference> addMessageToGuestBook(String message) async {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    try {
      print('Adding message: $message');
      return await FirebaseFirestore.instance
          .collection('guestbook')
          .add(<String, dynamic>{
        'text': message,
        'timestamp': DateTime.now().toString(),
        'name': FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',
        'userId': FirebaseAuth.instance.currentUser?.uid,
      });
    } catch (e) {
      print('Failed to add message: $e');
      rethrow;
    }
  }
}

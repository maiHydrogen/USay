import 'dart:developer';

import 'package:usay/models/chatuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/toast.dart';

class APIs {
  // this one is for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;
  // for accessing cloud firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //for returning current user
  static User get user => auth.currentUser!;
  // for checking if user exists or not
  static Future<bool> userExists() async {
    return (await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get())
        .exists;
  }
  //for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        createdAt: time,
        email: user.email.toString(),
        isOnline: false,
        lastActive: time,
        id: user.uid,
        Image: user.photoURL.toString(),
        pushToken: '',
        Name: user.displayName.toString(),
        About: "Maxuda");
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
  // for storing self information
  static ChatUser me = ChatUser(
    id: user.uid,
    Name: user.displayName.toString(),
    email: user.email.toString(),
    About: "Hey, I'm using usay!",
    Image: user.photoURL.toString(),
    createdAt: '',
    isOnline: false,
    lastActive: '',
    pushToken: '',);

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('users')
        .where('id',
        whereIn: userIds.isEmpty
            ? ['']
            : userIds) //because empty list throws an error where('id', isNotEqualTo: user.uid)
        .snapshots();
  }
}


class FirebaseAuthService {

 final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
       showToast(message: 'Invalid email or password.');
      } else {
       showToast(message: 'An error occurred: ${e.code}');
      }

    }
    return null;

  }

}




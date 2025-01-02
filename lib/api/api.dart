import 'dart:developer';
import 'package:usay/models/chatuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usay/models/messages.dart';
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

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for storing self information
  static ChatUser me = ChatUser(
    id: user.uid,
    Name: user.displayName.toString(),
    email: user.email.toString(),
    About: '',
    Image: user.photoURL.toString(),
    createdAt: '',
    isOnline: false,
    lastActive: '',
    pushToken: '',
  );

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
            isNotEqualTo: user
                .uid) //because empty list throws an error where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for updating user info
  static Future<void> updateUserProfile() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'Name': me.Name, 'About': me.About, 'Image': me.Image});
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('Chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: Type.text,
      fromId: user.uid,
      sent: time,
    );
    final ref = firestore
        .collection('Chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  // read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('Chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('Chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
  //update message
  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('Chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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

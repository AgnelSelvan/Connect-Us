import 'package:connect_us/constants/strings.dart';
import 'package:connect_us/models/dummy_message.dart';
import 'package:connect_us/models/user.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationMethods {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  AuthMethods _authMethods = AuthMethods();
  static final Firestore _firestore = Firestore.instance;
  // final CollectionReference pushToken = _firestore.collection(PUSH_TOKEN_COLLECTION);
  final List<DummyMessage> dummyMessages = [];

  Future<String> getToken() async {
    String token = await firebaseMessaging.getToken();
    print(token);
    return token;
  }

  Future<void> configureFirebaseListener() async {
    firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      final notification = message['notification'];
      dummyMessages.add(DummyMessage(
          title: notification['title'], message: notification['body']));
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      final notification = message['notification'];
      dummyMessages.add(DummyMessage(
          title: notification['title'], message: notification['body']));
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    });
  }

  Future<void> addDeviceTokenToDb() async {
    String token = await getToken();
    QuerySnapshot doc =
        await _firestore.collection('device_tokens').getDocuments();
    FirebaseUser user = await _authMethods.getCurrentUser();
    bool isExists = false;
    for (var i = 0; i < doc.documents.length; i++) {
      if (doc.documents[i]['uid'].toString() == user.uid) {
        isExists = true;
      } else {
        isExists = false;
      }
    }
    if (!isExists) {
      await _firestore
          .collection('device_tokens')
          .add({'device_token': token, 'uid': user.uid});
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:connect_us/constants/strings.dart';
import 'package:connect_us/models/contact.dart';
import 'package:connect_us/models/message.dart';
import 'package:connect_us/models/user.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;

  final CollectionReference _messageCollection =
      _firestore.collection(MESSAGES_COLLECTION);

  final CollectionReference _userCollection =
      _firestore.collection(USERS_COLLECTION);

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();

    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(CONTACTS_COLLECTION)
          .document(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToSenderContacts(senderId, receiverId, currentTime);
    await addToReceiverContacts(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    // DocumentSnapshot senderSnapshot =
    //     await getContactsDocument(of: senderId, forContact: receiverId).get();

    // if (!senderSnapshot.exists) {
    //   //does not exists
    //   Contact receiverContact = Contact(
    //     uid: receiverId,
    //     addedOn: currentTime,
    //   );

    //   var receiverMap = receiverContact.toMap(receiverContact);

    //   await getContactsDocument(of: senderId, forContact: receiverId)
    //       .setData(receiverMap);
    // }
    Contact receiverContact = Contact(
      uid: receiverId,
      addedOn: currentTime,
    );
    var receiverMap = receiverContact.toMap(receiverContact);
    await getContactsDocument(of: senderId, forContact: receiverId)
        .setData(receiverMap);
  }

  Future<void> addToReceiverContacts(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    // DocumentSnapshot receiverSnapshot =
    //     await getContactsDocument(of: receiverId, forContact: senderId).get();

    // if (!receiverSnapshot.exists) {
    //   //does not exists
    //   Contact senderContact = Contact(
    //     uid: senderId,
    //     addedOn: currentTime,
    //   );

    //   var senderMap = senderContact.toMap(senderContact);

    //   await getContactsDocument(of: receiverId, forContact: senderId)
    //       .setData(senderMap);
    // }
    Contact senderContact = Contact(
      uid: senderId,
      addedOn: currentTime,
    );

    var senderMap = senderContact.toMap(senderContact);

    await getContactsDocument(of: receiverId, forContact: senderId)
        .setData(senderMap);
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message message;

    message = Message.imageMessage(
        message: "IMAGE",
        receiverId: receiverId,
        senderId: senderId,
        photoUrl: url,
        timestamp: Timestamp.now(),
        type: 'image');

    // create imagemap
    var map = message.toImageMap();

    // var map = Map<String, dynamic>();
    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  Future<bool> deleteChat(String senderUserId, String receiverUserId) async {
    try {
      _messageCollection
          .document(senderUserId)
          .collection(receiverUserId)
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(CONTACTS_COLLECTION)
      .orderBy('added_on', descending: true)
      .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();
}

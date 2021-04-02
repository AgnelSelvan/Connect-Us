import 'dart:math';

import 'package:connect_us/models/call_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_us/constants/strings.dart';
import 'package:connect_us/models/call.dart';

class CallMethods {
  final CollectionReference callCollection =
      Firestore.instance.collection(CALL_COLLECTION);

  final CollectionReference callHistoryCollection =
      Firestore.instance.collection(CALL_HISTORY_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.document(call.callerId).setData(hasDialledMap);
      await callCollection.document(call.receiverId).setData(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call}) async {
    try {
      await callCollection.document(call.callerId).delete();
      await callCollection.document(call.receiverId).delete();
      await addToVideoCallHistory(call: call);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> addToVideoCallHistory({Call call}) async {
    Timestamp currentTime = Timestamp.now();

    CallHistory callHistory = CallHistory(
      callerId: call.callerId,
      receiverId: call.receiverId,
      timestamp: currentTime,
      hasAttended: true,
      hasDialled: true,
    );
    Map<String, dynamic> hasDialledMap = callHistory.toMap(callHistory);

    CallHistory callHist = CallHistory(
      callerId: call.callerId,
      receiverId: call.receiverId,
      timestamp: currentTime,
      hasAttended: true,
      hasDialled: false,
    );
    Map<String, dynamic> hasNotDialledMap = callHistory.toMap(callHist);

    await callCollection
        .document('calls_history')
        .collection(call.callerId)
        .add(hasDialledMap);
    await callCollection
        .document('calls_history')
        .collection(call.receiverId)
        .add(hasNotDialledMap);
  }

  Stream<QuerySnapshot> fetchCallHistory({String userId}) {
    // print(userId);
    return Firestore.instance
        .collection('call')
        .document('calls_history')
        .collection(userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

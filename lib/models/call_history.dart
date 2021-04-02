import 'package:cloud_firestore/cloud_firestore.dart';

class CallHistory {
  String callerId;
  String receiverId;
  Timestamp timestamp;
  bool hasDialled;
  bool hasAttended;

  CallHistory({
    this.callerId,
    this.receiverId,
    this.hasDialled,
    this.hasAttended,
    this.timestamp
  });

  // to map
  Map<String, dynamic> toMap(CallHistory call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["receiver_id"] = call.receiverId;
    callMap["has_dialled"] = call.hasDialled;
    callMap["has_attended"] = call.hasAttended;
    callMap["timestamp"] = call.timestamp;
    return callMap;
  }

  CallHistory.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.receiverId = callMap["receiver_id"];
    this.hasDialled = callMap["has_dialled"];
    this.hasAttended = callMap["has_attended"];
    this.timestamp = callMap["timestamp"];
  }
}

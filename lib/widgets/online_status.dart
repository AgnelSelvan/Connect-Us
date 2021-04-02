import 'package:connect_us/models/user.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final AuthMethods _authMethods = AuthMethods();

class OnlineStatus extends StatelessWidget {
  User receiver;
  OnlineStatus({@required this.receiver});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: receiver.uid,
        ),
        builder: (context, snapshot) {
          User user;

          if (snapshot.hasData && snapshot.data.data != null) {
            user = User.fromMap(snapshot.data.data);
          }

          return Container(
            child: Text(
              user.state == 1 ? "Online" : "Offline",
              style: TextStyle(
                  color: user.state == 1 ? Variables.greenColor : Colors.grey,
                  fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}

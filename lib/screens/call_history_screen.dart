import 'package:connect_us/models/call_history.dart';
import 'package:connect_us/models/contact.dart';
import 'package:connect_us/models/user.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/resources/call_methods.dart';
import 'package:connect_us/screens/chatscreens/widgets/cached_image.dart';
import 'package:connect_us/screens/home_screen.dart';
import 'package:connect_us/screens/pageviews/widgets/quiet_box.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'package:connect_us/widgets/custom_loading.dart';
import 'package:connect_us/widgets/custom_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

CallMethods _callMethods = CallMethods();

class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CallHistoryListContainer(),
    );
  }
}

class CallHistoryListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userprovider = Provider.of<UserProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: _callMethods.fetchCallHistory(userId: userprovider.getUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var callHistoryList = snapshot.data.documents;
            if (callHistoryList.isEmpty) {
              return QuietCallBox();
            }
            return ListView.builder(
                itemCount: callHistoryList.length,
                itemBuilder: (context, index) {
                  CallHistory callHistory =
                      CallHistory.fromMap(callHistoryList[index].data);
                  return CallHistoryView(
                    callHistory: callHistory,
                  );
                });
          }
          return CustomCircularLoading();
        });
    // return Text("Call");
  }
}

AuthMethods _authMethods = AuthMethods();

class CallHistoryView extends StatelessWidget {
  final CallHistory callHistory;
  CallHistoryView({this.callHistory});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return FutureBuilder(
      future: _authMethods.getUserDetailsById(
          callHistory.receiverId == userProvider.getUser.uid
              ? callHistory.callerId
              : callHistory.receiverId),
      builder: (context, snapshot) {
        User user = snapshot.data;
        if (snapshot.hasData) {
          return CallHistoryLayout(
            user: user,
            callHistory: callHistory,
          );
        }
        return CustomCircularLoading();
      },
    );
  }
}

class CallHistoryLayout extends StatelessWidget {
  final User user;
  final CallHistory callHistory;
  CallHistoryLayout({@required this.user, @required this.callHistory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          CustomTile(
              leading: CachedImage(
                user.profilePhoto,
                width: 50,
              ),
              title: Text(
                user.name,
                style: TextStyle(fontSize: 16, letterSpacing: 1.2),
              ),
              subtitle: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  children: <Widget>[
                    callHistory.hasDialled
                        ? Icon(Icons.call_made, size: 16, color: Colors.green)
                        : callHistory.hasAttended
                            ? Icon(Icons.call_received,
                                size: 16, color: Colors.green)
                            : Icon(Icons.call_received,
                                size: 16, color: Colors.red),
                    SizedBox(width: 2),
                    callHistory.hasAttended
                        ? Icon(
                            Icons.video_call,
                            size: 16,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.missed_video_call,
                            size: 16,
                            color: Colors.red,
                          ),
                    SizedBox(width: 10),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(callHistory.timestamp.toDate()),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 10),
                          Text(
                            DateFormat('hh:mm')
                                .format(callHistory.timestamp.toDate()),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Divider(),
          )
        ],
      ),
    );
  }
}

class QuietCallBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "This is where all the call history are listed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 25),
              Text(
                "start calling the friends in contact list.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: Variables.greenColor,
                child: Text(
                  "START YOUR CALLING",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

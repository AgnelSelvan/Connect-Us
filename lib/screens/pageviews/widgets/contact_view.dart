import 'package:connect_us/widgets/custom_loading.dart';
import 'package:connect_us/widgets/photo_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_us/models/contact.dart';
import 'package:connect_us/models/user.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/resources/chat_methods.dart';
import 'package:connect_us/screens/chatscreens/chat_screen.dart';
import 'package:connect_us/screens/chatscreens/widgets/cached_image.dart';
import 'package:connect_us/screens/pageviews/widgets/online_dot_indicator.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'package:connect_us/widgets/custom_tile.dart';

import 'last_message_container.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }
        return Center(
          child: CustomCircularLoading(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({
    @required this.contact,
  });

  popWindow(BuildContext context, String senderUserId, String receiverUserId) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Chat Option"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Delete chat"),
                onPressed: () {
                  _chatMethods.deleteChat(senderUserId, receiverUserId);
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Successfull"),
                          content: Expanded(
                            child: Text(
                              "Message deleted successfully!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                  // Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                child: Text("Archieve chat"),
                // onPressed:  () => handleChooseFromGallery(),
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    final AuthMethods _authMethods = AuthMethods();
    return Column(
      children: <Widget>[
        GestureDetector(
          onLongPress: () {
            popWindow(
                context, userProvider.getUser.uid.toString(), contact.uid);
          },
          child: CustomTile(
            mini: false,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    receiver: contact,
                  ),
                )),
            title: Text(
              (contact != null ? contact.name : null) != null
                  ? contact.name
                  : "..",
              style: TextStyle(
                  color: Variables.blackColor,
                  fontSize: 16,
                  letterSpacing: 1.2),
            ),
            subtitle: LastMessageContainer(
              stream: _chatMethods.fetchLastMessageBetween(
                senderId: userProvider.getUser.uid,
                receiverId: contact.uid,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PhotoViewer(imgUrl: contact.profilePhoto)));
              },
              child: Container(
                constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
                child: Stack(
                  children: <Widget>[
                    CachedImage(
                      contact.profilePhoto,
                      radius: 80,
                      isRound: true,
                    ),
                    OnlineDotIndicator(
                      uid: contact.uid,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Divider(),
        )
      ],
    );
  }
}

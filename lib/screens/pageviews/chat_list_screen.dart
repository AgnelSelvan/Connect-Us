import 'package:connect_us/main.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/screens/chatscreens/widgets/cached_image.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'package:connect_us/widgets/common_app_bar.dart';
import 'package:connect_us/widgets/custom_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_us/models/contact.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/resources/chat_methods.dart';
import 'package:connect_us/screens/callscreens/pickup/pickup_layout.dart';
import 'package:connect_us/screens/pageviews/widgets/contact_view.dart';
import 'package:connect_us/screens/pageviews/widgets/quiet_box.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Container(
        // floatingActionButton: NewChatButton(),
        child: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;
              print(docList.length);
              if (docList.isEmpty) {
                return QuietBox();
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CustomCircularLoading());
          }),
    );
  }
}

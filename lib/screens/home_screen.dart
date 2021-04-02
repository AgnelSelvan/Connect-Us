import 'package:connect_us/main.dart';
import 'package:connect_us/models/user.dart';
import 'package:connect_us/resources/notification_methods.dart';
import 'package:connect_us/screens/call_history_screen.dart';
import 'package:connect_us/screens/chatscreens/widgets/cached_image.dart';
import 'package:connect_us/screens/contact_screen.dart';
import 'package:connect_us/screens/pageviews/widgets/user_circle.dart';
import 'package:connect_us/screens/search_screen.dart';
import 'package:connect_us/widgets/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:connect_us/enum/user_state.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/screens/callscreens/pickup/pickup_layout.dart';
import 'package:connect_us/screens/pageviews/chat_list_screen.dart';
import 'package:connect_us/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;
  final AuthMethods _authMethods = AuthMethods();
  final NotificationMethods _notificationMethods = NotificationMethods();
  UserProvider userProvider;
  // User _user;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );
    });

    _notificationMethods.getToken().then((token) {
      print("Token:$token");
    });

    _notificationMethods.addDeviceTokenToDb();

    _notificationMethods.configureFirebaseListener();
    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    CustomAppBar customAppBar(BuildContext context) {
      UserProvider userProvider = Provider.of<UserProvider>(context);

      showAlertDialog(BuildContext context) {
        Widget noButton = FlatButton(
          child: Text(
            "No",
            style: TextStyle(color: Variables.greenColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        Widget yesButton = FlatButton(
          child: Text(
            "Yes",
            style: TextStyle(color: Variables.greenColor),
          ),
          onPressed: () async {
            await _authMethods.signOut();
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyApp()));
          },
        );

        AlertDialog alert = AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure want to logout?"),
          actions: [
            noButton,
            yesButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      editProfileModalSheet(context) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: <Widget>[
                        FlatButton(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                  color: Variables.greenColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: CachedImage(
                            userProvider.getUser.profilePhoto,
                            isRound: true,
                            radius: 180,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              width: 70,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Variables.greenColor,
                              ),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SimpleDialog(
                                            title: Text("Update Profile Photo"),
                                            children: <Widget>[
                                              SimpleDialogOption(
                                                child:
                                                    Text("Photo with Camera"),
                                                // onPressed: handleTakePhoto,
                                              ),
                                              SimpleDialogOption(
                                                child: Text("Image in gallery"),
                                                // onPressed:  () => handleChooseFromGallery(),
                                              ),
                                              SimpleDialogOption(
                                                child: Text("Cancel"),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                              ),
                                            ],
                                          );
                                        });
                                  })),
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
      }

      return CustomAppBar(
        // leading: GestureDetector(
        //     onTap: () {
        //       editProfileModalSheet(context);
        //     },
        //     child: Container(margin: EdgeInsets.all(7), child: UserCircle())),
        leading: Container(
          margin: EdgeInsets.all(7),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Variables.greenColor,
            backgroundImage: AssetImage('assets/img/logo.png'),
          ),
        ),
        title: Text(
          "CALL  ME",
          style: TextStyle(color: Variables.greenColor, letterSpacing: 1.3),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Variables.greenColor,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          // PopupMenuButton(
          //   itemBuilder: (context) {
          //     var list = List<PopupMenuEntry<Object>>();
          //     list.add(
          //       PopupMenuItem(
          //         child: GestureDetector(
          //           onTap: () {
          //             showAlertDialog(context);
          //           },
          //           child: Container(
          //             width: 100,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: <Widget>[
          //                 Text(
          //                   "Logout",
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //                 Icon(
          //                   Icons.settings_power,
          //                   color: Variables.greenColor,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //     list.add(
          //       PopupMenuDivider(
          //         height: 10,
          //       ),
          //     );
          //     list.add(
          //       PopupMenuItem(
          //         child: GestureDetector(
          //           onTap: () {
          //             editProfileModalSheet(context);
          //           },
          //           child: Container(
          //             width: 100,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceAround,
          //               children: <Widget>[
          //                 Text(
          //                   "Edit account",
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //                 Icon(
          //                   Icons.edit,
          //                   color: Variables.greenColor,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //     return list;
          //   },
          //   icon: Icon(
          //     Icons.more_vert,
          //     size: 20,
          //     color: Variables.greenColor,
          //   ),
          // ),
          IconButton(
            icon: Icon(
              Icons.settings_power,
              color: Variables.greenColor,
            ),
            onPressed: () {
              showAlertDialog(context);
            },
          ),
        ],
      );
    }

    double _labelFontSize = 10;

    return PickupLayout(
      scaffold: Scaffold(
        appBar: customAppBar(context),
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(
              child: CallHistoryScreen(),
            ),
            // Container(
            //     child: ContactScreen()),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1),
            child: CupertinoTabBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat,
                      size: 19,
                      color: (_page == 0)
                          ? Variables.greenColor
                          : Variables.greyColor),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color:
                            (_page == 0) ? Variables.greenColor : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history,
                      size: 19,
                      color: (_page == 1)
                          ? Variables.greenColor
                          : Variables.greyColor),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color:
                            (_page == 1) ? Variables.greenColor : Colors.grey),
                  ),
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.contacts,
                //   size: 19,
                //       color: (_page == 2)
                //           ? Variables.greenColor
                //           : Variables.greyColor),
                //   title: Text(
                //     "Contacts",
                //     style: TextStyle(
                //         fontSize: _labelFontSize,
                //         color: (_page == 2)
                //             ? Variables.greenColor
                //             : Colors.grey),
                //   ),
                // ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}

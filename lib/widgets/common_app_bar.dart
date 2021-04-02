import 'package:connect_us/main.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/screens/chatscreens/widgets/cached_image.dart';
import 'package:connect_us/screens/pageviews/widgets/user_circle.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'package:connect_us/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AuthMethods _authMethods = AuthMethods();

class CommonAppBar extends StatelessWidget {
  final BuildContext context;
  CommonAppBar(this.context);

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
          Navigator.of(context).pop();
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
                                              child: Text("Photo with Camera"),
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
      leading: GestureDetector(
          onTap: () {
            editProfileModalSheet(context);
          },
          child: Container(margin: EdgeInsets.all(7), child: UserCircle())),
      title: null,
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, "/search_screen");
          },
        ),
        IconButton(
          icon: Icon(
            Icons.settings_power,
            color: Colors.white,
          ),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return customAppBar(context);
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'package:connect_us/utils/utilities.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            // child: Text(
            //   Utils.getInitials(userProvider.getUser.name),
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Variables.greenColor,
            //     fontSize: 13,
            //   ),
            // ),
            child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage(userProvider.getUser.profilePhoto)),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Variables.blackColor, width: 0.3),
                  color: Variables.onlineDotColor),
            ),
          )
        ],
      ),
    );
  }
}

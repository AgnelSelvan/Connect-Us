import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connect_us/provider/image_upload_provider.dart';
import 'package:connect_us/provider/user_provider.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:connect_us/screens/home_screen.dart';
import 'package:connect_us/screens/login_screen.dart';
import 'package:connect_us/screens/search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    // _authMethods.signOut();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "Connect Us",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.light),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
              // return Text("Home");
            } else {
              return LoginScreen();
              // return Text("Hii");
            }
          },
        ),
      ),
    );
  }
}

import 'package:connect_us/widgets/custom_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connect_us/resources/auth_methods.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connect_us/utils/universal_variables.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  String _password;
  String _email;
  String _username;
  bool isNew = false;

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: isNew ? signUp() : login(),
          ),
          isLoginPressed
              ? Center(
                  child: CustomCircularLoading(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _buildUsername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Username",
          style: Variables.inputLabelTextStyle,
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            maxLines: 1,
            style: Variables.inputTextStyle,
            keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'yourname'),
            controller: userNameController,
            validator: (value) =>
                value.isEmpty ? 'Username can\'t be empty' : null,
            onSaved: (value) => _username = value.trim(),
          ),
        )
      ],
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email Address",
          style: Variables.inputLabelTextStyle,
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: emailController,
            maxLines: 1,
            style: Variables.inputTextStyle,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'you@gmail.com'),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Email is Required';
              }

              if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                  .hasMatch(value)) {
                return 'Please enter a valid email Address';
              }

              return null;
            },
            onSaved: (String value) {
              _email = value;
            },
          ),
        ),
      ],
    );
  }

  //Password TextField
  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: Variables.inputLabelTextStyle,
        ),
        SizedBox(height: 4),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            style: Variables.inputTextStyle,
            obscureText: true,
            maxLines: 1,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'your password'),
            controller: passwordController,
            validator: (value) {
              if (value.isEmpty)
                return 'Passwords can\'t be empty';
              else if (value.length < 6)
                return 'Passwords should be atleast 6 characters';
              else
                return null;
            },
            onSaved: (value) => _password = value.trim(),
          ),
        )
      ],
    );
  }

  Widget login() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                      fontSize: 28,
                      color: Variables.greenColor,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmail(),
                    _buildPassword(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: Variables.greenColor,
                          textColor: Colors.white,
                          onPressed: () {},
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                              onTap: () {},
                              child: Text(
                                "Forget Password ?",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("OR"),
                    SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: RaisedButton(
                          color: Color(0xffE3E3E3),
                          elevation: 0,
                          onPressed: () {
                            performLogin();
                          },
                          child: Stack(
                            children: <Widget>[
                              Text(
                                "LOGIN USING ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 90),
                                child: Image.asset(
                                  'assets/img/google.png',
                                  width: 13,
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                )),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Not have an account ? ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isNew = true;
                      });
                    },
                    child: Text("Sign Up",
                        style: TextStyle(
                            color: Variables.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget signUp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                      color: Variables.greenColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildUsername(),
                    SizedBox(height: 10),
                    _buildEmail(),
                    SizedBox(height: 10),
                    _buildPassword(),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Variables.greenColor,
                      onPressed: null,
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                )),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an account ? ",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isNew = false;
                      });
                    },
                    child: Text("LOGIN",
                        style: TextStyle(
                            color: Variables.greenColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget loginButton() {
    return FlatButton(
      color: Variables.greenColor,
      padding: EdgeInsets.all(15),
      child: Text(
        "LOGIN",
        style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2),
      ),
      onPressed: () => performLogin(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void performLogin() {
    print("tring to perform login");

    setState(() {
      isLoginPressed = true;
    });

    _authMethods.signIn().then((FirebaseUser user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print("There was an error");
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    _authMethods.authenticateUser(user).then((isNewUser) {
      setState(() {
        isLoginPressed = false;
      });

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}

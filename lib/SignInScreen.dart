import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import './SignUpScreen.dart';
import './HomeScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // show the password or not
  bool _isObscure = true;

  final textEmailAddress = TextEditingController();
  final textPassword = TextEditingController();
  bool _validate = false;
  bool _validate2 = false;

  @override
  void dispose() {
    textEmailAddress.dispose();
    textPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: screenHeight * 0.40,
                width: screenWidth * 0.80,
                padding: EdgeInsets.only(top: 150, left: 10),
                child: Image.asset('assets/images/logo.png'),
              ),
              Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.73,
                  padding: EdgeInsets.only(top: 60.0),
                  child: TextField(
                    style: TextStyle(fontFamily: 'Mont'),
                    controller: textEmailAddress,
                    autocorrect: true,
                    decoration: InputDecoration(
                      helperText: ' ',
                      labelText: 'E-mail Address',
                      border: OutlineInputBorder(),
                      errorText:
                          _validate ? 'E-mail Address is required' : null,
                    ),
                  )),
              Container(
                width: screenWidth * 0.73,
                padding:
                    EdgeInsets.only(top: 10), //padding for the error message
                child: TextField(
                  style: TextStyle(fontFamily: 'Mont'),
                  controller: textPassword,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      helperText: ' ',
                      errorText: _validate2 ? 'Password is required' : null,
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          })),
                ),
              ),
              Container(
                  width: screenWidth * 0.65,
                  height: screenHeight * 0.06,
                  padding: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFFEBA32D)),
                    onPressed: () async {
                      setState(() {
                        textEmailAddress.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                        textPassword.text.isEmpty
                            ? _validate2 = true
                            : _validate2 = false;
                      });

                      //Start of FIREBASE AUTH---
                      if (!_validate && !_validate2) {
                        //if the Email text field and the Password text field is NOT EMPTY
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: textEmailAddress.text,
                                  password: textPassword.text);

                          Future<void> showMyDialog() async {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Sign-In Successful'),
                                  icon: Icon(Icons.check),
                                  iconColor: Colors.green,
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Dismiss'),
                                      onPressed: () {
                                        Navigator.pushReplacement<void, void>(
                                          //moves the screen to the SignInScreen
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                HomeScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          //runs the alertDialog
                          showMyDialog();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            //if user is not found
                            Future<void> showMyDialog() async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Log-in Error'),
                                    icon: Icon(Icons.error),
                                    iconColor: Colors.red,
                                    content: SingleChildScrollView(
                                        child: Text('User does not exist!',
                                            textAlign: TextAlign.center)),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Dismiss'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            //runs the alertDialog
                            showMyDialog();
                          } else if (e.code == 'wrong-password') {
                            Future<void> showMyDialog() async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Log-in Error'),
                                    icon: Icon(Icons.error),
                                    iconColor: Colors.red,
                                    content: SingleChildScrollView(
                                        child: Text('Incorrect Login Details!',
                                            textAlign: TextAlign.center)),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Dismiss'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            //runs the alertDialog
                            showMyDialog();
                          } else if (e.code == 'invalid-email') {
                            Future<void> showMyDialog() async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Log-in Error'),
                                    icon: Icon(Icons.error),
                                    iconColor: Colors.red,
                                    content: SingleChildScrollView(
                                        child: Text('E-mail is not valid!',
                                            textAlign: TextAlign.center)),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Dismiss'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            //runs the alertDialog
                            showMyDialog();
                          }
                        }
                      }
                      //End of FIREBASE AUTH---
                    },
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
              Container(
                height: screenHeight * 0.05,
                width: screenWidth * 0.65,
                padding:
                    EdgeInsets.only(top: 5.0, left: 10, right: 5, bottom: 5),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Don\'t have an account yet? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                          text: 'Sign Up ',
                          style: TextStyle(color: Colors.blueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement<void, void>(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        SignUpScreen()),
                              );
                            }),
                      TextSpan(
                        text: 'now!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

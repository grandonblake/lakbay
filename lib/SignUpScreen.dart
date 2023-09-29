import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import './SignInScreen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final db = FirebaseFirestore.instance;

  //show the password or not
  bool _isObscure = true;
  bool _isObscure2 = true;
  bool isChecked = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _textFirstName = TextEditingController();
  final _textLastName = TextEditingController();
  final _textEmailAddress = TextEditingController();
  final _textPassword = TextEditingController();
  final _textConfirmPassword = TextEditingController();
  bool _validate = false;
  bool _validate2 = false;
  bool _validate3 = false;
  bool _validate4 = false;
  bool _validate5 = false;
  Color checkboxColor = Colors.black;

  @override
  void dispose() {
    _textFirstName.dispose();
    _textLastName.dispose();
    _textEmailAddress.dispose();
    _textPassword.dispose();
    _textConfirmPassword.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          reverse: true,
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: 250,
                padding: EdgeInsets.only(top: 100),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, height: 1, fontSize: 60),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 250,
                padding: EdgeInsets.only(top: 10),
                child: const Text(
                  "Please complete your",
                  style:
                      TextStyle(fontFamily: 'Poppins', height: 1, fontSize: 16),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 250,
                padding: EdgeInsets.only(bottom: 50.0),
                child: const Text(
                  "biodata correctly",
                  style:
                      TextStyle(fontFamily: 'Poppins', height: 0, fontSize: 16),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.40,
                  padding: const EdgeInsets.only(right: 2, bottom: 0.0),
                  child: TextFormField(
                    controller: _textFirstName,
                    autocorrect: true,
                    decoration: InputDecoration(
                      helperText: ' ',
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      errorText: _validate ? 'First Name is required' : null,
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.35,
                    padding: const EdgeInsets.only(right: 0, bottom: 0.0),
                    child: TextFormField(
                      controller: _textLastName,
                      autocorrect: true,
                      decoration: InputDecoration(
                        helperText: ' ',
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                        errorText: _validate2 ? 'Last Name is required' : null,
                      ),
                    )),
              ]),
              Container(
                  width: screenWidth * 0.75,
                  padding:
                      EdgeInsets.only(top: 10), //padding for the error message
                  child: TextFormField(
                    controller: _textEmailAddress,
                    autocorrect: true,
                    decoration: InputDecoration(
                      helperText: ' ',
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      errorText:
                          _validate3 ? 'Email Address is required' : null,
                    ),
                  )),
              Container(
                width: screenWidth * 0.75,
                padding:
                    EdgeInsets.only(top: 10), //padding for the error message
                child: TextFormField(
                  obscureText: _isObscure,
                  controller: _textPassword,
                  autocorrect: true,
                  decoration: InputDecoration(
                      helperText: ' ',
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      errorText: _validate4 ? 'Password is required' : null,
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
                width: screenWidth * 0.75,
                padding:
                    EdgeInsets.only(top: 10), //padding for the error message
                child: TextFormField(
                  obscureText: _isObscure2,
                  controller: _textConfirmPassword,
                  autocorrect: true,
                  decoration: InputDecoration(
                      helperText: ' ',
                      border: OutlineInputBorder(),
                      errorText:
                          _validate5 ? 'Confirm Password is required' : null,
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure2
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          })),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor:
                          MaterialStateProperty.all<Color>(checkboxColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                          checkboxColor = Colors.black;
                        });
                      },
                    )),
                Container(
                  padding:
                      EdgeInsets.only(top: 10), //padding for the error message
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                            text: 'Terms',
                            style: TextStyle(color: Colors.blueAccent),
                            recognizer: TapGestureRecognizer()),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                            text: 'Conditions',
                            style: TextStyle(color: Colors.blueAccent),
                            recognizer: TapGestureRecognizer()),
                      ],
                    ),
                  ),
                ),
              ]),
              Container(
                  width: 300,
                  height: 50,
                  margin: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _textFirstName.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                        _textLastName.text.isEmpty
                            ? _validate2 = true
                            : _validate2 = false;
                        _textEmailAddress.text.isEmpty
                            ? _validate3 = true
                            : _validate3 = false;
                        _textPassword.text.isEmpty
                            ? _validate4 = true
                            : _validate4 = false;
                        _textConfirmPassword.text.isEmpty
                            ? _validate5 = true
                            : _validate5 = false;

                        isChecked
                            ? checkboxColor = Colors.black
                            : checkboxColor = Colors.red;
                      });

                      //if all fields are not empty and if checkbox is checked
                      if (_validate == false &&
                          _validate2 == false &&
                          _validate3 == false &&
                          _validate4 == false &&
                          _validate5 == false &&
                          isChecked == true) {
                        if (_textPassword.text == _textConfirmPassword.text) {
                          //if password and confirmPassword is the same
                          //Start of FIREBASE AUTH--
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: _textEmailAddress.text,
                              password: _textPassword.text,
                            );

                            FirebaseAuth.instance
                                .authStateChanges()
                                .listen((User? user) {
                              if (user != null) {
                                final userDetails = <String, dynamic>{
                                  "firstName": _textFirstName.text,
                                  "lastName": _textLastName.text,
                                  "emailAddress": _textEmailAddress.text
                                };

                                db
                                    .collection("users")
                                    .doc(user.uid)
                                    .set(userDetails);
                              }
                            });

                            if (FirebaseAuth.instance.currentUser != null) {
                              print(FirebaseAuth.instance.currentUser?.uid);

                              final userDetails = <String, dynamic>{
                                "firstName": _textFirstName.text,
                                "lastName": _textLastName.text,
                                "emailAddress": _textEmailAddress.text
                              };

                              db
                                  .collection("users")
                                  .doc(
                                      "${FirebaseAuth.instance.currentUser?.uid}")
                                  .set(userDetails);
                            }

                            Future<void> showMyDialog() async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Sign-Up Successful'),
                                    icon: Icon(Icons.check),
                                    iconColor: Colors.green,
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Dismiss'),
                                        onPressed: () {
                                          FirebaseAuth.instance.signOut();
                                          Navigator.pushReplacement<void, void>(
                                            //moves the screen to the SignInScreen
                                            context,
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  SignInScreen(),
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
                            if (e.code == 'weak-password') {
                              Future<void> showMyDialog() async {
                                return showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Sign-Up Error'),
                                      icon: Icon(Icons.error),
                                      iconColor: Colors.red,
                                      content: SingleChildScrollView(
                                          child: Text(
                                              'Password must be 6 characters or more!',
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
                            } else if (e.code == 'email-already-in-use') {
                              Future<void> showMyDialog() async {
                                return showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      false, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Sign-Up Error'),
                                      icon: Icon(Icons.error),
                                      iconColor: Colors.red,
                                      content: SingleChildScrollView(
                                          child: Text(
                                              'E-mail is already in use!',
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
                                      title: Text('Sign-Up Error'),
                                      icon: Icon(Icons.error),
                                      iconColor: Colors.red,
                                      content: SingleChildScrollView(
                                          child: Text('E-mail is invalid!',
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
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          Future<void> showMyDialog() async {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible:
                                  false, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Sign-Up Error'),
                                  icon: Icon(Icons.error),
                                  iconColor: Colors.red,
                                  content: SingleChildScrollView(
                                      child: Text('Password is not the same!',
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
                      } //End of FIREBASE AUTH--
                    },
                    child: Text('Create your Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEBA32D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
              Container(
                padding: EdgeInsets.only(top: 10, left: 5),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                          text: 'Sign In ',
                          style: TextStyle(color: Colors.blueAccent),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement<void, void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      SignInScreen(),
                                ),
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

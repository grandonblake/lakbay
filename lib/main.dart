import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import './SignInScreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.signOut();
  runApp(MaterialApp(
    home: StartUpScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class StartUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ImageSlideshow(
          width: screenWidth,
          height: screenHeight,
          initialPage: 0,
          indicatorColor: Colors.blue,
          indicatorBackgroundColor: Colors.grey,
          autoPlayInterval: 2000,
          isLoop: true,
          children: [
            Image.asset('assets/images/1.jpg', fit: BoxFit.cover),
            Image.asset('assets/images/2.jpg', fit: BoxFit.cover),
            Image.asset('assets/images/3.jpg', fit: BoxFit.cover),
            Image.asset('assets/images/4.jpg', fit: BoxFit.cover),
            Image.asset('assets/images/5.jpg', fit: BoxFit.cover),
          ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: () {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => SignInScreen(),
              ),
            );
          }),
    );
  }
}

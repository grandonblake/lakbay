import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './DiscoverScreen.dart';
import './PlaceScreen.dart';
import './BookmarkedScreen.dart';
import './SignInScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Image.asset('assets/images/logotitle.png', height: 40),
      actions: [
        IconButton(
            icon: Icon(Icons.logout, color: Colors.deepOrange),
            tooltip: 'Logout',
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => SignInScreen(),
                ),
              );
            }),
      ],
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      bottom: TabBar(
        labelColor: Color(0xFFEBA32D),
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(icon: Icon(Icons.map)),
          Tab(icon: Icon(Icons.explore)),
          Tab(icon: Icon(Icons.bookmark)),
        ],
      ),
    );

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarHeight = appBar.preferredSize.height;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        print('User ID: ${user.uid}');
      }
    });

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          extendBodyBehindAppBar: false,
          appBar: appBar,
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                  height: (screenHeight - appBarHeight - statusbarHeight),
                  width: screenWidth,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              'assets/images/backgroundMainMenu.jpg'),
                          fit: BoxFit.cover)),
                  child: Stack(children: [
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.33,
                      left: screenWidth * 0.41,
                      child: Tooltip(
                        message: 'Ayala Museum',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Ayala Museum")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.22,
                      left: screenWidth * 0.41,
                      child: Tooltip(
                        message: 'Banaue Rice Terraces',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Banaue Rice Terraces")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.54,
                      left: screenWidth * 0.23,
                      child: Tooltip(
                        message: 'Big Lagoon',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Big Lagoon")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.23,
                      left: screenWidth * 0.35,
                      child: Tooltip(
                        message: 'Burnham Park',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Burnham Park")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.62,
                      left: screenWidth * 0.70,
                      child: Tooltip(
                        message: 'Chocolate Hills',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Chocolate Hills")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.32,
                      left: screenWidth * 0.28,
                      child: Tooltip(
                        message: 'Corregidor Island',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Corregidor Island")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.77,
                      left: screenWidth * 0.83,
                      child: Tooltip(
                        message: 'Eden Nature Park',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Eden Nature Park")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.34,
                      left: screenWidth * 0.37,
                      child: Tooltip(
                        message: 'Fort Santiago',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Fort Santiago")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.66,
                      left: screenWidth * 0.64,
                      child: Tooltip(
                        message: 'Hinagdanan Cave',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Hinagdanan Cave")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.25,
                      left: screenWidth * 0.32,
                      child: Tooltip(
                        message: 'Hundred Islands',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Hundred Islands")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.29,
                      left: screenWidth * 0.43,
                      child: Tooltip(
                        message: 'Intramuros',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Intramuros")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.49,
                      left: screenWidth * 0.29,
                      child: Tooltip(
                        message: 'Kayangan Lake',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Kayangan Lake")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          (screenHeight - appBarHeight - statusbarHeight) * 0.6,
                      left: screenWidth * 0.89,
                      child: Tooltip(
                        message: 'Magpupungko Beach',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Magpupungko Beach")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.34,
                      left: screenWidth * 0.32,
                      child: Tooltip(
                        message: 'Manila Cathedral',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Manila Cathedral")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.31,
                      left: screenWidth * 0.35,
                      child: Tooltip(
                        message: 'Manila Ocean Park',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Manila Ocean Park")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          (screenHeight - appBarHeight - statusbarHeight) * 0.3,
                      left: screenWidth * 0.39,
                      child: Tooltip(
                        message: 'Manila Zoo',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Manila Zoo")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          (screenHeight - appBarHeight - statusbarHeight) * 0.4,
                      left: screenWidth * 0.63,
                      child: Tooltip(
                        message: 'Mayon Volcano',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Mayon Volcano")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.37,
                      left: screenWidth * 0.42,
                      child: Tooltip(
                        message: 'Mount Makiling',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Mount Makiling")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.27,
                      left: screenWidth * 0.34,
                      child: Tooltip(
                        message: 'Mount Pinatubo',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Mount Pinatubo")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.33,
                      left: screenWidth * 0.45,
                      child: Tooltip(
                        message: 'Pagsanjan Falls',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Pagsanjan Falls")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.37,
                      left: screenWidth * 0.30,
                      child: Tooltip(
                        message: 'Pico de Loro',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Pico de Loro")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.59,
                      left: screenWidth * 0.19,
                      child: Tooltip(
                        message: 'Puerto Princesa Underground River',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceScreen(
                                      "Puerto Princesa Underground River")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.26,
                      left: screenWidth * 0.42,
                      child: Tooltip(
                        message: 'Rizal Park',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Rizal Park")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.37,
                      left: screenWidth * 0.37,
                      child: Tooltip(
                        message: 'San Agustin Church',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("San Agustin Church")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.19,
                      left: screenWidth * 0.38,
                      child: Tooltip(
                        message: 'Sumaguing Cave',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Sumaguing Cave")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          (screenHeight - appBarHeight - statusbarHeight) * 0.4,
                      left: screenWidth * 0.39,
                      child: Tooltip(
                        message: 'Taal Volcano',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Taal Volcano")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.55,
                      left: screenWidth * 0.50,
                      child: Tooltip(
                        message: 'The Ruins',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("The Ruins")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.63,
                      left: screenWidth * 0.14,
                      child: Tooltip(
                        message: 'Tubbataha Reef National Marine Park',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceScreen(
                                      "Tubbataha Reef National Marine Park")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: (screenHeight - appBarHeight - statusbarHeight) *
                          0.15,
                      left: screenWidth * 0.33,
                      child: Tooltip(
                        message: "Vigan City",
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("Vigan City")),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top:
                          (screenHeight - appBarHeight - statusbarHeight) * 0.5,
                      left: screenWidth * 0.48,
                      child: Tooltip(
                        message: 'White Beach',
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Image.asset(
                            'assets/images/pinPhilippines.png',
                            width: screenWidth * 0.04,
                            height: (screenHeight - appBarHeight) * 0.5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceScreen("White Beach")),
                            );
                          },
                        ),
                      ),
                    ),
                  ])),
              DiscoverScreen(),
              BookmarkedScreen(),
            ],
          ),
        ));
  }
}

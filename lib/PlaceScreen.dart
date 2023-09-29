import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceScreen extends StatefulWidget {
  String attractionName;
  PlaceScreen(this.attractionName);
  @override
  State<PlaceScreen> createState() => _PlaceScreenState(attractionName);
}

class _PlaceScreenState extends State<PlaceScreen>
    with TickerProviderStateMixin {
  String attractionName;
  _PlaceScreenState(this.attractionName);

  final db = FirebaseFirestore.instance;
  TextEditingController commentTextFieldValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Future<Map<String, dynamic>> getAttractionDetails() async {
      final attractionDetails =
          db.collection("attractions").doc(attractionName);

      final attractionDetailsSnapshot = await attractionDetails.get();
      if (attractionDetailsSnapshot.exists) {
        final attractionDetailsData = attractionDetailsSnapshot.data()!;
        return attractionDetailsData;
      } else {
        throw Exception('Attraction details do not exist');
      }
    }

    Future<double> getAttractionUserRating() async {
      final attractionUserRating = FirebaseFirestore.instance
          .collection("attractions")
          .doc(attractionName)
          .collection("ratings")
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final attractionUserRatingSnapshot = await attractionUserRating.get();
      if (attractionUserRatingSnapshot.exists) {
        final attractionUserRatingData = attractionUserRatingSnapshot.data();
        final rating = attractionUserRatingData?['rating'] as double?;
        return rating ?? 0.0;
      } else {
        return 0;
      }
    }

    Future<bool> getAttractionUserBookmark() async {
      final attractionBookmark = db
          .collection("bookmarks")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("attractions")
          .doc(attractionName);

      final attractionBookmarkSnapshot = await attractionBookmark.get();
      if (attractionBookmarkSnapshot.exists) {
        final attractionBookmarkData = attractionBookmarkSnapshot.data()!;
        final bookmarked = attractionBookmarkData['bookmarked'];
        return bookmarked;
      } else {
        return false;
      }
    }

    Future<List<Map>> getAttractionComments() async {
      final attractionComments = db
          .collection("attractions")
          .doc(attractionName)
          .collection("comments");

      final querySnapshot =
          await attractionComments.orderBy("timestamp", descending: true).get();
      final attractionCommentsData =
          querySnapshot.docs.map((doc) => doc.data()).toList();

      return attractionCommentsData;
    }

    return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFFEBA32D)),
        body: SingleChildScrollView(
            child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: getAttractionDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final attractionDetailsData = snapshot.data!;
                  return Container(
                    height: screenHeight * 0.65,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            constraints: BoxConstraints.expand(),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    attractionDetailsData['attractionImage']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 5),
                            child: Column(
                              children: [
                                //for place name and icons
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Text(
                                            attractionName,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w900,
                                            ),
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: FutureBuilder<double>(
                                            future: getAttractionUserRating(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return RatingBar(
                                                  initialRating: snapshot.data!,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  ratingWidget: RatingWidget(
                                                    full: const Icon(Icons.star,
                                                        color: Colors.orange),
                                                    half: const Icon(
                                                        Icons.star_half,
                                                        color: Colors.orange),
                                                    empty: const Icon(
                                                        Icons.star_outline,
                                                        color: Colors.orange),
                                                  ),
                                                  onRatingUpdate: (value) {
                                                    setState(() {
                                                      double currentRating =
                                                          snapshot.data!;
                                                      if (currentRating ==
                                                          value) {
                                                        currentRating = 0;
                                                      } else {
                                                        // Update the initial rating with the clicked rating
                                                        currentRating = value;
                                                      }

                                                      final rating = {
                                                        "rating": currentRating
                                                      };

                                                      db
                                                          .collection(
                                                              "attractions")
                                                          .doc(attractionName)
                                                          .collection("ratings")
                                                          .doc(FirebaseAuth
                                                              .instance
                                                              .currentUser
                                                              ?.uid)
                                                          .set(rating)
                                                          .onError((e, _) => print(
                                                              "Error writing document: $e"));
                                                    });
                                                  },
                                                );
                                              } else if (snapshot.hasError) {
                                                print(snapshot.error);
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            },
                                          )),
                                      Expanded(
                                        flex: 1,
                                        child: FutureBuilder<bool>(
                                          future: getAttractionUserBookmark(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var attractionBookmarkData =
                                                  snapshot.data!;
                                              return IconButton(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 0, 0, 0),
                                                constraints: BoxConstraints(),
                                                icon: attractionBookmarkData ==
                                                        false
                                                    ? Icon(
                                                        Icons.bookmark_border,
                                                        color: Colors.orange)
                                                    : Icon(Icons.bookmark,
                                                        color: Colors.orange),
                                                onPressed: () => setState(() {
                                                  var bookmarked;
                                                  if (!attractionBookmarkData) {
                                                    //if bookmark is not pressed
                                                    bookmarked = {
                                                      "bookmarked": true
                                                    };
                                                  } else {
                                                    bookmarked = {
                                                      "bookmarked": false
                                                    };
                                                  }
                                                  attractionBookmarkData =
                                                      !attractionBookmarkData;
                                                  db
                                                      .collection("bookmarks")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .collection("attractions")
                                                      .doc(attractionName)
                                                      .set(bookmarked)
                                                      .onError((e, _) => print(
                                                          "Error writing document: $e"));
                                                }),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      attractionDetailsData[
                                          'attractionLocation'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        // color: HexColor("#3c5062"),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                // for description
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      attractionDetailsData[
                                          'attractionDescription'],
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        // color: HexColor("#3b4848"),
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Container(
              height: screenHeight * 0.30,
              // color: Colors.blue,
              child: Container(
                  margin: EdgeInsets.all(25),
                  // color: Colors.purple,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                                child: Icon(Icons.person),
                                radius: 20,
                                backgroundColor: Color(0xFFEBA32D),
                                foregroundColor: Colors.white),
                            title: TextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: null,
                              controller: commentTextFieldValue,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Color(0xFFEBA32D))),
                                hintText: 'Write a comment...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            trailing: IconButton(
                                icon: Icon(Icons.send, size: 25),
                                color: Color(0xFFEBA32D),
                                onPressed: () async {
                                  final User? user =
                                      FirebaseAuth.instance.currentUser;
                                  final uid = user?.uid;

                                  DocumentSnapshot doc = await FirebaseFirestore
                                      .instance
                                      .collection('users')
                                      .doc(uid)
                                      .get();

                                  Map<String, dynamic> data =
                                      doc.data() as Map<String, dynamic>;
                                  String firstName =
                                      data['firstName'] as String;
                                  String lastName = data['lastName'] as String;

                                  final comment = {
                                    "comment": commentTextFieldValue.text,
                                    "firstName": firstName,
                                    "lastName": lastName,
                                    "User UID": user?.uid,
                                    "timestamp": FieldValue.serverTimestamp()
                                  };

                                  db
                                      .collection("attractions")
                                      .doc(attractionName)
                                      .collection("comments")
                                      .add(comment);

                                  setState(() {});

                                  commentTextFieldValue.clear();
                                }),
                          )),
                      Expanded(
                        flex: 7,
                        child: FutureBuilder<List<Map>>(
                          future: getAttractionComments(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: CircleAvatar(
                                              child: Icon(Icons.person),
                                              radius:
                                                  20, // make it so that this radius is the same as the one in the profile page
                                              backgroundColor:
                                                  Color(0xFFEBA32D),
                                              foregroundColor: Colors.white),
                                          title: Text(
                                              snapshot.data![index]
                                                      ['firstName'] +
                                                  " " +
                                                  snapshot.data![index]
                                                      ['lastName'],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                              snapshot.data![index]['comment'],
                                              style: TextStyle(fontSize: 14)),
                                        );
                                      }));
                            } else if (snapshot.hasError) {
                              return new Text("${snapshot.error}");
                            }
                            return new Container(
                              alignment: AlignmentDirectional.center,
                              child: new CircularProgressIndicator(),
                            );
                          },
                        ),
                      )
                    ],
                  )),
            )
          ],
        )));
  }
}

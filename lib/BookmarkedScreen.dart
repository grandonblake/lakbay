import 'package:flutter/material.dart';

import './PlaceScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkedScreen extends StatefulWidget {
  @override
  State<BookmarkedScreen> createState() => _BookmarkedScreenState();
}

class _BookmarkedScreenState extends State<BookmarkedScreen> {
  Future<List<Map<String, dynamic>>> getBookmarkedAttractions(
      String userID) async {
    List<Map<String, dynamic>> bookmarkedAttractions = [];

    // Get all attractions that user has bookmarked
    QuerySnapshot bookmarked = await FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(userID)
        .collection('attractions')
        .where('bookmarked', isEqualTo: true)
        .get();

    for (var doc in bookmarked.docs) {
      String attractionName = doc.id; // document id is the attraction name

      // Get details for each bookmarked attraction
      DocumentSnapshot attractionDoc = await FirebaseFirestore.instance
          .collection('attractions')
          .doc(attractionName)
          .get();

      Map<String, dynamic>? attractionData =
          attractionDoc.data() as Map<String, dynamic>?;

      if (attractionData != null) {
        attractionData['attractionName'] = attractionName;
        bookmarkedAttractions.add(attractionData);
      }
    }

    return bookmarkedAttractions;
  }

  @override
  Widget build(BuildContext context) {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'BOOKMARKS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 42,
                fontFamily: 'Mont',
                color: Color.fromARGB(255, 48, 48, 48),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Divider(
          color: Colors.orange,
          thickness: 3,
          indent: 60,
          endIndent: 60,
        ),
        Expanded(
          flex: 13,
          child: FutureBuilder(
            future: getBookmarkedAttractions(userID!),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              List<Map<String, dynamic>> attractions = snapshot.data ?? [];
              if (attractions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.inbox, size: 100), // 'empty' icon
                      Text('There are no bookmarked attractions'),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: attractions.length,
                itemBuilder: (BuildContext context, int index) {
                  final attraction = attractions[index];
                  return Container(
                    width: 300,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceScreen(
                                      attraction['attractionName'])),
                            );
                          },
                          child: Image.network(
                            attraction['attractionImage'],
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          attraction['attractionName'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          attraction['attractionLocation'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ));
  }
}

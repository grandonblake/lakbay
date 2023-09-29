import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './PlaceScreen.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  Future<List<Map<String, dynamic>>> fetchAttractionsData() async {
    List<Map<String, dynamic>> data = [];

    QuerySnapshot attractionsSnapshot =
        await FirebaseFirestore.instance.collection('attractions').get();

    for (QueryDocumentSnapshot attraction in attractionsSnapshot.docs) {
      String attractionName = attraction.id;

      String attractionDescription = attraction.get('attractionDescription');
      String attractionLocation = attraction.get('attractionLocation');
      String attractionImage = attraction.get('attractionImage');

      QuerySnapshot ratingsSnapshot =
          await attraction.reference.collection('ratings').get();

      if (ratingsSnapshot.docs.isEmpty) {
        QuerySnapshot usersSnapshot =
            await FirebaseFirestore.instance.collection('users').get();

        for (QueryDocumentSnapshot user in usersSnapshot.docs) {
          String userID = user.id;

          data.add({
            'attractionName': attractionName,
            'attractionDescription': attractionDescription,
            'attractionLocation': attractionLocation,
            'attractionImage': attractionImage,
            'userID': userID,
            'rating': 0.0,
          });
        }
      } else {
        for (QueryDocumentSnapshot rating in ratingsSnapshot.docs) {
          String userID = rating.id;

          Map<String, dynamic>? ratingData =
              rating.data() as Map<String, dynamic>?;
          double userRating =
              (ratingData != null && ratingData.containsKey('rating'))
                  ? (ratingData['rating'] as double)
                  : 0.0;

          data.add({
            'attractionName': attractionName,
            'attractionDescription': attractionDescription,
            'attractionLocation': attractionLocation,
            'attractionImage': attractionImage,
            'userID': userID,
            'rating': userRating,
          });
        }
      }
    }

    return data;
  }

  Future<List<dynamic>> fetchDatasetsAndSendToFlask(String userID) async {
    // Fetch the datasets
    List<Map<String, dynamic>> dataset = await fetchAttractionsData();

    // Prepare the request payload
    Map<String, dynamic> requestData = {
      'dataset': dataset,
      'userID': userID,
    };

    // Send the datasets to Flask
    final url = 'http://10.0.2.2:5000/recommend-attractions';
    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode(requestData);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final collabFilteringOutput =
          responseData['collabFilteringOutput'] as List<dynamic>;
      final contentBasedFilteringOutput =
          responseData['contentBasedFilteringOutput'] as List<dynamic>;
      final weightedHybridApproachOutput =
          responseData['weightedHybridApproachOutput'] as List<dynamic>;

      // Return the recommendation outputs
      return [
        collabFilteringOutput,
        contentBasedFilteringOutput,
        weightedHybridApproachOutput,
      ];
    } else {
      throw Exception('Failed to send datasets: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userID = FirebaseAuth.instance.currentUser?.uid;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'DISCOVER',
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
            indent: 80,
            endIndent: 80,
          ),
          Expanded(
              flex: 13,
              child: FutureBuilder(
                future: fetchDatasetsAndSendToFlask(userID!),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final collabFilteringOutput =
                        snapshot.data![0] as List<dynamic>;
                    final contentBasedFilteringOutput =
                        snapshot.data![1] as List<dynamic>;
                    final weightedHybridApproachOutput =
                        snapshot.data![2] as List<dynamic>;

                    // Check if any of the outputs are empty arrays
                    if (collabFilteringOutput.isEmpty &&
                        contentBasedFilteringOutput.isEmpty &&
                        weightedHybridApproachOutput.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sentiment_dissatisfied,
                              size: 150,
                              color: Colors.grey,
                            ),
                            Text(
                              "No recommendations available. Rate items first!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Liked by users with similar tastes:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: collabFilteringOutput.length,
                          itemBuilder: (ctx, index) {
                            final attraction = collabFilteringOutput[index];
                            return Container(
                              width: 300,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 3),
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
                                      height: 130,
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
                        )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Similar to your likes:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: contentBasedFilteringOutput.length,
                          itemBuilder: (ctx, index) {
                            final attraction =
                                contentBasedFilteringOutput[index];
                            return Container(
                              width: 300,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 3),
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
                                      height: 130,
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
                        )),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Best Recommendations For You:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weightedHybridApproachOutput.length,
                          itemBuilder: (ctx, index) {
                            final attraction =
                                weightedHybridApproachOutput[index];
                            return Container(
                              width: 300,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.orange, width: 3),
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
                                      height: 130,
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
                        ))
                      ],
                    );
                  }
                },
              )),
        ],
      ),
    );
  }
}

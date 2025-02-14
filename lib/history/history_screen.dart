import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttandanceHistoryScreen extends StatefulWidget {
  const AttandanceHistoryScreen({super.key});

  @override
  State<AttandanceHistoryScreen> createState() =>
      _AttandanceHistoryScreenState();
}

class _AttandanceHistoryScreenState extends State<AttandanceHistoryScreen> {
  final CollectionReference dataCollection =
  FirebaseFirestore.instance.collection('absensipal');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Attendance History',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: dataCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!.docs;
            return data.isNotEmpty
                ? ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.primaries[Random().nextInt(
                            Colors.primaries.length,
                          )],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            (data.isNotEmpty &&
                                data[index]['name'] != null)
                                ? data[index]['name'][0].toUpperCase()
                                : '-',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'name',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['name'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'address',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['address'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'status',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['status'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'dateTime',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data[index]['dateTime'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
                : const Center(
              child: Text(
                'Data Not Found',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:attandance_edit/attendance/attendance_screen.dart';
import 'package:attandance_edit/history/history_screen.dart';
import 'package:attandance_edit/permission/permission_screen.dart';
import 'package:flutter/material.dart';

import '../attendance/custom_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop(context);
          if (shouldPop) {
            Navigator.of(context).pop(true);
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black87,
                Colors.black87,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to my guys',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'What are you looking for?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      // Jumlah kolom
                      childAspectRatio: 0.9,
                      // Rasio ukuran tiap card
                      crossAxisSpacing: 15,
                      // Jarak horizontal antar card
                      mainAxisSpacing: 15,
                      // Jarak vertikal antar card
                      children: const [
                        custom_button_widget(
                          imageAssetPath: 'assets/images/absent.png',
                          title: 'Absent',
                          targetPage: AttendanceScreen(),
                        ),
                        custom_button_widget(
                          imageAssetPath: 'assets/images/sick.png',
                          title: 'Permission',
                          targetPage: AbsenScreen(),
                        ),
                        custom_button_widget(
                          imageAssetPath: 'assets/images/history.png',
                          title: 'History',
                          targetPage: AttandanceHistoryScreen(),
                        ),
                        custom_button_widget(
                          imageAssetPath: 'assets/images/logout.png',
                          title: 'Exit',
                          targetPage: AttendanceScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

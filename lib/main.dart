import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB9tJqmumnjl-3KXeJviV3Bnz0ai2k7SFw",
      appId: "1:814742867920:android:985c74581d7997ba9a33d5",
      messagingSenderId: "814742867920",
      projectId: "attendance-d2672",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/screens/widgets.dart';

// 9K#2xwqtk0wG
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Demo',
      defaultTransition: Transition.leftToRight,
      theme: ThemeData(
        primaryColor: const Color(0xFF910076),
      ),
      home: FutureBuilder(
        future: futureFB(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const FirebaseAppCheckExample();
          } else {
            return const CustomCircular();
          }
        },
      ),
    ),
  );
}

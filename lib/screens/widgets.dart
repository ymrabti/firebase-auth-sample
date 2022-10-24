import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loginsignup/controllers/auth_controller.dart';
import 'package:loginsignup/utils/console.dart';
import 'package:loginsignup/utils/constants.dart';

class GeoTrashBin {
  int litres = 0;
  Timestamp dateReclamation = Timestamp(0, 0);
  String addedBy = '';
  GeoPoint location = const GeoPoint(0, 0);
  String id = '';
  String type = '';
  bool reclamation = false;
  bool confirmed = false;
  Timestamp dateConfirme = Timestamp(0, 0);
  GeoTrashBin({
    required this.litres,
    required this.dateReclamation,
    required this.addedBy,
    required this.location,
    required this.id,
    required this.type,
    required this.reclamation,
    required this.confirmed,
    required this.dateConfirme,
  });
  GeoTrashBin.fromJson(Map<String, dynamic> data) {
    litres = data['litres'] ?? 0;
    dateReclamation = data['date_reclamation'] ?? Timestamp(0, 0);
    addedBy = data['addedBy'] ?? '';
    location = data['location'] ?? const GeoPoint(0, 0);
    id = data['id'] ?? '';
    type = data['type'] ?? '';
    reclamation = data['reclamation'] ?? false;
    confirmed = data['confirmed'] ?? false;
    dateConfirme = data['date_confirme'] ?? Timestamp(0, 0);
  }
  Map<String, dynamic> toMap() {
    return {
      "litres": litres,
      "date_reclamation": dateReclamation,
      "addedBy": addedBy,
      "location": location,
      "id": id,
      "type": type,
      "reclamation": reclamation,
      "confirmed": confirmed,
      "date_confirme": dateConfirme,
    };
  }
}

class CustomCircular extends StatelessWidget {
  const CustomCircular({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(backgroundColor: Colors.red),
      ),
    );
  }
}

futureFB() async {
//   await Future.delayed(const Duration(seconds: 3));
  var firebaseApp = await firebaseInitialization;
//   FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instanceFor(app: firebaseApp);
//   await FirebaseAppCheck.instance.activate(androidDebugProvider: true, webRecaptchaSiteKey: '');

  /* const emulatorHost = '10.0.2.2';
  await firebaseStorage.useStorageEmulator(emulatorHost, 9199); */
//   await firebaseAppCheck.activate();
  Get.put(AuthController());
}

/* class FirebaseAppCheckExample extends StatefulWidget {
  const FirebaseAppCheckExample({Key? key}) : super(key: key);

  @override
  State<FirebaseAppCheckExample> createState() => _FirebaseAppCheck();
}

class _FirebaseAppCheck extends State<FirebaseAppCheckExample> {
  final appCheck = FirebaseAppCheck.instance;
  String _message = '';
  String _eventToken = 'not yet';

  @override
  void initState() {
    appCheck.onTokenChange.listen(setEventToken);
    super.initState();
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  void setEventToken(String? token) {
    setState(() {
      _eventToken = token ?? 'not yet';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Check'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // Use this button to check whether the request was validated on the Firebase console
                // Gets first document in collection
                var collection = FirebaseFirestore.instance.collection('geopoints');
                final result = await collection.limit(1).get();

                var docs = result.docs;
                if (docs.isNotEmpty) {
                  GeoTrashBin.fromJson(docs.first.data())
                      .toMap()
                      .forEach((key, value) => Console.log('$key => $value'));
                  setMessage('Found');
                } else {
                  setMessage(
                    'Document not found, please add a document to the collection',
                  );
                }
              },
              child: const Text('Test App Check validates requests'),
            ),
            ElevatedButton(
              onPressed: () async {
                Console.log(
                  'Pass in your "webRecaptchaSiteKey" key found on you Firebase Console to activate if using on the web platform.',
                );

                await appCheck.activate(
                  androidDebugProvider: true,
                );
                setMessage('activated!!');
              },
              child: const Text('activate()'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Token will be passed to `onTokenChange()` event handler
                await appCheck.getToken(true);
              },
              child: const Text('getToken()'),
            ),
            ElevatedButton(
              onPressed: () async {
                await appCheck.setTokenAutoRefreshEnabled(true);
                setMessage('successfully set auto token refresh!!');
              },
              child: const Text('setTokenAutoRefreshEnabled()'),
            ),
            const SizedBox(height: 20),
            Text(
              _message, //#007bff
              style: const TextStyle(
                color: Color.fromRGBO(47, 79, 79, 1),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Token received from tokenChanges() API: $_eventToken', //#007bff
              style: const TextStyle(
                color: Color.fromRGBO(128, 0, 128, 1),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */
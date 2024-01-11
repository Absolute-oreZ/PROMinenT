import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prominent/firebase/firebase_options.dart';
import 'package:prominent/screens/homepage.dart';
import 'package:prominent/screens/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const PROMinenT());
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class PROMinenT extends StatelessWidget {
  const PROMinenT({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PROMinenT',
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          colorScheme: const ColorScheme.dark(),
          primaryColorDark: const Color.fromRGBO(52, 53, 65, 1),
          fontFamily: 'Roboto',
          iconTheme: const IconThemeData(color: Colors.white, size: 30),
          textTheme: const TextTheme(
              displayLarge: TextStyle(color: Colors.white, fontSize: 22),
              displayMedium: TextStyle(color: Colors.white, fontSize: 16),
              displaySmall: TextStyle(color: Colors.white, fontSize: 12))),
      //log in with firebase authentication
      /***************************************************************************************
      *    Title        : Firebase Authentication LogIn
      *    Author       : HeyFlutter.com (youtube channel)
      *    Date         : 7/1/2023
      *    Code version : 1.0
      *    Availability : https://www.youtube.com/watch?v=4vKiJZNPhss&ab_channel=HeyFlutter%E2%80%A4com
      ***************************************************************************************/
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something is wrong!"),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LogIn();
          }
        },
      ),
    );
  }
}

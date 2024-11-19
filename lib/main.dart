
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiping_views/Providers/VideoListProvider.dart';
import 'package:swiping_views/Providers/comments_provider.dart';
import 'package:swiping_views/Providers/login_provider.dart';
import 'package:swiping_views/Providers/profile_provider.dart';
import 'package:swiping_views/Screens/login_screen.dart';
import 'package:swiping_views/Screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBiwJtknlSoLnb0dssEe77peFuzVqjowDk',
          appId: '1:971195176821:android:4c6d48e775bbf8094fe53c',
          projectId: 'swipingviews',
          messagingSenderId: '971195176821'),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => VideoListProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ProfileProvider(),),
        ChangeNotifierProvider(create: (context) => LoginProvider(),),
        ChangeNotifierProvider(create: (context) => CommentsProvider())
      ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    )
    );
  }
}



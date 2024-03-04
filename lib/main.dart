
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swiping_views/Providers/VideoListProvider.dart';
import 'package:swiping_views/Screens/DisplayVideos.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => VideoListProvider(),)
      ],
      child:MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const DisplayVideos(),
    )
    );
  }
}



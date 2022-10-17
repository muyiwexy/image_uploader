import 'package:flutter/material.dart';
import 'package:image_uploader/Authprovider/imageprovider.dart';
import 'package:image_uploader/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => AppImageProvider(),
        lazy: false,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Homepage(title: 'Flutter Demo Home Page'),
        ),
      );
}

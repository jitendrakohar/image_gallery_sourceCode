import 'package:flutter/material.dart';
import 'package:image_gallery/screen/Home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

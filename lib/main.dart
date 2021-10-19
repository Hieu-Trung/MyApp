import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hivetodoteach/model.dart';
import 'package:hivetodoteach/todoList.dart';


const String todoBoxName ="todo";

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final document = await getApplicationDocumentsDirectory();

  Hive.init(document.path);
  Hive.registerAdapter(ModelAdapter());

  await Hive.openBox<Model>(todoBoxName);

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}


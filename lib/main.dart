import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Todo_list.dart';
import 'package:myapp/loading.dart';
import 'package:myapp/Services/database_services.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Todolist(),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black26,
            primarySwatch: Colors.pink,
          ),
        );
      }
    );
  }
}


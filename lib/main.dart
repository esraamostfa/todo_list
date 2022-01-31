import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/layouts/home_layout.dart';
import 'package:todo_list/shared/bloc_observer.dart';

void main() {

  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: HomeLayout()
    );
  }
}

import 'package:file_download_tutorial/cubit/file_manager_cubit.dart';
import 'package:file_download_tutorial/download_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(BlocProvider(
    create: (context) => FileManagerCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileDownloadExample(),
    );
  }
}

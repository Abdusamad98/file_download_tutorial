import 'package:file_download_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';


class LoaderExample extends StatefulWidget {
  const LoaderExample({Key? key}) : super(key: key);

  @override
  State<LoaderExample> createState() => _LoaderExampleState();
}

class _LoaderExampleState extends State<LoaderExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loader example"),),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            showLoader(context);
          }, child: Text("Sho wloader"))
        ],
      ),
    );
  }
}

import 'package:file_download_tutorial/cubit/file_manager_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_safe/open_file_safe.dart';

class FileDownloadExample extends StatefulWidget {
  const FileDownloadExample({Key? key}) : super(key: key);

  @override
  State<FileDownloadExample> createState() => _FileDownloadExampleState();
}

class _FileDownloadExampleState extends State<FileDownloadExample> {
  int doublePress = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (doublePress == 2) {
          return true;
        } else {
          doublePress++;
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("File download example one"),
        ),
        body: BlocBuilder<FileManagerCubit, FileManagerState>(
          builder: (context, state) {
            return StreamBuilder(
                stream: context.read<FileManagerCubit>().controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var prData = snapshot.data!;
                    return ListView(
                      children: List.generate(state.files.length, (index) {
                        var singleFile = state.files[index];
                        print("PRO:${singleFile.progress}");
                        return ListTile(
                          leading: const Icon(Icons.download),
                          title: Text(
                              "Downloaded: ${singleFile.progress * 100} %"),
                          subtitle: LinearProgressIndicator(
                            value: prData[index],
                            backgroundColor: Colors.black,
                          ),
                          onTap: () {
                            context.read<FileManagerCubit>().downloadIfExists(
                                  index: index,
                                );
                          },
                        );
                      }),
                    );
                  }
                  return const SizedBox();
                });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            OpenFile.open(
              "/storage/emulated/0/Download/video8.mp4",
            );
          },
        ),
      ),
    );
  }
}

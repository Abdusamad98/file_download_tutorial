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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File download example one"),
      ),
      body: BlocBuilder<FileManagerCubit, FileManagerState>(
        builder: (context, state) {
          //"https://images.all-free-download.com/footage_preview/mp4/closeup_of_wild_butterfly_in_nature_6891908.mp4",
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: Text("Downloaded: ${state.progress * 100} %"),
                subtitle: LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: Colors.black,
                ),
                onTap: () {
                  context.read<FileManagerCubit>().downloadFile(
                        fileName: "fileName",
                        url:
                            "https://bilimlar.uz/wp-content/uploads/2021/02/k100001.pdf",
                      );
                },
              ),
              StreamBuilder<double>(
                  stream: state.myStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var value = snapshot.data!;
                      return LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.black,
                      );
                    }
                    return const SizedBox();
                  })
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          OpenFile.open(
            "/storage/emulated/0/Download/video8.mp4",
          );
        },
      ),
    );
  }
}

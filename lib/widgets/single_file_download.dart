import 'package:file_download_tutorial/download_cubit/file_manager_cubit.dart';
import 'package:file_download_tutorial/models/file_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file_safe/open_file_safe.dart';

class SingleFileDownload extends StatelessWidget {
  SingleFileDownload({Key? key, required this.fileInfo}) : super(key: key);

  final FileInfo fileInfo;
   FileManagerCubit fileManagerCubit = FileManagerCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: fileManagerCubit,
      child: BlocBuilder<FileManagerCubit, FileManagerState>(
        builder: (context, state) {
          return ListTile(
            leading: state.newFileLocation.isEmpty
                ? const Icon(Icons.download)
                : const Icon(Icons.download_done),
            title: Text("Downloaded: ${state.progress * 100} %"),
            subtitle: LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.black,
            ),
            onTap: () {
              context
                  .read<FileManagerCubit>()
                  .downloadIfExists(fileInfo: fileInfo);
            },
            trailing: IconButton(
              onPressed: () {
                if (state.newFileLocation.isNotEmpty) {
                  print(state.newFileLocation);
                  OpenFile.open(state.newFileLocation);
                }
              },
              icon: const Icon(Icons.file_open),
            ),
          );
        },
      ),
    );
  }
}

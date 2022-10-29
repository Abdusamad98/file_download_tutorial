import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_download_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'file_manager_state.dart';

class FileManagerCubit extends Cubit<FileManagerState> {
  FileManagerCubit()
      : super(
          FileManagerState(
              files: filesData,
              progresses: filesData.map((e) => e.progress).toList()),
        );

   StreamController<List<double>> controller = StreamController<List<double>>();

   void func(){
     controller.stream.asBroadcastStream();
  }
  List<double> progresses = filesData.map((e) => e.progress).toList();

  void downloadFile({
    required String fileName,
    required String url,
  }) async {
    //Permission get
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;
    Dio dio = Dio();

    // Userga ko'rinadigan path
    var directory = await getDownloadPath();
    String newFileLocation =
        "${directory?.path}/$fileName${url.substring(url.length - 5, url.length)}";
    var allFiles = directory?.list();

    print("NEW FILE:$newFileLocation");

    List<String> filePaths = [];
    await allFiles?.forEach((element) {
      print("FILES IN DOWNLOAD FOLDER:${element.path}");
      filePaths.add(element.path.toString());
    });

    if (filePaths.contains(newFileLocation)) {
      OpenFile.open(newFileLocation);
    } else {
      try {
        await dio.download(url, newFileLocation,
            onReceiveProgress: (received, total) {
          double pr = received / total;
          // emit(state.copyWith(
          //   progress: pr,
          // ));
        });
        OpenFile.open(
          newFileLocation,
        );
      } catch (error) {
        debugPrint("DOWNLOAD ERROR:$error");
      }
    }
  }

  void downloadIfExists({
    required int index,
  }) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;
    Dio dio = Dio();
    var directory = await getDownloadPath();
    String url = state.files[index].fileUrl;
    String newFileLocation =
        "${directory?.path}/${state.files[index].fileName}${url.substring(url.length - 5, url.length)}";
    try {
      await dio.download(url, newFileLocation,
          onReceiveProgress: (received, total) {
        var pr = received / total;
        progresses[index] = pr;
        controller.sink.add(progresses);
        emit(state);
      });
      // OpenFile.open(
      //   newFileLocation,
      // );

    } catch (error) {
      debugPrint("DOWNLOAD ERROR:$error");
    }
  }

  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }

  Future<Directory?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      debugPrint("Cannot get download folder path");
    }
    return directory;
  }
}

class FileInfo extends Equatable {
  final String fileName;
  final String fileUrl;
  final double progress;

  FileInfo({
    required this.fileName,
    required this.fileUrl,
    required this.progress,
  });

  FileInfo copyWith({
    String? fileName,
    String? fileUrl,
    double? progress,
  }) =>
      FileInfo(
        fileName: fileName ?? this.fileName,
        fileUrl: fileUrl ?? this.fileUrl,
        progress: progress ?? this.progress,
      );

  @override
  List<Object?> get props => [
        fileName,
        fileUrl,
        progress,
      ];
}

List<FileInfo> filesData = [
  FileInfo(
    fileName: "PythonBook",
    fileUrl: "https://bilimlar.uz/wp-content/uploads/2021/02/k100001.pdf",
    progress: 0.0,
  ),
  FileInfo(
    progress: 0.0,
    fileName: "Butterfly",
    fileUrl:
        "https://images.all-free-download.com/footage_preview/mp4/closeup_of_wild_butterfly_in_nature_6891908.mp4",
  ),
  FileInfo(
    progress: 0.0,
    fileName: "Sabyan ya Rohman",
    fileUrl:
        "https://muzzona.kz/upload/files/2020-12/sabyan-gambus-rohman-ya-rohman_(muzzona.kz).mp3",
  ),
  FileInfo(
    progress: 0.0,
    fileName: "ajotyib rasm",
    fileUrl:
        "https://odam.uz/upload/media/posts/2019-10/21/mashhur-suratkash-ajoyib-rasm-olish-sirlarini-oshkor-qildi_1571694997-b.jpg",
  ),
  FileInfo(
    progress: 0.0,
    fileName: "Foydali file",
    fileUrl:
        "https://foydali-fayllar.uz/wp-content/uploads/2021/04/informatika-test.doc.zip",
  ),
];

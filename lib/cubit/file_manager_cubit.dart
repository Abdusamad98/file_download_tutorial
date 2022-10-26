import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'file_manager_state.dart';

class FileManagerCubit extends Cubit<FileManagerState> {
  FileManagerCubit()
      : super(
          FileManagerState(progress: 0.0, myStream: StreamController()),
        );

  final StreamController<double> streamController = StreamController<double>();

  // var directory2 = await getExternalStorageDirectories();
  // var directory3 = await getExternalStorageDirectory();

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
          streamController.sink.add(pr);
          emit(state.copyWith(
            progress: pr,
            myStream: streamController,
          ));
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
    required String fileName,
    required String url,
  }) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;
    Dio dio = Dio();
    var directory = await getDownloadPath();
    String newFileLocation =
        "${directory?.path}/$fileName${url.substring(url.length - 5, url.length)}";
    try {
      await dio.download(url, newFileLocation,
          onReceiveProgress: (received, total) {
        emit(state.copyWith(progress: received / total));
      });
      OpenFile.open(
        newFileLocation,
      );
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

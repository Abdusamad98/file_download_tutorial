import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_download_tutorial/models/file_info.dart';
import 'package:flutter/material.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'file_manager_state.dart';

class FileManagerCubit extends Cubit<FileManagerState> {
  FileManagerCubit()
      : super(
          FileManagerState(
            progress: 0.0,
            newFileLocation: "",
          ),
        );

  void downloadIfExists({
    required FileInfo fileInfo,
  }) async {
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;
    Dio dio = Dio();
    var directory = await getDownloadPath();
    print("PATH :${directory?.path}");
    String url = fileInfo.fileUrl;
    String newFileLocation =
        "${directory?.path}/${fileInfo.fileName}${url.substring(url.length - 5, url.length)}";
    try {
      await dio.download(url, newFileLocation,
          onReceiveProgress: (received, total) {
        var pr = received / total;
        print(pr);
        emit(state.copyWith(progress: pr));
      });
     emit(state.copyWith(newFileLocation: newFileLocation));
    } catch (error) {
      debugPrint("DOWNLOAD ERROR:$error");
    }
  }

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
          emit(state.copyWith(progress: pr));
        });
        OpenFile.open(newFileLocation);
      } catch (error) {
        debugPrint("DOWNLOAD ERROR:$error");
      }
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

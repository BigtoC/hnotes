import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:hnotes/domain/common_data.dart';


class FolderRepository {


  Future<bool> createFoldersWhenLunch() async {
    await createFolderInAppDocDir(imagesFolderName);
    await createFolderInAppDocDir(importedDataFolderName);
    return true;
  }

  Future<String> createFolderInAppDocDir(String folderNameParam) async {

    // Get this App Document Directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // App Document Directory + folder name
    final Directory appDocDirFolder =  Directory('${appDocDir.path}/$folderNameParam/');

    // if folder already exists return path
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else{  // if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  Future<String> saveStringFile(String contents, String fileName) async {
    File newFile = await _createFile(fileName);
    newFile.writeAsStringSync(contents);
    return newFile.path;
  }

  Future<String> saveBytesFile(Uint8List bytes, String fileName) async {
    File newFile = await _createFile(fileName);
    newFile.writeAsBytesSync(bytes);
    return newFile.path;
  }

  Future<File> _createFile(String fileName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    String newFilePathAndName = "${appDocDir.path}/$imagesFolderName/$fileName";
    File newFile = new File(newFilePathAndName);
    return newFile;
  }
}

import 'dart:io';
import 'dart:typed_data';

import 'package:hnotes/infrastructure/local_storage/files/folder_repository.dart';

class NftFileRepository extends FolderRepository {
  final String imagesFolderName = "images";
  final String importedDataFolderName = "data";

  Future<bool> createNftFolders() async {
    await createFolderInAppDocDir(imagesFolderName);
    await createFolderInAppDocDir(importedDataFolderName);
    return true;
  }

  Future<String> saveStringFile(String contents, String fileName) async {
    File newFile = await createFile(fileName, importedDataFolderName);
    newFile.writeAsStringSync(contents);
    return newFile.path;
  }

  Future<String> saveBytesFile(Uint8List bytes, String fileName) async {
    File newFile = await createFile(fileName, imagesFolderName);
    newFile.writeAsBytesSync(bytes);
    return newFile.path;
  }

  Future<bool> deleteNftFiles(String fileName) async {
    await deleteFile(importedDataFolderName, "$fileName.json");
    await deleteFile(imagesFolderName, "$fileName.png");
    return true;
  }

}

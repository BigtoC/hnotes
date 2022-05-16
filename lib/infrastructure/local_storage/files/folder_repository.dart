import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class FolderRepository {
  final String imagesFolderName = "images";
  final String importedDataFolderName = "data";

  Future<bool> createFoldersWhenLunch() async {
    await createFolderInAppDocDir(imagesFolderName);
    await createFolderInAppDocDir(importedDataFolderName);
    return true;
  }

  Future<bool> deleteNft(String fileName) async {
    await deleteFile(importedDataFolderName, fileName);
    await deleteFile(imagesFolderName, fileName);
    return true;
  }

  Future<String> createFolderInAppDocDir(String folderNameParam) async {
    // App Document Directory + folder name
    final Directory appDocDirFolder = await folderUnderAppDir(folderNameParam);

    // if folder already exists return path
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      // if folder not exists create folder and then return its path
      final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  Future<List<File>> loadAllFilesInFolder(String folderNameParam) async {
    final Directory appDocDirFolder = await folderUnderAppDir(folderNameParam);
    List<File> allFiles = [];
    appDocDirFolder.list().forEach((element) {
      File file = File(element.path);
      allFiles.add(file);
    });

    allFiles.sort((a, b) {
      return b.lastModifiedSync().compareTo(a.lastModifiedSync());
    });

    return allFiles;
  }

  Future<String> saveStringFile(String contents, String fileName) async {
    File newFile = await _createFile(fileName, importedDataFolderName);
    newFile.writeAsStringSync(contents);
    return newFile.path;
  }

  Future<String> saveBytesFile(Uint8List bytes, String fileName) async {
    File newFile = await _createFile(fileName, imagesFolderName);
    newFile.writeAsBytesSync(bytes);
    return newFile.path;
  }

  Future<bool> deleteFile(String folderName, String fileName) async {
    String filePath = await _formFileName(fileName, folderName);
    File file = File(filePath);
    file.deleteSync();
    return true;
  }

  Future<Directory> folderUnderAppDir(String folderName) async {
    // Get this App Document Directory
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    // App Document Directory + folder name
    final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName/');

    return appDocDirFolder;
  }

  Future<String> _formFileName(String fileName, String folderNameParam) async {
    final Directory requiredFolder = await folderUnderAppDir(folderNameParam);
    // requiredFolder.path ends with a "/", so we don't need "/" between path and file name
    String filePathAndName = "${requiredFolder.path}$fileName";
    return filePathAndName;
  }

  Future<File> _createFile(String fileName, String folderNameParam) async {
    String newFilePathAndName = await _formFileName(fileName, folderNameParam);
    File newFile = new File(newFilePathAndName);
    return newFile;
  }
}
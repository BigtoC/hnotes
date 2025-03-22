import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FolderRepository {
  Future<String> createFolderInAppDocDir(String folderNameParam) async {
    // App Document Directory + folder name
    final Directory appDocDirFolder = await folderUnderAppDir(folderNameParam);

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
      return appDocDirNewFolder.path;
    }
  }

  Future<List<File>> loadAllFilesInFolder(String folderNameParam) async {
    final Directory appDocDirFolder = await folderUnderAppDir(folderNameParam);
    List<File> allFiles = [];
    appDocDirFolder.listSync().forEach((element) {
      File file = File(element.path);
      allFiles.add(file);
    });

    allFiles.sort((a, b) {
      return b.lastModifiedSync().compareTo(a.lastModifiedSync());
    });

    return allFiles;
  }

  Future<bool> deleteFile(String folderName, String fileName) async {
    String filePath = await _formFileName(fileName, folderName);
    File file = File(filePath);
    file.deleteSync();
    return true;
  }

  Future<Directory> folderUnderAppDir(String folderName) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    final Directory appDocDirFolder = Directory('${appDocDir.path}/$folderName/');

    return appDocDirFolder;
  }

  Future<String> _formFileName(String fileName, String folderNameParam) async {
    final Directory requiredFolder = await folderUnderAppDir(folderNameParam);
    // requiredFolder.path ends with a "/", so we don't need "/" between path and file name
    String filePathAndName = "${requiredFolder.path}$fileName";
    return filePathAndName;
  }

  Future<File> createFile(String fileName, String folderNameParam) async {
    String newFilePathAndName = await _formFileName(fileName, folderNameParam);
    File newFile = File(newFilePathAndName);
    return newFile;
  }
}

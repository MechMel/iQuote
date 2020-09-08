import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

//enum FileLocation { SAVE, EXPORT }
enum FileDataType { BYTES, STRING }

class AHDiskController {
  static bool diskControllerHasBeenSetup = false;
  static Directory _saveDirectory;
  static String get _saveDirectoryPath {
    return _saveDirectory.path +  "/";
  }
  static Directory _tempExportDirectory;
  static String get _tempExportDirectoryPath {
    return _tempExportDirectory.path +  "/";
  }
  /*static Map<FileLocation, Directory> _directories = Map();
  static Map<FileLocation, String> get _directoryPaths {
    String saveDirectoryPath = _directories[FileLocation.SAVE].path + "/";
    String exportDirectoryPath = _directories[FileLocation.EXPORT].path + "/";
    return {FileLocation.SAVE: saveDirectoryPath, FileLocation.EXPORT: exportDirectoryPath};
  }*/

  // Setup Functions
  static Future setupAHDiskController() async {
    log("starting disk setup");
    try {
      _saveDirectory = await getApplicationDocumentsDirectory();
      if (Platform.isIOS) {
        _tempExportDirectory = _saveDirectory;
      } else {
        _tempExportDirectory = await getExternalStorageDirectory();
      }
      /*_directories[FileLocation.SAVE] = await getApplicationDocumentsDirectory();
      _directories[FileLocation.EXPORT] = await getExternalStorageDirectory();*/
      diskControllerHasBeenSetup = true;
    } catch (e) {
      log(e.toString());
    }
    log("disk setup complete");
  }

  // File getter functions
  static List<String> getSavedFileNamesFromFileExtension(String fileExtension) {
    List<String> matchingFileNames = List();
    //List<FileSystemEntity> allSavedFiles = _directories[FileLocation.SAVE].listSync();
    List<FileSystemEntity> allSavedFiles = _saveDirectory.listSync();

    allSavedFiles.forEach((savedFile) {
      if (Path.extension(savedFile.path) == fileExtension) {
        matchingFileNames.add(Path.basename(savedFile.path));
      }
    });

    return matchingFileNames;
  }

  static File _getFile(String fileName/*, FileLocation fileLocation*/) {
    return File(_saveDirectoryPath + fileName);
    //return File(_directoryPaths[fileLocation] + fileName);
  }

  // File delete functions
  static void deleteSavedFile(String fileName) {
    _deleteFile(fileName, /* FileLocation.SAVE */);
  }
  
  static void deleteExportedFile(String fileName) {
    _deleteFile(fileName, /* FileLocation.EXPORT */);
  }

  static void _deleteFile(String fileName/*, FileLocation fileLocation*/) {
    File file = _getFile(fileName, /* fileLocation */);

    if (file.existsSync()) {
      file.delete();
    }
  }

  // Read Functions
  static Uint8List loadFileAsBytes(String fileName) {
    return _readBytesFile(fileName, /* FileLocation.SAVE */);
  }
  
  static String loadFileAsString(String fileName) {
    return _readStringFile(fileName, /* FileLocation.SAVE */);
  }
  
  static Uint8List importFileAsBytes(String fileName) {
    return _readBytesFile(fileName, /* FileLocation.EXPORT */);
  }

  static String importFileAsString(String fileName) {
    return _readStringFile(fileName, /* FileLocation.EXPORT */);
  }
  
  static Uint8List _readBytesFile(String fileName,  /* FileLocation fileLocation */) {
    File file = _getFile(fileName, /* fileLocation */);

    if (file.existsSync()) {
      return file.readAsBytesSync();
    } else {
      return null;
    }
  }
  
  static String _readStringFile(String fileName,  /* FileLocation fileLocation */) {
    File file = _getFile(fileName, /* fileLocation */);

    if (file.existsSync()) {
      return file.readAsStringSync();
    } else {
      return null;
    }
  }

  // Write Functions
  static String saveFileAsBytes(String fileName,  Uint8List bytes) {
    return _writeFileAsBytes(fileName, /* FileLocation.SAVE, */ bytes);
  }
  
  static String saveFileAsString(String fileName,  String contents) {
    return _writeFileAsString(fileName, /* FileLocation.SAVE, */ contents);
  }
  
  static String exportFileAsBytes(String fileName,  Uint8List bytes) {
    //return _writeFileAsBytes(fileName, /* FileLocation.EXPORT, */ bytes);
    File file =  File(_tempExportDirectoryPath + fileName);

    file.writeAsBytesSync(bytes);
    return file.path;
  }

  static String exportFileAsString(String fileName,  String contents) {
    //return _writeFileAsBytes(fileName, /* FileLocation.EXPORT, */ bytes);
    File file =  File(_tempExportDirectoryPath + fileName);

    file.writeAsStringSync(contents);
    return file.path;
  }
  
  static String _writeFileAsBytes(String fileName,  /* FileLocation fileLocation, */ Uint8List bytes) {
    File file = _getFile(fileName, /* fileLocation */);

    file.writeAsBytesSync(bytes);
    return file.path;
  }
  
  static String _writeFileAsString(String fileName,  /* FileLocation fileLocation, */ String contents) {
    File file = _getFile(fileName, /* fileLocation */);

    file.writeAsStringSync(contents);
    return file.path;
  }
}
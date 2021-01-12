import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WritingData{

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/PrivateKey.json');
  }

  Future<void> createFile(Map<String,dynamic> content) async {
    final dir = await localFile;
    File file = new File(dir.path);
    file.createSync();
    await file.writeAsString(jsonEncode(content));
  }


  Future<Map<String,dynamic>> readData() async {
    final dir = await localFile;
    File jsonFile = File(dir.path);
    Map<String,dynamic> jsonFileContent = jsonDecode(
        await jsonFile.readAsString());
    return jsonFileContent;
  }

}
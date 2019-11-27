  
  
  import 'package:path_provider/path_provider.dart';
  import 'dart:io';
  
  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<int> readToken() async {
  try {
    final file = await tokenFile;

    // Read the file.
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0.
    return 0;
  }
}

Future<File> get tokenFile async {
  final path = await _localPath;
  return File('$path/token.txt');
}

Future<File> get refreshFile async {
  final path = await _localPath;
  return File('$path/refresh.txt');
}

Future<File> writeToken(String token) async {
  final file = await tokenFile;

  // Write the file.
  return file.writeAsString('$token');
}

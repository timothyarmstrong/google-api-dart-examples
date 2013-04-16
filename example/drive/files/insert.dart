import 'dart:async';
import 'dart:html';
import 'dart:utf';
import 'dart:crypto';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

Future<API.File> insertFile(API.Drive driveApi, String title, String description, String parentId, String mimeType, String fileContents) {
  var completer = new Completer();
  var file = new API.File.fromJson({});
  file.title = title;
  file.description = description;
  file.mimeType = mimeType;

  if (parentId != null) {
    parent = new API.ParentReference();
    parent.id = parentId;
    file.parents = [parentId];
  }

  driveApi.files.insert(file, content: fileContents)
    .then((newFile) {
      completer.complete(newFile);
    })
    .catchError((e) {
      completer.completeError(e);
    });

  return completer.future;
}

void insert_file(drive, String title, String description, String mimeType, String fileContents) {
  
  var body = {
    'title': title,
    'description': description,
    'mimeType': mimeType
  };

  var encodedContents = CryptoUtils.bytesToBase64(encodeUtf8(fileContents));
  
  API.File file = new API.File.fromJson(body);
  drive.files.insert(file, content: encodedContents, contentType: mimeType).then((API.File newFile){
    print("Created File:  <a target='_blank' href='${newFile.alternateLink}'>${newFile.title}</a>");
  });
}

void insert2(drive) {
  var contentType = 'application/octet-stream';
  var base64Data = window.btoa("Hello world");
  var newFile = new API.File.fromJson({"title": 'the_filename', "mimeType": contentType});
  print("Uploading file...<br>");
  drive.files.insert(newFile, content: base64Data, contentType: contentType)
    .then((data) {
      print("Uploaded file with ID <a href=\"${data.alternateLink}\" target=\"_blank\">${data.id}</a><br>");
    })
    .catchError((e) {
      print("$e<br>");
      return true;
    });
}

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [API.Drive.DRIVE_FILE_SCOPE, API.Drive.DRIVE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var driveApi = new API.Drive(auth);
  driveApi.makeAuthRequests = true;

  auth.login().then((Token t) {
    // insertFile(driveApi, 'My file', 'Some description', null, 'text/plain', 'This is the content')
    //   .then((f) {
    //     print(f.id);
    //   });
  //insert_file(driveApi, 'My file', 'My description', 'application/vnd.google-apps.document', 'hello!');
  insert2(driveApi);
  });
}

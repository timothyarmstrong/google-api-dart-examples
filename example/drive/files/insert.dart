import "package:google_oauth2_client/google_oauth2_browser.dart";

// START EXAMPLE

import 'dart:async';
import 'dart:html';
import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

// Insert a new file.
Future<DriveApi.File> insertFile(DriveApi.Drive service, String title, String description, String parentId, String mimeType, String fileContents) {
  var completer = new Completer();

  var newFile = new DriveApi.File.fromJson({
    'title': title,
    'description': description,
    'mimeType': mimeType
  });

  if (parentId != null) {
    parent = new DriveApi.ParentReference.fromJson({
      'id': parentId
    });
    newFile.parents = [parentId];
  }

  service.files.insert(newFile, content: window.btoa(fileContents))
    .then((data) {
      completer.complete(data);
    })
    .catchError((e) {
      completer.completeError(e);
    });

  return completer.future;
}

// END EXAMPLE

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [DriveApi.Drive.DRIVE_FILE_SCOPE, DriveApi.Drive.DRIVE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var service = new DriveApi.Drive(auth);
  service.makeAuthRequests = true;

  auth.login().then((Token t) {
    insertFile(service, 'My file', 'Some description', null, 'text/plain', 'This is the content')
      .then((file) {
        print(file.alternateLink);
      })
      .catchError((e) {
        print(e);
      });
  });
}

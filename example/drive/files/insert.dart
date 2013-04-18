import 'dart:async';
import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as API;
import "package:google_oauth2_client/google_oauth2_browser.dart";

Future<API.File> insertFile(API.Drive driveApi, String title, String description, String parentId, String mimeType, String fileContents) {
  var completer = new Completer();

  var newFile = new API.File.fromJson({
    'title': title,
    'description': description,
    'mimeType': mimeType
  });

  if (parentId != null) {
    parent = new API.ParentReference.fromJson({
      'id': parentId
    });
    newFile.parents = [parentId];
  }

  driveApi.files.insert(newFile, content: window.btoa(fileContents))
    .then((data) {
      completer.complete(data);
    })
    .catchError((e) {
      completer.completeError(e);
    });

  return completer.future;
}

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [API.Drive.DRIVE_FILE_SCOPE, API.Drive.DRIVE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var driveApi = new API.Drive(auth);
  driveApi.makeAuthRequests = true;

  auth.login().then((Token t) {
    insertFile(driveApi, 'My file', 'Some description', null, 'text/plain', 'This is the content')
      .then((file) {
        print(file.alternateLink);
      })
      .catchError((e) {
        print(e);
      });
  });
}

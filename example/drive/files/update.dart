import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'dart:async';
import 'dart:html';
import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

// Update an existing file's metadata and content.
Future<DriveApi.File> updateFile(DriveApi.Drive service, String fileId, String newTitle, String newDescription, String newMimeType, String newContent, bool newRevision) {
  var completer = new Completer();

  // First retrieve the file from the API.
  service.files.get(fileId)
    .then((file) {
      // Update the retrieved file.
      file.title = newTitle;
      file.description = newDescription;
      file.mimeType = newMimeType;
      return service.files.update(file, fileId, content: window.btoa(newContent), newRevision: newRevision);
    })
    .then((file) {
      completer.complete(file);
    })
    .catchError((e) {
      completer.completeError(e);
    });

  return completer.future;
}

// END EXAMPLE

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [DriveApi.Drive.DRIVE_SCOPE, DriveApi.Drive.DRIVE_FILE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var service = new DriveApi.Drive(auth);
  service.makeAuthRequests = true;

  auth.login().then((Token t) {
    var l = service.files.list(maxResults: 1, q: 'title = "document.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        updateFile(service, items[0].id, 'document.txt', 'Some description', 'text/plain', (new DateTime.now()).toString(), true)
          .then((_) {
            print('file updated');
          })
          .catchError((e) {
            print(e);
          });
      } else {
        print('NO FILES.');
      }
    });
  });
}

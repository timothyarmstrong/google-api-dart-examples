import 'dart:async';
import 'dart:html';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

// Rename a file.
void renameFile(DriveApi.Drive service, fileId, newTitle) {
  var f = new DriveApi.File.fromJson({
    'title': newTitle
  });
  service.files.patch(f, fileId)
    .then((patchedFile) {
      print('New title: ${patchedFile.title}');
    })
    .catchError((e) {
      print(e);
    });
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
        renameFile(service, items[0].id, 'Hello');
      } else {
        print('NO FILES.');
      }
    });
  });
}

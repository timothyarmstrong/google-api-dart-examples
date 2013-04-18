import 'dart:async';
import 'dart:html';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

// Permanently delete a file, skipping the trash.
void deleteFile(DriveApi.Drive service, String fileId) {
  service.files.delete(fileId)
    .then((_) {
      print('File deleted.');
    })
    .catchError((e) {
      print(e);
    });
}

// END EXAMPLE

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [DriveApi.Drive.DRIVE_FILE_SCOPE, DriveApi.Drive.DRIVE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var service = new DriveApi.Drive(auth);
  service.makeAuthRequests = true;

  auth.login().then((Token t) {
    var l = service.files.list(maxResults: 1, q: 'title = "deletable-test-file.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        deleteFile(service, items[0].id);
      } else {
        print('NO FILES.');
      }
    });
  });
}

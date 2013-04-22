import 'dart:async';
import 'dart:html' hide File;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

/// Copy an existing file.
void copyFile(DriveApi.Drive service, String fileId, String copyTitle) {
  var file = new DriveApi.File.fromJson({
    'title': copyTitle
  });
  service.files.copy(file, fileId)
    .then((copiedFile) {
      print('File copied here: ${copiedFile.alternateLink}');
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
    var l = service.files.list(maxResults: 1, q: 'title = "document.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        copyFile(service, items[0].id, 'deletable-test-file.txt');
      } else {
        print('NO FILES.');
      }
    });
  });
}

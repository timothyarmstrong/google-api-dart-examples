import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

void copyFile(API.Drive driveApi, String fileId, String copyTitle) {
  var f = new API.File.fromJson({
    'title': copyTitle
  });
  driveApi.files.copy(f, fileId)
    .then((copiedFile) {
      print(copiedFile.alternateLink);
    })
    .catchError((e) {
      print(e);
    });
}

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [API.Drive.DRIVE_FILE_SCOPE, API.Drive.DRIVE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var driveApi = new API.Drive(auth);
  driveApi.makeAuthRequests = true;

  auth.login().then((Token t) {
    var l = driveApi.files.list(maxResults: 1, q: 'title = "document.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        copyFile(driveApi, items[0].id, 'deletable-test-file.txt');
      } else {
        print('NO FILES.');
      }
    });
  });
}

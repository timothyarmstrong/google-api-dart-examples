import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

void restoreFile(API.Drive driveApi, String fileId) {
  driveApi.files.untrash(fileId)
    .then((_) {
      print('File restored.');
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
    var l = driveApi.files.list(maxResults: 1, q: 'title = "deletable-test-file.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        restoreFile(driveApi, items[0].id);
      } else {
        print('NO FILES.');
      }
    });
  });
}

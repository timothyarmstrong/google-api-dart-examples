import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

void renameFile(API.Drive driveApi, fileId, newTitle) {
  var f = new API.File.fromJson({
    'title': newTitle
  });
  driveApi.files.patch(f, fileId)
    .then((patchedFile) {
      print('New title: ${patchedFile.title}');
    })
    .catchError((e) {
      print(e);
    });
}

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [API.Drive.DRIVE_SCOPE, API.Drive.DRIVE_FILE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var driveApi = new API.Drive(auth);
  driveApi.makeAuthRequests = true;

  auth.login().then((Token t) {
    var l = driveApi.files.list(maxResults: 1, q: 'title = "document.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        renameFile(driveApi, items[0].id, 'Hello');
      } else {
        print('NO FILES.');
      }
    });
  });
}

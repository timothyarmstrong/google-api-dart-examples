import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

Future<List<API.Permissions>> retrievePermissions(API.Drive driveApi, String fileId) {
  var completer = new Completer();

  driveApi.permissions.list(fileId)
    .then((permissions) {
      completer.complete(permissions.items);
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
    var l = driveApi.files.list(maxResults: 1, q: 'title = "permissions-test-doc"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        retrievePermissions(driveApi, items[0].id)
          .then((permissions) {
            for (var p in permissions) {
              print(p);
            }
          });
      } else {
        print('NO FILES.');
      }
    });
  });
}

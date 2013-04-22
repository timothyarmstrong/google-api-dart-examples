import 'dart:html';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'dart:async';
import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

/// Retrieve a list of permissions for a file.
Future<List<DriveApi.Permissions>> retrievePermissions(DriveApi.Drive service,
                                                       String fileId) {
  var completer = new Completer();

  service.permissions.list(fileId)
    .then((permissions) {
      completer.complete(permissions.items);
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
    var l = service.files.list(maxResults: 1, q: 'title = "permissions-test-doc"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        retrievePermissions(service, items[0].id)
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

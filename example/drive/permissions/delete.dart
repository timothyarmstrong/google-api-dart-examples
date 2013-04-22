import 'dart:async';
import 'dart:html';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

/// Remove a permission.
void removePermission(DriveApi.Drive service, String fileId, String permissionId) {
  service.permissions.delete(fileId, permissionId)
    .then((_) {
      print('Permission deleted.');
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
    var l = service.files.list(maxResults: 1, q: 'title = "permissions-test-doc"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        service.permissions.list(items[0].id)
          .then((permissionList) {
            for (var p in permissionList.items) {
              if (p.id == 'anyoneWithLink') {
                removePermission(service, items[0].id, p.id);
                return;
              }
            }
            print('Could not find the anyoneWithLink permission. ${list.items[0].alternateLink}');
          });
      } else {
        print('NO FILES.');
      }
    });
  });
}

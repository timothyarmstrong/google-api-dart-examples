import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

// newRole: "owner", "writer", "reader".
void updatePermission(API.Drive driveApi, String fileId, String permissionId, String newRole) {
  var patchedPermission = new API.Permission.fromJson({
    'role': newRole
  });

  // First retrieve the permission from the API.
  driveApi.permissions.get(fileId, permissionId)
    .then((permission) {
      // Update the retrieved permission.
      permission.role = newRole;
      return driveApi.permissions.update(permission, fileId, permissionId);
    })
    .then((_) {
      print('Permission updated.');
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
    var l = driveApi.files.list(maxResults: 1, q: 'title = "permissions-test-doc"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        driveApi.permissions.list(items[0].id)
          .then((permissionList) {
            for (var p in permissionList.items) {
              if (p.id == 'anyoneWithLink') {
                updatePermission(driveApi, items[0].id, p.id, 'writer');
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

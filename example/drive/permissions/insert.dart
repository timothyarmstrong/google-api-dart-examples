import 'dart:async';
import 'dart:html';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

/// Add a permission to a file.
/// [value] is the email address or domain name for the permission. [type] can
/// be "user", "group", "domain", or "default". [role] can be "owner", "writer",
/// or "reader".
void insertPermission(DriveApi.Drive service, String fileId, String value,
                      String type, String role) {
  var permission = new DriveApi.Permission.fromJson({
    'value': value,
    'type': type,
    'role': role
  });
  service.permissions.insert(permission, fileId)
    .then((permission) {
      print('Created permission with id ${permission.id}');
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
        insertPermission(service, items[0].id, 'timothyspam@gmail.com', 'user', 'writer');
        print(list.items[0].alternateLink);
      } else {
        print('NO FILES.');
      }
    });
  });
}

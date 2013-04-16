import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

// TODO: Describe valid options.
void insertPermission(API.Drive driveApi, String fileId, String value, String type, String role) {
  var permission = new API.Permission.fromJson({
    'value': value,
    'type': type,
    'role': role
  });
  driveApi.permissions.insert(permission, fileId)
    .then((permission) {
      print('Created permission with id ${permission.id}');
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
        insertPermission(driveApi, items[0].id, 'timothyspam@gmail.com', 'user', 'writer');
      } else {
        print('NO FILES.');
      }
    });
  });
}

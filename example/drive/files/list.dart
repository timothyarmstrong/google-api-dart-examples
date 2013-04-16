import 'dart:async';
import 'dart:html';

import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as API;
import 'package:google_oauth2_client/google_oauth2_browser.dart';

Future<List<API.File>> retrieveAllFiles(API.Drive driveApi) {
  var completer = new Completer();
  List<API.File> files = [];

  void retrievePageOfFiles(request) {
    request
      .then((list) {
        if (list.items.length > 0) {
          files.addAll(list.items);
        }
        if (list.nextPageToken == null) {
          completer.complete(files);
        } else {
          var request = driveApi.files.list(pageToken: list.nextPageToken);
          retrievePageOfFiles(request);
        }
      })
      .catchError((e) {
        completer.completeError(e);
      });
  }

  var initialRequest = driveApi.files.list();
  retrievePageOfFiles(initialRequest);

  return completer.future;
}

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [API.Drive.DRIVE_FILE_SCOPE, API.Drive.DRIVE_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var driveApi = new API.Drive(auth);
  driveApi.makeAuthRequests = true;

  auth.login().then((Token t) {
    retrieveAllFiles(driveApi)
      .then((files) {
        for (var f in files) {
          print(f.title);
        }
      });
  });
}

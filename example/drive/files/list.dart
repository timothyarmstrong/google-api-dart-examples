import 'dart:html';

import 'package:google_oauth2_client/google_oauth2_browser.dart';

// START EXAMPLE

import 'dart:async';
import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

// Retrieve a list of File resources.
Future<List<DriveApi.File>> retrieveAllFiles(DriveApi.Drive service) {
  var completer = new Completer();
  List<DriveApi.File> files = [];

  void retrievePageOfFiles(request) {
    request
      .then((list) {
        if (list.items.length > 0) {
          files.addAll(list.items);
        }
        if (list.nextPageToken == null) {
          completer.complete(files);
        } else {
          var request = service.files.list(pageToken: list.nextPageToken);
          retrievePageOfFiles(request);
        }
      })
      .catchError((e) {
        completer.completeError(e);
      });
  }

  var initialRequest = service.files.list();
  retrievePageOfFiles(initialRequest);

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
    retrieveAllFiles(service)
      .then((files) {
        for (var f in files) {
          print(f.title);
        }
      });
  });
}

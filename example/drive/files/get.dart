import 'dart:async';
import 'dart:html';

import 'package:google_api_drive_v2/drive_v2_api_browser.dart';
import 'package:google_oauth2_client/google_oauth2_browser.dart';

void printFile(DriveApi driveApi, fileId) {
  driveApi.files.get(fileId)
    .then((file) {
      print('Title: ${file.title}');
      print('Description: ${file.description}');
      print('MIME type: ${file.mimeType}');
    })
    .catchError((e) {
      print(e);
    });
}

Future<String> downloadFile(driveApi, auth, file) {
  var completer = new Completer();
  var downloadUrl = file.downloadUrl;
  if (downloadUrl != null) {
    var request = new HttpRequest();
    request.onLoad.listen((response) {
      completer.complete(request.responseText);
    }, onError: (e) {
      completer.completeError(e);
    });
    request.open('GET', downloadUrl);
    auth.authenticate(request).then((request) => request.send());
  } else {
    // The file doesn't have any content stored on Drive.
    return completer.complete(null);
  }
  return completer.future;
}

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [DriveApi.DRIVE_READONLY_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var driveApi = new DriveApi(auth);
  driveApi.makeAuthRequests = true;

  auth.login().then((Token t) {
    var l = driveApi.files.list(maxResults: 1, q: 'title = "document.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        printFile(driveApi, items[0].id);

        driveApi.files.get(items[0].id).then((file) {
          downloadFile(driveApi, auth, file).then((content) {
            print(content);
          });
        });
      } else {
        print('NO FILES.');
      }
    });
  });
}

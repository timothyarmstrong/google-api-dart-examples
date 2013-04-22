import 'dart:html';

// START EXAMPLE

import 'dart:async';
import 'package:google_oauth2_client/google_oauth2_browser.dart';
import 'package:google_drive_v2_api/drive_v2_api_browser.dart' as DriveApi;

/// Print a file's metadata.
void printFile(DriveApi.Drive service, fileId) {
  service.files.get(fileId)
    .then((file) {
      print('Title: ${file.title}');
      print('Description: ${file.description}');
      print('MIME type: ${file.mimeType}');
    })
    .catchError((e) {
      print(e);
    });
}

/// Download a file's content.
Future<String> downloadFile(DriveApi.Drive service, GoogleOAuth2 auth, File file) {
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

// END EXAMPLE

void main() {
  var clientId = '938589624680.apps.googleusercontent.com';
  var scopes = [DriveApi.Drive.DRIVE_READONLY_SCOPE];
  
  var auth = new GoogleOAuth2(clientId, scopes);
  
  var service = new DriveApi.Drive(auth);
  service.makeAuthRequests = true;

  auth.login().then((Token t) {
    var l = service.files.list(maxResults: 1, q: 'title = "document.txt"');
    l.then((list) {
      var items = list.items;
      if (items.length > 0) {
        printFile(service, items[0].id);

        service.files.get(items[0].id).then((file) {
          downloadFile(service, auth, file).then((content) {
            print(content);
          });
        });
      } else {
        print('NO FILES.');
      }
    });
  });
}

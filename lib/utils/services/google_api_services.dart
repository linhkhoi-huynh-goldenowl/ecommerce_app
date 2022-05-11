import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class GoogleApiServices {
  static Future<AuthClient> obtainAuthenticatedClient() async {
    final String response =
        await rootBundle.loadString('assets/json/app_firebase.json');
    final data = await json.decode(response);
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": data["private_key_id"],
      "private_key": data["private_key"],
      "client_email": data["client_email"],
      "client_id": data["client_id"],
      "type": data["type"]
    });
    var scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);
    return client; // Remember to close the client when you are finished with it.
  }
}

import 'package:googleapis_auth/auth_io.dart';

class GoogleApiServices {
  static Future<AuthClient> obtainAuthenticatedClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": "7cbe34e93437a1a84eee75c6b919b7519d33d960",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCzBFjwinvPn5Tw\nXZW71k9MpcqPl7NFpEibG54RqN11A/CnIzWNcBHcbJf0T5a7mjvNx1V7SIQAU0Z2\nP3fNof6mEOADbM3jPlT0IL83ln2oL/vzVmharV5NgUsHwIX0zrHTYqmrayHUldPv\nq/B0tyqC3Nc0MsAXk42txDWEX/MD3ddAhz+ng55rseJDG0gdgGmAmil0ekUZPtBm\ng7Y5AVSkdqVi8DYi8BrXr4vPUaJ+69Q1Gd1vUJ52XTuewKoI7eQavH7cAh5ja0/V\nxfQF29Unpr7Kei0xiAmS+IjS9mBPVDdViZNdD7fQcE7clsD023EH0qh2mFI3pzK7\n75AQ5DDHAgMBAAECggEAFrYd/IJtO8WQtUACP57sV5qPDNGfrl2t0nPaBX6Jfg9+\naA34/NUzhuYGDzpLsshZ/vzjlOz5xjrKbTUXI3ECaBoq+XRD2KkvSPugltJSZdSU\nn+Yd/icRmD6ngLfFpu3UNK/HO9avJ5PMnBMRwhT84TZYXSh1I2iWaG3EpmMv5xT2\nvzSU7Lxx5tbD+h6uGvsm1P+Qd0N/SdnleJKUILfoXdabAG0vdSLnIsTsDV7hd9j5\nvFxmppDWeVYyTZvLR3FFMOibvvi9F+JrpV5FIFhFNeugKvrhbt9SsBIbxeUD0Ar8\nGRDnXiZZgTaTju+d4YBsxcEcLxBljp+QdUm76LEY2QKBgQDyJVi7BtvSdPF5NIR/\n9dmV275oaCzgolwb0G5dHBczHql44WP0DjY4BHyL7D05XuT4WoH0j0sHTzUp///S\nB811jVRv1FL9pbNwgWEHYf0i/+fJ7jWKRSyYD6pfIpnq3Lj4d+atIb3j66EqWorn\n6Ik676l1UAVEGx0yhB1voKh/yQKBgQC9Ql3iQ6jW3rsHIl3Qbqzh9N5Lm0JuA4rG\nnVFCKmJI4SugNlqdDeUnBMTHQYdiSGTHpUL56wt8RK2w+kW4PNdw5vrELZYn0aOB\nDvdgDSSGZbr7XoGt8CrPNXm8I7SaXNQ7lcntW5x46JvyUhIakJGBma5SCuxDo3h+\nlULjM0EUDwKBgHXCs+RA8aboOIc5gza32ZmHxJICF9EnJKRiOUoO3zl9L+4ZrwKB\n5txXUjq6KQw9mh0t5wWIqnRjkPdcCI2cPc9tbCL2n2W7sAiG4ykz/meHDLKnpmIY\nQhexhqm9qh0OOuabaRPJ1Q+DCF4Qqn0eGZ8P7tmekPEOPqTSm34uI8QBAoGBAKEa\nXGadp5x4boZNJ8SkYX/afFuppyuU0k3tXl1PTOiy2/r+KbYlPNoxAfyHeGIeM8OK\nlu+8t8Mphxzufeitycquo+nY0EfG+UKD5emaZmwNLtSJByR0G0zVPXH8huEbggHS\nqNfmstRtVUo5uHVqeKH0muH1sFaHUauXDR/v4kbbAoGAFUJeBH9FeTmgU8CJqbv9\nCW4GUsq27Ac1PeAXUTmr1cviqDDx1a8dHf3724INxTg1PDKp35OUJwmiK7Rf6m7a\n4wHJulCJnHstJ9TBYzrCUthmWS7GqFisq2Sj7CDQEoCsZqu1vQGwn9Sv2iOVgl7h\n0wpUQ4TcYsFkSCxooOIjpao=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-x9puh@ecommerce-b1436.iam.gserviceaccount.com",
      "client_id": "116276515110206572726",
      "type": "service_account"
    });
    var scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);
    return client; // Remember to close the client when you are finished with it.
  }
}

/*import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "usay-f2cb1",
          "private_key_id": "3dd550d6ae2c078dbb3ec59867176a929565b46f",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCo26hSbO679Vp3\nurhB+HW71Y1lnuXI3jJZfCFgvQERe08FVe/Sj0PPTq7PwWMfj1bnHAiXsqPTBCvU\nDQvKQzcUNcdF3KJtD8hLe1UyGvk0IcbQijV/SxxomMDL2UaZRiDiMGbzvly3rwrM\nr/C32qxJpFROn6oEznvC1ZvMFar2Lttr25RfjcSm6YrwsrxHe9aziZgXQ109zy0R\n5f+M67w8WzQM/XKB27BOnF8HSkX+I9ym4F7JA7SVXNLMXjRRwK2EQM67gJGrrgY/\n/vyjHmSSZnQrj14t2uzi1LChD4UJHjsD7fHLSfPwb/q4BDDs73GJ/CV0SrrFAvdA\n/ialXHzdAgMBAAECggEAAnIP+YWiCC8xAhE+ZZeIyPwk90b6XVLj2B+anNE6neYI\ndR4orNwt/LzPKQDMLo2qZ2AkuwxiIAZsRhQcSsUiG+pSz68MMS0sgZ9bKAXI/IQi\nt4F7mIjeHqEGZc1ontlWVOr44BMuj5XQP7pVRQG8mLfHECPILW1PezkRxRO+l/XR\nYfS/HBF0W++XobXgsrCPPrmwzowcnMnl6fksH4TCqIWvQsQBisUbSYWBg3IunLry\nAFL4cveHi7MOKgdwP44jj+Y/YF5F/JIIMuC50O48rj9CFg0jQcq5maKbpOihpE5K\nh2MNoTclpTWMCIF3ttFPDHmN+xbd7uyTfjBd0enKAQKBgQDmtyPbpKWHfk/KNXlO\nyilEgS6ZeASmW9m9Y8kw2B/NM0QnmtwSTDgCK/sibqd5F/qxPSRibZN368KYv/Fj\n2U5YJqnND4Qmc31NT+rJ3iOgTUJok2r11O92HSIAH/kYQysHmZjbJ1f6IHGABLzN\npTcdH8RqCzhYxQ8VfyYFznCB3QKBgQC7XRJqm+sLpr+J/Qf15lmlZ3X0+7AKHXjS\nBjHRnx3JvUEAjApeETu8h7yxWUqLYhPBTJz8PTyVg+fZpjjdghjCDGnYdv4ThBBU\nXDVGgYmjXqUaB73sqMJFuQKsUblceQLA9xlX1nx2863FQs83sKGTRVRVVMtxYnv5\nGwV7boO3AQKBgQCKhSKuWShZNWlKitiOiapFSxpjYj/IchVFNIgzH0/YsBMXhE7l\nXYWzKBzcC3vZpKALkh4qSofj1FU9yOBxhqMXIf+I8uvw+h4dMQJSuWDCeiCJERmD\nB5nOXKdxU8EG5C0Nnxa7Xd/geWIr7qw8/BkfD1eqI5ptEcOAsJpvmgbKsQKBgAR+\ngwaTntu0sDt7GknHsLbK+IVb1Ckp88/13hQNIQXJyFlfApCnESvAhcIrRiJ5w8eL\nMujJ/z4G3/TUi+CkUju1WIScthN5w3qCi7SZPtfwWT16mg+nLKHHgkzn2O5i6LIA\nO1dkCbBAwBZPN/E6B2Yk75TsZ8Tce+TJxSPkzrwBAoGBAIQoXvXuDYfmbflAj3ks\nhRmUIn+b2kD6mh9Ixs+gDZkkAHyKlOsP/pejqkjEWo1GKg0YEU0bg+KjaCT/NBD5\nU7piRgRqwI1RiMgu57P7oeFbtcx57cqn8FV3b0BsFDs8DxPWVHSNqF+9Jsx6RHip\nN7ar7Q+KA+xYPBB7xWDLakDO\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-g3xu7@usay-f2cb1.iam.gserviceaccount.com",
          "client_id": "101680208191608447789",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-g3xu7%40usay-f2cb1.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }
        ),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}*/
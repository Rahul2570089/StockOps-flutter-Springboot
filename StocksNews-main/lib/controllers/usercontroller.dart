import 'dart:convert';

import 'package:newsapp/Models/user.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/auth/config.dart';

class UserController {
  static Future<User> createUser(String email, String password) async {
    try {
      var user = {
        "email": email,
        "password": password,
      };

      var response = await http.post(Uri.parse("${url}users/create"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(user));
      var jsonResponse = jsonDecode(response.body.toString());
      if (jsonResponse['id'] != null) {
        var response2 = await http.get(
          Uri.parse(
              "$url/users/session/create/${jsonResponse['id']}/${jsonResponse['email']}/${jsonResponse['password']}"),
          headers: {"Content-Type": "application/json"},
        );
        var jsonResponse2 = jsonDecode(response2.body.toString());
        if (jsonResponse2 != null) {
          return User(jsonResponse['email'], jsonResponse['password'],
              jsonResponse['id']);
        } else {
          return User(null, null, null);
        }
      } else {
        return User(null, null, null);
      }
    } catch (e) {
      return User(null, null, null);
    }
  }

  static Future<User> loginUser(String email, String password) async {
    try {
      var response = await http.get(
        Uri.parse("$url/api/users/allusers"),
        headers: {"Content-Type": "application/json"},
      );
      var jsonResponse = jsonDecode(response.body.toString());
      if (jsonResponse != null) {
        List<dynamic> users = jsonResponse;
        for (var element in users) {
          if (element['email'] == email && element['password'] == password) {
            var response2 = await http.get(
              Uri.parse(
                  "${url}session/create/${jsonResponse['id']}/${jsonResponse['email']}/${jsonResponse['password']}"),
              headers: {"Content-Type": "application/json"},
            );
            var jsonResponse2 = jsonDecode(response2.body.toString());
            if (jsonResponse2 != null) {
            } else {
              return User(null, null, null);
            }
            return User(element['email'], element['password'], element['id']);
          }
        }
        return User(null, null, null);
      } else {
        return User(null, null, null);
      }
    } catch (e) {
      return User(null, null, null);
    }
  }

  static void logoutUser(String email) {
    // UserSimplePreferences.setToken('');
  }
}

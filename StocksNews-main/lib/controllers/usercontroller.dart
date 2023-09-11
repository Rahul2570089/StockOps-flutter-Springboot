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

      var response = await http.post(Uri.parse("${url}create"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(user));

      var jsonResponse = jsonDecode(response.body.toString());
      print(jsonResponse);
      if (jsonResponse['id'] != null) {
        return User(jsonResponse['email'], jsonResponse['password'],
            jsonResponse['id']);
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
        Uri.parse("${url}allusers"),
        headers: {"Content-Type": "application/json"},
      );
      var jsonResponse = jsonDecode(response.body.toString());
      if (jsonResponse != null) {
        List<dynamic> users = jsonResponse;
        for (var element in users) {
          if (element['email'] == email && element['password'] == password) {
            return User.fromJson(element);
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

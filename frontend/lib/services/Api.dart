import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show HttpException;

class Api {
  static const baseUrl = "http://localhost:3000/api";

  static final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static Future<Map<String, dynamic>> addPerson(Map<String, dynamic> pdata) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/add_person"),
        headers: _headers,
        body: jsonEncode(pdata),
      );

      return _handleResponse(res);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> getPerson() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/get_person"),
        headers: _headers,
      );

      return _handleResponse(res);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw HttpException(
        response.reasonPhrase ?? 'Unknown error occurred',
        uri: response.request?.url,
      );
    }
  }

  static Exception _handleError(dynamic error) {
    debugPrint("API Error: $error");
    return error is Exception ? error : Exception(error.toString());
  }

  static Future<void> updatePerson(int id, Map<String, dynamic> updatedData) async {
    var url = Uri.parse("$baseUrl/update_person/$id");

    try {
      final res = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(updatedData),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print("Data updated successfully: $data");
      } else if (res.statusCode == 404) {
        print("Person not found: ${res.reasonPhrase}");
      } else {
        print("Failed to update DATA: ${res.reasonPhrase}");
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  static Future<void> deletePerson(int id) async {
    var url = Uri.parse("$baseUrl/delete/$id");

    try {
      final res = await http.delete(url);

      if (res.statusCode == 200) {
        print("Data deleted successfully");
      } else {
        print("Failed to delete DATA: ${res.reasonPhrase}");
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }
}

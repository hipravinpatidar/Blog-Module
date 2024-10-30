import 'dart:convert';
import 'package:http/http.dart' as http;// For jsonDecode

class ApiService {
  // Method to fetch data from the API
  Future<Map<String, dynamic>?> getCategory(String url) async {
    try {
      // Perform the HTTP GET request
      final response = await http.get(Uri.parse(url));

      // Check the status code
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody;
      } else {
        // Handle non-200 status codes
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error occurred: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> getSubCategory(String url) async {
    try {
      // Perform the HTTP GET request
      final response = await http.get(Uri.parse(url));

      // Check the status code
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return jsonBody;
      } else {
        // Handle non-200 status codes
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error occurred: $e');
      return null;
    }
  }

}

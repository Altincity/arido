import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category_model.dart';

class ApiService {
  static const String apiCategoriesUrl = 'https://aridoiraq.com/blog/posts-api/';
  
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(apiCategoriesUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Category> categories = (data['data'] as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static const String apiAboutInfoUrl = 'https://aridoiraq.com/aboutus-api/';
  Future<Map<String, dynamic>> fetchAboutInfo() async {
    final response = await http.get(Uri.parse(apiAboutInfoUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load about info');
    }
  }

  static const String apiContactInfoUrl = 'https://aridoiraq.com/contacts-api/';
  Future<List<Map<String, dynamic>>> fetchContactInfo() async {
    final response = await http.get(Uri.parse(apiContactInfoUrl));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(jsonResponse['data']);
    } else {
      throw Exception('Failed to load contact info');
    }
  }

  static const String apiSlidersInfoUrl = 'https://aridoiraq.com/sliders-api/';
  Future<List<String>> fetchSliders() async {
    final response = await http.get(Uri.parse(apiSlidersInfoUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data['data'] != null && data['data'] is List) {
        List<dynamic> sliders = data['data'];
        return sliders.map((item) => item['image'] as String).toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception('Failed to load sliders');
    }
  }

  static const String apiUniversitiesInfoUrl = 'https://aridoiraq.com/universities-api/';
  Future<List<Map<String, dynamic>>> fetchUniversities() async {
    final response = await http.get(Uri.parse(apiUniversitiesInfoUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load universities');
    }
  }

  static const String apiCoursesInfoUrl = 'https://aridoiraq.com/courses-api/';
  Future<List<Map<String, dynamic>>> fetchCourses() async {
    final response = await http.get(Uri.parse(apiCoursesInfoUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to load courses');
    }
  }

  static const String apiSearchOptionsUrl = 'https://aridoiraq.com/quick-search-api/';
  Future<Map<String, List<String>>> fetchSearchOptions() async {
    final response = await http.get(Uri.parse(apiSearchOptionsUrl));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'] as Map<String, dynamic>;

      // تبدیل داده به شکل Map<String, List<String>>
      return data.map((key, value) {
        return MapEntry(key, List<String>.from(value));
      });
    } else {
      throw Exception('Failed to load search options');
    }
  }

}

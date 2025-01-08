import '../models/fitness_user.dart';
import '../models/bmi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls {

  Future<Bmi> fetchBmi(FitnessUser fitnessUser) async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': '97a29ec4c2msh2203f3649112676p142bdejsnf870ef704eea',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      "height": fitnessUser.height.toString(),
      "weight": fitnessUser.weight.toString(),
      "age": fitnessUser.age.toString(),
      "gender": fitnessUser.gender,
      "exercise": fitnessUser.exercise
      // "neck": "41",
      // "hip": "100",
      // "waist": "88",
      // "goal": "maintenance",
      // "deficit": "500",
      // "goalWeight": "85"
    };

    var request = http.Request('POST', Uri.parse(baseURL));
    request.bodyFields = payload;
    request.headers.addAll(requestHeaders);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Bmi bmi = Bmi.fromJson(jsonDecode(response.toString()));
      return bmi;
    } else {
      throw Exception('Failed to load bmi');
    }
  }

  // add exercise screen
  Future<int> fetchBurnedCalories(String activity, int weight, int duration) async {
    String baseURL = 'https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned';
    String requestURL = '$baseURL?activity=$activity&weight=$weight&duration={duration}';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'calories-burned-by-api-ninjas.p.rapidapi.com',
      'X-RapidAPI-Key': '97a29ec4c2msh2203f3649112676p142bdejsnf870ef704eea',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.get(
      Uri.parse(requestURL),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      int burnedCalories = jsonList[0]['total_calories'];
      return burnedCalories;
    } else {
      throw Exception('Failed to load calories');
    }
  }

  Future<List<String>> fetchExercises(String activity) async {
    String baseURL = 'https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned';
    String requestURL = '$baseURL?activity=$activity';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'calories-burned-by-api-ninjas.p.rapidapi.com',
      'X-RapidAPI-Key': '97a29ec4c2msh2203f3649112676p142bdejsnf870ef704eea',
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.get(
      Uri.parse(requestURL),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      List<String> exercises = jsonList.map((json) => json['name'] as String).toList();
      return exercises;
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  // TODO: additional API required
}

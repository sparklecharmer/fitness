import '../models/fitness_user.dart';
import '../models/bmi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCalls {
  String _key = ""; //PS KEY

  Future<Bmi> fetchBmi(FitnessUser fitnessUser) async {
    String baseURL = 'https://fitness-api.p.rapidapi.com/fitness';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'fitness-api.p.rapidapi.com',
      'X-RapidAPI-Key': _key,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    Map<String, String> payload = {
      "height": fitnessUser.height.toString(),
      "weight": fitnessUser.weight.toString(),
      "age": fitnessUser.age.toString(),
      "gender": fitnessUser.gender,
      "exercise": fitnessUser.exercise,
      "neck": fitnessUser.neck.toString(),
      "hip": fitnessUser.hip.toString(),
      "waist": fitnessUser.waist.toString(),
      "goal": fitnessUser.goal.toString(),
      "deficit": fitnessUser.deficit.toString(),
      "goalWeight": fitnessUser.goalWeight.toString()
    };

    print(fitnessUser.gender.runtimeType);
    print(fitnessUser.exercise.runtimeType);

    var request = http.Request('POST', Uri.parse(baseURL));
    request.bodyFields = payload;
    request.headers.addAll(requestHeaders);


    http.StreamedResponse response = await request.send();

    print(response.statusCode);
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();  // Use this to get the body as a string
      print("it went through");
      print("Response body: $responseBody");
      Bmi bmi = Bmi.fromJson(jsonDecode(responseBody));
      return bmi;
    } else {
      print("error: ${response.statusCode}");

      throw Exception('Failed to load bmi');
    }
  }

  // add exercise screen
  Future<int> fetchBurnedCalories(String activity, int weight, int duration) async {
    String baseURL = 'https://calories-burned-by-api-ninjas.p.rapidapi.com/v1/caloriesburned';
    String requestURL = '$baseURL?activity=$activity&weight=$weight&duration=$duration';

    Map<String, String> requestHeaders = {
      'X-RapidAPI-Host': 'calories-burned-by-api-ninjas.p.rapidapi.com',
      'X-RapidAPI-Key': _key,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.get(
      Uri.parse(requestURL),
      headers: requestHeaders,
    );

    //load the first instance of calories
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
      'X-RapidAPI-Key': _key,
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    final response = await http.get(
      Uri.parse(requestURL),
      headers: requestHeaders,
    );

    //load all the exercises
    if (response.statusCode == 200) {
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      List<String> exercises = jsonList.map((json) => json['name'] as String).toList();
      return exercises;
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  //food api, user input food they ate?? and then calories are added accordingly. Then in exercise page,
  //it will deduct accordingly
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schedule_generator_ai/models/task.dart';

// jembatan penghubung antara client dan server
class GeminiService {
  static const String _baseUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";
  final String apiKey;

 // ngecek didalam api key ada apa ngga
  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "Please input your API KEY" {
    if (apiKey.isEmpty) {
      throw ArgumentError("API KEY is missing");
    }
  }

  // future -> menandakan asinkronus
    Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks);
    final prompt = _buildPromt(tasks);
    try {
      // ini akan muncul di debug console
      print("Promt: \n$prompt");
      // add request time out message to avoid indefinite hangs if the API
      final response = await http
      .post(Uri.parse("$_baseUrl?key=$apiKey"), 
      headers: {
        "Content-Type": "application/json", 
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      })
      // ini time out biar requestnya gak kelamaan
      ).timeout(Duration(seconds: 20));
       // sebuah code yg letak nya setelah await itu hasil yg akan di generate setelah proses async selesai.
      return _handleResponse(response);
    } catch (e) {
      throw ArgumentError("failed to generate schedule: $e");
    }
  }

  String _handleResponse(http.Response responses) {
    final data = jsonDecode(responses.body);
    if (responses.statusCode == 401) {
      throw ArgumentError("invalid API Key or unauthorized access");
      // 429 -> to many request (limited nya abis, -> kebanyakan promt n request)
    } else if (responses.statusCode == 429) {
      throw ArgumentError("rate limited exceeded");
      // 500 -> server errror, nge crash
    } else if (responses.statusCode == 500) {
      throw ArgumentError("internal server error");
      // status tidak tersedia
    }else if (responses.statusCode == 503) {
      throw ArgumentError("service unavailable");
      // oke bos
    }else if (responses.statusCode == 200) {
      // respon yang akan dikembalikan oleh gemini
      return data ["candidates"][0]["content"]["parts"][0]["text"];

      //server / gemini mengembalikan status yang lain, error nya diluar yang kita kasih
    } else {
      throw ArgumentError("unknown error");
    }
  }

  String _buildPromt(List<Task> tasks) {
    final tasksList = tasks.map((task) => "${task.name} (Priority: ${task.priority}, Duration: ${task.duration} minute, Deadline: ${task.deadline})").join("\n");
    return "Buatkan jadwal harian yang optimal berdasarkan task berikut:\n$tasksList";
  }

  //
  void _validateTasks(List<Task> tasks) {
    if (tasks.isEmpty) throw ArgumentError("Tasks cannot be empty. please insert your promt");
  }
}

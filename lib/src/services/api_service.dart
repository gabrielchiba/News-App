import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/src/models/article.dart';
import 'package:news_app/src/notifiers/top_headlines_notifier.dart';

class ApiService {
  final endPointUrl = "newsapi.org";
  final client = http.Client();

  void printOutError(error, stacktrace) {
    debugPrint('Exception ocurred: $error with stacktrace: $stacktrace');
  }

  Future<List<Article>> getTopHeadlines() async {
    final queryParameters = {
      'country': 'us',
      'apiKey': dotenv.env['API_KEY'],
    };

    final uri = Uri.https(endPointUrl, '/v2/top-headlines', queryParameters);
    print("URL: $uri");

    try {
      final response = await client.get(uri);
      Map<String, dynamic> json = jsonDecode(response.body);
      List body = json['articles'];
      List<Article> articles = body.map((item) => Article.fromJson(item)).toList();
      return articles;

    } catch(error, stacktrace) {
      printOutError(error, stacktrace);
      return Future.error('$error');
    }
  }

  Future<List<Article>> getTopHeadlinesByCategory(String category) async {
    Map <String, String?> queryParameters = {
      'country': 'us',
      'apiKey': dotenv.env['API_KEY'],
      'category': category.toLowerCase(),
    };

    final uri = Uri.https(endPointUrl, '/v2/top-headlines', queryParameters);
    print("URL: $uri");

    try {
      final response = await client.get(uri);
      Map<String, dynamic> json = jsonDecode(response.body);
      List body = json['articles'];
      List<Article> articles = body.map((item) => Article.fromJson(item)).toList();
      return articles;

    } catch(error, stacktrace) {
      printOutError(error, stacktrace);
      return Future.error('$error');
    }
  }
}
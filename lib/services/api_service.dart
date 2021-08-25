import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article.dart';

class ApiService {
  final endPointUrl = "newsapi.org";
  final client = http.Client();

  Future<List<Article>> getArticle() async {

    final queryParameters = {
      'country': 'us',
      'category': 'technology',
      'apiKey': dotenv.env['API_KEY'],
    };
    final uri = Uri.https(endPointUrl, '/v2/top-headlines', queryParameters);
    print("URL: $uri");
    final response = await client.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);
    List body = json['articles'];
    List<Article> articles = body.map((item) => Article.fromJson(item)).toList();
    return articles;
  }
}
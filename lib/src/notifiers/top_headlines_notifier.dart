import 'package:flutter/material.dart';
import 'package:news_app/src/models/article.dart';
import 'package:news_app/src/services/api_service.dart';

class TopHeadlinesNotifier with ChangeNotifier {
  List<Article> _articleList = [];

  addArticleToList(Article article){
    _articleList.add(article);
    notifyListeners();
  }

  setArticleList(List<Article> articleList) {
    _articleList = [];
    _articleList = articleList;
    notifyListeners();
  }

  List<Article> getArticleList() {
    return _articleList;
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/components/article_list_tile.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/api_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ApiService client = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        brightness: Brightness.dark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          _buildWidgetLabelTitle(context),
          _buildWidgetSubtitle(context),
          SizedBox(height: 12.0),
          Expanded(
              child: _buildWidgetArticleList(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>null,
        tooltip: 'Set Notification',
        child: Icon(Icons.notifications),
      ),
    );
  }

  Widget _buildWidgetArticleList(BuildContext context) {
    return FutureBuilder(
      future: client.getTopHeadlines(),
      builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
        if (snapshot.hasData) {
          List<Article>? articles = snapshot.data;
          return SizedBox(
            child: ListView.builder(
              itemCount: articles!.length,
              itemBuilder: (context, index) =>
                  articleListTile(articles[index]),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildWidgetLabelTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Latest News',
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.subtitle2!.merge(
          TextStyle(
            fontSize: 18.0,
            color: Color(0xFF325384).withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetSubtitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Top stories at the moment',
        style: Theme.of(context).textTheme.caption!.merge(
          TextStyle(
            color: Color(0xFF325384).withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
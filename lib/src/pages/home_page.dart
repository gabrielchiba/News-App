import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/components/article_list_tile.dart';
import 'package:news_app/src/constants/colors.dart';
import 'package:news_app/src/models/article.dart';
import 'package:news_app/src/services/api_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  final List<Tab> tabs = <Tab>[
    new Tab(text: 'General'),
    new Tab(text: 'Technology'),
    new Tab(text: 'Sports'),
    new Tab(text: 'Business'),
    new Tab(text: 'Entertainment'),
    new Tab(text: 'Health'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  ApiService client = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppTitle(context, widget.title),
        bottom: TabBar(
          isScrollable: true,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: customDarkBlue,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map(
                (tab)=> _buildWidgetArticleList(context, tab.text.toString())).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>null,
        tooltip: 'Set Notification',
        child: Icon(Icons.notifications),
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.subtitle2!.merge(
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32.0,
          color: customDarkBlue,
        ),
      ),
    );
  }

  Widget _buildWidgetArticleList(BuildContext context, String category) {
    return FutureBuilder(
      future: client.getTopHeadlinesByCategory(category),
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
        else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'),);
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
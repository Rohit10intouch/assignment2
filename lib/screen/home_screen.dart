import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment2/utils/date_helper.dart';
import '../widget/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Dio dio = Dio();
  List articles = [];
  Set<String> favoriteTitles = {}; // To store titles of favorite articles
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchArticles();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchArticles() async {
    const url =
        'https://newsapi.org/v2/everything?q=tesla&from=2024-08-01&sortBy=publishedAt&apiKey=0987741c358345dfa907f01050b93589';

    try {
      final response = await dio.get(url);
      setState(() {
        articles = response.data['articles'] ?? [];
      });
    } catch (e) {
      print(e);
      // Optionally show an error message to the user
    }
  }

  void toggleFavorite(String title) {
    setState(() {
      if (favoriteTitles.contains(title)) {
        favoriteTitles.remove(title);
      } else {
        favoriteTitles.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter favorite articles
    final favoriteArticles = articles
        .where((article) => favoriteTitles.contains(article['title']))
        .toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.85),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.line_horizontal_3_decrease,size: 25),
                      SizedBox(width: 10),
                      Text("News",style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, color: Colors.redAccent,size: 25,),
                      SizedBox(width: 10,),
                      Text("favorites",style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              indicator: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final isFavorite = favoriteTitles.contains(article['title']);
                      return NewsCard(
                        title: article['title'] ?? 'No title',
                        description: article['description'] ?? 'No description',
                        imageUrl: article['urlToImage'] ?? '',
                        publishedDate: DateHelper.formatDate(article['publishedAt']),
                        isFavorite: isFavorite,
                        onToggleFavorite: () => toggleFavorite(article['title'] ?? 'No title'),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: favoriteArticles.length,
                    itemBuilder: (context, index) {
                      final article = favoriteArticles[index];
                      return NewsCard(
                        title: article['title'] ?? 'No title',
                        description: article['description'] ?? 'No description',
                        imageUrl: article['urlToImage'] ?? '',
                        publishedDate: DateHelper.formatDate(article['publishedAt']),
                        isFavorite: true,
                        onToggleFavorite: () => toggleFavorite(article['title'] ?? 'No title'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

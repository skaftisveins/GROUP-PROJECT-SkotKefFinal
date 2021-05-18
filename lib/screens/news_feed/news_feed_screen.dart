import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skot_keflavik/constants.dart';
import 'package:skot_keflavik/model/News.dart';
import 'package:skot_keflavik/screens/news_feed/details_section.dart';
import 'package:skot_keflavik/screens/news_feed/headline_section.dart';
import 'package:skot_keflavik/screens/news_feed/text_section.dart';

import '../../config.dart';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListTile(
            title: NewsFeed(),
          ),
        ),
      ),
    );
  }
}

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  final _newsFeedKey = GlobalKey();
  Future<News> news;
  Future<News> fetchPosts() async {
    final data = await http.get(kNewsFeedUrl).then((response) {
      final jsonData = News.fromJson(json.decode(response.body));
      return jsonData;
    }).catchError((e) {
      noInternet = true;
      return e;
    });
    print(data);
    return data;
  }

  @override
  void initState() {
    super.initState();
    news = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _newsFeedKey,
      body: FutureBuilder<News>(
          future: news,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.articles.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsFeedDetails(
                              title: snapshot.data.articles[i].title,
                              description: snapshot.data.articles[i].content,
                              urlToImage: snapshot.data.articles[i].urlToImage,
                              publishedAt:
                                  snapshot.data.articles[i].publishedAt,
                            ),
                          ),
                        );
                      },
                      // HeadlineSection is a custom widget for styling the
                      // article headlines in the newsfeed
                      title: HeadlineSection(snapshot.data.articles[i].title),
                      subtitle:
                          // TextSection is a custom widget for styling the
                          // article description in the newsfeed
                          TextSection(snapshot.data.articles[i].description),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              // Return a custom widget to respond if
              // the device has no internet connection
              return NoInternetWarning();
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class NewsFeedDetails extends StatefulWidget {
  final String title;
  final String description;
  final String urlToImage;
  final DateTime publishedAt;

  NewsFeedDetails(
      {@required this.title,
      @required this.description,
      @required this.urlToImage,
      @required this.publishedAt});

  @override
  _NewsFeedDetailsState createState() => _NewsFeedDetailsState();
}

class _NewsFeedDetailsState extends State<NewsFeedDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.title);
    print(widget.description);
    print(widget.urlToImage);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Aftur í Fréttir'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      widget.urlToImage,
                      height: 200,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: HeadlineSection(widget.title),
                          subtitle: DetailsSection(widget.description),
                        ),
                        FlatButton(
                          textColor: kAmber,
                          child: Text('Til baka'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Ekkert netsamband'),
        Icon(
          Icons.warning,
          size: 35,
        ),
      ],
    );
  }
}

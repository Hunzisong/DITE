import 'package:flutter/material.dart';
import 'package:heard/Videochatcomponents/index.dart';  // the video call join page

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class HeadlineNews {
  HeadlineNews(this.header);

  final String header;
}

class NewsFeed {
  NewsFeed(this.title, this.subtitle);

  final String title;
  final String subtitle;
}

class _HomeState extends State<Home> {

  List<HeadlineNews> headlineNews = [
    HeadlineNews('Headline 1'),
    HeadlineNews('Headline 2'),
    HeadlineNews('Headline 3'),
  ];

  List<NewsFeed> newsFeed = [
    NewsFeed('Title 1', 'This 1st regards...'),
    NewsFeed('Title 2', 'This 2nd regards...'),
    NewsFeed('Title 3', 'This 3rd regards...'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: headlineNews.length,
                    itemBuilder: (BuildContext context, int index) =>
                        Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Card(
                                child: Center(
                                  child: Text(headlineNews[index].header),
                                ))),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                    child: Text(
                      "Latest Articles",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                )
              ),
              Container(
                  child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: newsFeed.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            child: ListTile(
                              title: Text(newsFeed[index].title),
                              subtitle: Text(newsFeed[index].subtitle),
                            ));
                      })),

              Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  onPressed: (){
                    Navigator.push(
                      context,

                      // move to the video call page
                      MaterialPageRoute(builder: (context) => IndexPage()),
                    );
                  },
                  child: const Icon(
                    Icons.videocam,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
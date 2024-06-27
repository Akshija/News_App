import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/news_article_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_progress_indicator.dart';

class NewsCardWidget extends StatefulWidget {
  final NewsArticleModel article;

  const NewsCardWidget({Key? key, required this.article}) : super(key: key);

  @override
  _NewsCardWidgetState createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget> {

  void _launchURL(String url) async{
    if(!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _launchURL(widget.article.originalArticleUrl);
      },
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white30,
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.article.articleImageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(
                      height: 150, child: CustomProgressIndicatorWidget()),
                  errorWidget: (context, url, error) =>
                      const SizedBox(child: Icon(Icons.error), height: 150),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Text(
                      widget.article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: Text(widget.article.publishDate),
                      )),
                      SizedBox(
                        height: 20,
                        child: IconButton(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          iconSize: 15,
                          onPressed: () {
                            Share.share(widget.article.originalArticleUrl,
                                subject: widget.article.title);
                          },
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

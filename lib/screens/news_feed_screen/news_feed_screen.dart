import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_app/components/custom_progress_indicator.dart';
import 'package:news_app/components/news_card.dart';
import 'package:news_app/models/country_model.dart';
import 'package:news_app/models/news_article_model.dart';
import 'package:news_app/services/category_service.dart';
import 'package:news_app/services/country_service.dart';
import 'package:news_app/services/news_article_service.dart';

import 'components/appbar.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  //Page size to deduct if it is the final page or not
  final int _pageSize = 20;

  //To save the current country we are using in our requests
  CountryModel currentCountry = CountryService().getFirstCountry();

  List<String> categories = CategoryService().getAllCategories();

  int selectedChipIndex = 0;

  final PagingController<int, NewsArticleModel> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _getArticles(pageKey);
    });
    super.initState();
  }

  //Request all articles for a certain country in a certain page
  Future<List<NewsArticleModel>> _getArticles(int pageKey) async {
    List<NewsArticleModel> articles = await NewsArticleService()
        .getArticles(pageKey, currentCountry.initials, categories[selectedChipIndex]);

    //Check if it is the last page
    final isLastPage = articles.length < _pageSize;

    if (isLastPage) {
      _pagingController.appendLastPage(articles);
    } else {
      final nextPageKey = pageKey + 1;
      _pagingController.appendPage(articles, nextPageKey);
    }

    return articles;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarContent(onChosenItem: (dynamic country) {
          setState(() {
            currentCountry = country as CountryModel;
            _pagingController.refresh();
          });
        }),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                    child: ChoiceChip(
                      selectedColor: Colors.redAccent,
                      label: Text(
                        categories[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      selected: selectedChipIndex == index,
                      onSelected: (bool value) {
                        //Update the state variable selectedChipIndex
                        setState(() {
                          selectedChipIndex = index;
                          _pagingController.refresh();
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: PagedListView<int, NewsArticleModel>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<NewsArticleModel>(
                itemBuilder: (context, item, index) => NewsCardWidget(article: item),
                //Create Card for each item
                firstPageProgressIndicatorBuilder: (_) => const CustomProgressIndicatorWidget(),
                newPageProgressIndicatorBuilder: (_) => const Padding(
                  //Loading a new page
                  padding: EdgeInsets.all(8.0),
                  child: CustomProgressIndicatorWidget(),
                ),
                noMoreItemsIndicatorBuilder: (_) => const Padding(
                  //When there is no more items to display
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('No more articles to show')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

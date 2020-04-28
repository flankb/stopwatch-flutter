import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:learnwords/models/word_dict.dart';
import 'package:learnwords/scope_models/learn_words_model.dart';
import 'package:learnwords/widgets/circular.dart';
import 'package:scoped_model/scoped_model.dart';
import '../main.dart';

class CustomSearchDelegate extends SearchDelegate<int> {
  final LearnWordsModel scopedModel;
  final ItemScrollController scrollController;

  CustomSearchDelegate({@required this.scopedModel, @required this.scrollController});

 /* @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }*/

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
        //hintStyle: TextStyle(color: theme.primaryTextTheme.title.color)),
        hintStyle: TextStyle(color: Colors.black54)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            title: theme.textTheme.title
                .copyWith(color: theme.primaryTextTheme.title.color)));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //TODO Живой поиск - это buildSuggestions
    debugPrint("queryolo " + query);

    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Необходимо ввести хотя бы три буквы.",
            ),
          )
        ],
      );
    }

    //Определить ближайшую ScopedModel
    //var model = LearnWordsModel.of(context);
    scopedModel.searchAsync(query);

    return ScopedModel<LearnWordsModel>(
        model: scopedModel,
        child: ScopedModelDescendant<LearnWordsModel>(builder:
            (BuildContext context, Widget child, LearnWordsModel model) {
          return model.isLoadingSearch
              ? CenterCircularWidget()
              : model.searchResult.length == 0
                  ? Center(
                      child: Text(
                        "Не найдено ни одного слова",
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: model.searchResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        debugPrint("query " +
                            index.toString() +
                            " " +
                            model.searchResult.length.toString());
                        WordDict current = model.searchResult[index];

                        return InkWell(
                          onTap: ()  {
                            // Опрделить индекс нужного слова, если оно есть, то перемотать на это слово и перед этим закрыть
                            int ind = model.getWordIndex(current);

                            debugPrint("sdsdc " + ind.toString());

                            if(ind != -1) {
                              //scrollController.scrollTo(index: ind, duration: Duration(seconds: 1));
                              //close(context, null);
                              close(context, ind);
                              //debugPrint("sdsdcc " + ind.toString());
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text(current.orig, style: TextStyle(
                                fontSize: 18
                              ),),

                            ),
                          ),
                        );
                      }, separatorBuilder: (BuildContext context, int index) => Divider(),);
        }));
  }

  @override
  String get searchFieldLabel => 'Поиск';

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}

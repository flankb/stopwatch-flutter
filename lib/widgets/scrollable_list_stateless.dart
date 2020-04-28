import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:learnwords/models/word_dict.dart';
import 'package:learnwords/scope_models/learn_words_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

import 'circular.dart';

class ScrollableListStateless extends StatelessWidget {
  final Key keyScroll;
  final int lastScrollPosition;
  final ItemScrollController scrollController;
  final ItemPositionsListener itemPositionsListener;
  final LearnWordsModel model;

  const ScrollableListStateless(
      {this.keyScroll,
      this.lastScrollPosition,
      this.scrollController,
      this.itemPositionsListener,
      this.model})
      : super();

  //: super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (!model.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // У lastScrollPosition бОльший приоритет, чем у словаря закладок
        if (lastScrollPosition != null) {
          scrollController.scrollTo(
              index: lastScrollPosition,
              duration: Duration(
                  seconds:
                      1)); // TODO Не скролить, если индекс по каким-то причинам превышает количество элементов!!!
          //lastScrollPosition = null;
        } else {
          int bookmark = await model.getBookmarkIndexAsync();
          debugPrint("model.getBookmarkAsync() " + bookmark.toString());

          //var df = await model.databaseRepository.getBookMarksAsync();

          /*debugPrint("df.forEach ---------------------" + df.length.toString());
          df.forEach((lw) {
            debugPrint("df.forEach ${lw.id} ${lw.category} ${lw.word}");
          });*/

          if (bookmark >= 0 &&
              bookmark <
                  model.wordsDict.length /*&& _scrollController.isAttached*/) {
            scrollController.scrollTo(
                index: bookmark,
                duration: Duration(
                    seconds:
                        1)); // TODO Не скролить, если индекс по каким-то причинам превышает количество элементов!!!
          }
        }
      });
    }

    //Since we’re being notified when our model changes, thanks to the notifyChanges() method, we do not need to use the FutureBuilder widget anymore. We can remove that and simply use it’s child ListView.builder which would update itself as soon as notifyListeners() gets called in our model:

    return (model.isLoading)
        ? CenterCircularWidget()
        : Stack(
          children: [ Scrollbar(
              child: ScrollablePositionedList.builder(
                  key: keyScroll,
                  addAutomaticKeepAlives: true,
                  itemScrollController: scrollController,
                  itemPositionsListener: itemPositionsListener,
                  padding: const EdgeInsets.all(8),
                  itemCount: model.wordsDict.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index > model.wordsDict.length) {
                      debugPrint("sdfsdfqqqq ${index}");
                    }

                    WordDict current = model.wordsDict[index];

                    final itemKey1 = PageStorageKey("WORD_${model.selectedCategory.name}_$index");
                    final itemKey2 = PageStorageKey("TR_${model.selectedCategory.name}_$index");

                    return Card(
                      elevation: 2.0,
                      // this field changes the shadow of the card 1.0 is default
                      shape: RoundedRectangleBorder(
                          //side: BorderSide(width: 0.01),
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          //height: 50,
                          //color: Colors.white,
                          child: Center(
                              child: Row(children: <Widget>[
                            Expanded(
                              child: Column(children: <Widget>[
                                SizedBox(
                                    width: double.infinity,
                                    child: SelectableText('${current.orig} ',
                                        key: itemKey1,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.bold))),
                                SizedBox(
                                  width: double.infinity,
                                  child: SelectableText('${current.raw.join('\r\n')}',
                                      key: itemKey2,
                                      //\r\n
                                      textAlign: TextAlign.left,
                                      style: TextStyle()),
                                )
                              ]),
                            ),

                            /*
                                          RaisedButton(
                                              onPressed: () {
                                                //LearnWordsModel.of(context).removeWord(current);

                                                Toast.show(
                                                    "Слово ${current.orig}  добавлено в избранное!",
                                                    context,
                                                    duration: Toast.LENGTH_LONG,
                                                    gravity: Toast.BOTTOM);
                                              },
                                              color: Colors.green,
                                              child: Text('В избр.'))
                                              */

                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ToggleButtons(
                                fillColor: Colors.transparent,
                                children: <Widget>[
                                  Icon(Icons.favorite_border),
                                  //Icon(Icons.call),
                                  //Icon(Icons.cake),
                                ],
                                onPressed: (int index) {
                                  current.isFav = !current.isFav;
                                  model.updateWordDictState(current);

                                  if (!current.isFav && model.selectedCategory.name == "Featured") {
                                    model.removeWordDictFromList(current);
                                  }

                                  var message = current.isFav
                                      ? 'добавлено в избранное'
                                      : 'удалено из избранного';

                                  Toast.show(
                                      "Слово ${current.orig} $message!", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                  //setState(() {
                                  //isSelected[index] = !isSelected[index];
                                  //});
                                },
                                isSelected: [current.isFav],
                                borderWidth: null,
                                renderBorder: false,

                                //borderRadius: BorderRadius.circular(8.0)

                                /*.only(
                                                      topLeft: Radius.circular(25),
                                                      bottomRight: Radius.circular(25),
                                                      topRight: Radius.circular(25),
                                                      bottomLeft: Radius.circular(25)),*/
                              ),
                            )
                          ]))),
                    );
                  }),
            ),
            Positioned(
              bottom: 16,
              right: 0,
              child: new RawMaterialButton(

                onPressed: () {
                  if(model.wordsDict.length > 0){
                    scrollController.scrollTo(index: 0, duration: Duration(seconds: 1));
                  }
                },
                child: new Icon(
                  Icons.keyboard_arrow_up,
                  color:  Colors.white,
                  size: 25.0,
                ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(15.0),
              ),)
          ]
        );
  }
}

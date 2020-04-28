
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:learnwords/models/word_dict.dart';
import 'package:learnwords/scope_models/learn_words_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toast/toast.dart';

import 'circular.dart';

class ScrollableList extends StatefulWidget{
  final int lastScrollPosition;
  final ItemScrollController scrollController;
  final ItemPositionsListener itemPositionsListener;
  final LearnWordsModel model;

  ScrollableList({Key key,
    this.lastScrollPosition, this.scrollController, this.itemPositionsListener, this.model}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScrollableListState();
  }

}

class _ScrollableListState extends State<ScrollableList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    IndexedScrollController controller = IndexedScrollController(initialIndex: 0);
    //Since we’re being notified when our model changes, thanks to the notifyChanges() method, we do not need to use the FutureBuilder widget anymore. We can remove that and simply use it’s child ListView.builder which would update itself as soon as notifyListeners() gets called in our model:

    return (widget.model.isLoading)
        ? CenterCircularWidget()
        : Scrollbar(

      child: ListView.builder(
        key: widget.key,
        //key: PageStorageKey<double>(keyDouble),
        //key: PageStorageKey<String>(key),
        //key: PageStorageKey<ItemPosition>(keyI),
        //key : UniqueKey(),
        //initialScrollIndex: 20,
          addAutomaticKeepAlives: true,
          //itemScrollController: widget.scrollController,
          //itemPositionsListener: widget.itemPositionsListener,
          padding: const EdgeInsets.all(8),
          itemCount: widget.model.wordsDict.length,
          //maxItemCount: widget.model.wordsDict.length,
          itemBuilder:
              (BuildContext context, int index) {
            if (index > widget.model.wordsDict.length) {
              debugPrint("sdfsdfqqqq ${index}");
            }

            WordDict current = widget.model.wordsDict[index];

            return Card(
              elevation: 2.0,
              // this field changes the shadow of the card 1.0 is default
              shape: RoundedRectangleBorder(
                //side: BorderSide(width: 0.01),
                  borderRadius:
                  BorderRadius.circular(5)),
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
                                child: SelectableText(
                                    '${current.orig} ',
                                    textAlign:
                                    TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors
                                            .grey[800],
                                        fontWeight:
                                        FontWeight
                                            .bold))),
                            SizedBox(
                              width: double.infinity,
                              child: SelectableText(
                                  '${current.raw.join('\r\n')}',
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
                          padding:
                          const EdgeInsets.all(2.0),
                          child: ToggleButtons(
                            fillColor: Colors.transparent,
                            children: <Widget>[
                              Icon(Icons.favorite_border),
                              //Icon(Icons.call),
                              //Icon(Icons.cake),
                            ],
                            onPressed: (int index) {
                              current.isFav =
                              !current.isFav;
                              widget.model.updateWordDictState(
                                  current);

                              var message = current.isFav
                                  ? 'добавлено в избранное'
                                  : 'удалено из избранного';

                              Toast.show(
                                  "Слово ${current.orig} $message!",
                                  context,
                                  duration:
                                  Toast.LENGTH_LONG,
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
          }, controller: controller,),
    );

  }
}

class Word {
  final String original;
  final String translation;

  Word(this.original, this.translation);

  Word.fromJson(Map<String, dynamic> json)
      : original = json['original'],
        translation = json['translation'];

  Map<String, dynamic> toJson() =>
      {
        'original': original,
        'translation': translation,
      };

  List encodeToJson(List<Word> list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();

    return jsonList;
  }
}

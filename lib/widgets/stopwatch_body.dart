import 'package:flutter/material.dart';

class StopwatchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List items = ["00:01", "00:03", "00:05"];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 0, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  "00:00",
                  style: TextStyle(fontSize: 34),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(leading: Text((index + 1).toString()), title: Text(items[index]));
            },
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                  child: SizedBox(
                    height: 150,
                    child: RawMaterialButton(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Старт", style: TextStyle(
                          fontSize: 22, color: Colors.white
                        ),),
                      ),
                      onPressed: () {},
                      fillColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                  child: SizedBox(
                    height: 150,
                    child: RawMaterialButton(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Круг", style: TextStyle(
                            fontSize: 22, color: Colors.black
                        )),
                      ),
                      onPressed: () {},
                      fillColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ],
    );
  }
}

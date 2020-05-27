import 'package:flutter/material.dart';

class StopwatchBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List items = ["00:01", "00:03", "00:05"];

    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Text("00:00", style: TextStyle(
                fontSize: 14
              ),),
              Text("00:00", style: TextStyle(
                fontSize: 24
              ),)
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(index.toString()),
                  title: Text(items[index]));
            },
          ),
        ),
        Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                RawMaterialButton(
                  child: Padding(padding: EdgeInsets.all(16),
                    child: Text("Старт"),
                  ),
                  onPressed: () {},
                  fillColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                )
              ],
            ),
            Column(
              children: <Widget>[
                RawMaterialButton(

                  child: Padding(padding: EdgeInsets.all(16),
                    child: Text("Круг"),

                  ),
                  onPressed: () {},
                  fillColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

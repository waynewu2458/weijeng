// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'GlobalVariable.dart' as gv;

void main() => runApp(FoodList());

// class FoodList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: AppBar(title: Text('餐點清單'), actions: [
//           PopupMenuButton(
//
//             icon: Icon(Icons.more_vert),
//             itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//
//               const PopupMenuItem(
//                 child: ListTile(
//                   leading: Icon(Icons.free_breakfast),
//                   title: Text('早餐'),
//
//                 ),
//               ),
//               const PopupMenuItem(
//                 child: ListTile(
//                   leading: Icon(Icons.lunch_dining),
//                   title: Text('午餐'),
//                 ),
//               ),
//               const PopupMenuItem(
//                 child: ListTile(
//                   leading: Icon(Icons.local_drink),
//                   title: Text('飲料'),
//                 ),
//               ),
//
//             ],
//           ),
//         ]),
//         body: Listfromhttp());
//   }
// }

class FoodList extends StatefulWidget {
  @override
  httpstate createState() => httpstate();
}

class httpstate extends State<FoodList> {
  List<dynamic> foodlist;
  List<int> foodtypelist;

  var data;

  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    this.Getfood();
  }

  Getfood() async {
    final response = await http.get(
      Uri.http('140.133.78.44:22692', 'getfood/Getfood'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer ${gv.Token}'
      },
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      gv.Token = data['NewToken'];
      print(data['JsonResult']);
      setState(() {
        foodlist = data['JsonResult'];
        foodtypelist =
            foodlist.map((e) => e['foodtype']).toSet().cast<int>().toList();
        foodtypelist.sort((a, b) => a.compareTo(b));
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    var arr = ['早餐', '午餐', '飲料'];
    return Scaffold(
        appBar: AppBar(title: Text('餐點清單')),
        body: ListView.builder(
            padding: EdgeInsets.all(5),
            itemCount: foodtypelist == null ? 0 : foodtypelist.length,
            itemBuilder: (context, i) {
              return Container(
                  margin: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  child: ExpansionTile(
                    title: Text(
                      arr[i],
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children:

                    foodlist.where((x) => x['foodtype'] == i).map<Widget>((e) =>
                    ListTile(
                              title: Text(e['FoodName']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  e['count'] != 0
                                      ? new IconButton(
                                          icon: new Icon(Icons.remove),
                                          onPressed: () =>
                                              setState(() => e['count']--),
                                        )
                                      : new Container(),
                                  Text(e['count'].toString()),
                                  IconButton(
                                      icon: new Icon(Icons.add),
                                      onPressed: () =>
                                          setState(() => e['count']++))
                                ],
                              ),
                            )).toList(),
                  ));
            }));
  }
}

class FoodTypeList extends StatefulWidget {
  var FoodType;
  List<dynamic> foodlist;

  FoodTypeList(this.FoodType, this.foodlist);

  @override
  FoodTypeState createState() => FoodTypeState();
}

class FoodTypeState extends State<FoodTypeList> {
  var expaned = false;

  @override
  Widget build(BuildContext context) {
    var typearray = ['早餐', '午餐', '飲料'];
    print(widget.FoodType);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(typearray[widget.FoodType]),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
                icon: new Icon(
                    expaned ? Icons.expand_less_outlined : Icons.expand_more),
                onPressed: () => setState(() => expaned = !expaned))
          ]),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            itemCount: !expaned || widget.foodlist == null
                ? 0
                : widget.foodlist.length,
            itemBuilder: (context, i) {
              return ListTileItem(widget.foodlist[i]);
            })
      ],
    );

    ListTile(
        title: new Text(typearray[widget.FoodType]),
        trailing: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
                icon: new Icon(
                    expaned ? Icons.expand_less_outlined : Icons.expand_more),
                onPressed: () => setState(() => expaned = !expaned))
          ],
        ));
  }
}

class ListTileItem extends StatefulWidget {
  var fooditem;

  ListTileItem(this.fooditem);

  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  @override
  Widget build(BuildContext context) {
    var data = widget.fooditem;
    String type = data['foodtype'] == 0
        ? '早餐'
        : data['foodtype'] == 1
            ? '午餐'
            : '飲料';

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      margin: EdgeInsets.all(5),
      child: ListTile(
        title: new Text(
            data['FoodName'] + ' ' + data['price'].toString() + ' ' +  data['foodtype'] == 0
                ? '早餐'
                : data['foodtype'] == 1
                ? '午餐'
                : '飲料'),
        trailing: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            data['count'] != 0
                ? new IconButton(
                    icon: new Icon(Icons.remove),
                    onPressed: () => setState(() => data['count']--),
                  )
                : new Container(),
            Text(data['count'].toString()),
            IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => setState(() => data['count']++))
          ],
        ),
      ),
    );
  }
}

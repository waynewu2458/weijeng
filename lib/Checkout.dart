// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'GlobalVariable.dart' as gv;

void main() => runApp(Checkout());

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

class Checkout extends StatefulWidget {
  @override
  httpstate createState() => httpstate();
}

class httpstate extends State<Checkout> {
  List<dynamic> foodlist;

  var data;

  @override
  void initState() {
    super.initState();
    // Call the getJSONData() method when the app initializes
    foodlist = gv.gvfoodlist;
  }

  @override
  Widget build(BuildContext context) {
    double total = foodlist
        .map((e) => e['price'] * e['count'])
        .fold(0, (previousValue, element) => previousValue + element);

    ///計算金額
    return Scaffold(
        appBar: AppBar(title: Text('結帳清單 總共$total元'), actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.article),
                  title: Text('結帳'),
                ),
                value: 0,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('清除購物車'),
                ),
                value: 1,
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('清除並重新購買'),
                ),
                value: 2,
              ),
            ],
            onSelected: (result) {
              switch(result){
                case(1):{
                  setState(() {
                    gv.gvfoodlist.clear();
                  });
           
                  break;
                }
                case(2):{
                  gv.gvfoodlist.clear();
                  Navigator.pop(context);
                }
                
              }

            },
          ),
        ]),
        body: ListView.builder(
          padding: EdgeInsets.all(5),
          itemCount: foodlist == null ? 0 : foodlist.length,
          itemBuilder: (context, index) {
            final item = foodlist[index];
            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(item['FoodName']),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  foodlist.removeAt(index);
                });

                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              child: ListTileItem(foodlist[index]),
            );
          },
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
            data['FoodName'] + ' ' + data['price'].toString() + ' ' + type),
        trailing: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(data['count'].toString()),
          ],
        ),
      ),
    );
  }
}

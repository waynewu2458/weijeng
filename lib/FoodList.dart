// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'GlobalVariable.dart' as gv;
import 'Checkout.dart';

void main() => runApp(FoodList());



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
        appBar: AppBar(title: Text('餐點清單'), actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {

                foodlist.where((element) => element['count']>0).forEach((x) {

                  if(!gv.gvfoodlist.map((e) => e['Foodid']).contains(x['Foodid'])){
                    gv.gvfoodlist.add( jsonDecode(jsonEncode(x))  );

                  }
                  else{
                    gv.gvfoodlist.where((e) => e['Foodid']==x['Foodid']).first['count']+= x['count'];

                  }

                });
              });
              //add的click事件

            },
          ),
          IconButton(
            icon: Icon(
              gv.gvfoodlist.length==0? Icons.shopping_cart_outlined:Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              //前往購物車

              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => Checkout()),
              ).then((value) => {
                    //返回時將本地list數量全部歸零
                    setState(() {
                      foodlist.forEach((x) {

x['count']=0;

                      });

                    })
                  });
            },
          )
        ]),
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
                    children: foodlist
                        .where((x) => x['foodtype'] == i)
                        .map<Widget>((e) => ListTile(
                              title: Text(
                                  e['FoodName'] + ' ' + e['price'].toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                      icon: new Icon(Icons.image),
                                      onPressed: () {
                                        return showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(e['FoodName']),
                                                content: Image.network(
                                                    e['FoodPictureURL']),
                                              );
                                            });
                                      }),
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
                                          setState(() => e['count']++)),
                                ],
                              ),
                            ))
                        .toList(),
                  ));
            }));
  }
}

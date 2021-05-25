import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'GlobalVariable.dart' as gv;
import 'FoodList.dart';
import 'Addfood.dart';
import 'ChooseFoodType.dart';
void main() {
  runApp(Dashboard());
}

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final title = '歡迎' + gv.Username;
    var arr = ['點餐', '我的訂單查詢', '新建餐點(admin)', '全部訂單查詢(admin)'];
    return new WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 2.5),
            itemCount: arr.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Card(
                  color: Colors.amber,
                  child: Center(child: Text(arr[index])),
                ),
                onTap: () {
                  switch (arr[index]) {
                    case ('點餐'):
                      {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) =>ChooseFoodType()),
                        );
                        break;
                      }
                    case ('我的訂單查詢'):
                      {
                        break;
                      }

                    case ('新建餐點(admin)'):
                      {
                        if (gv.admin == 1) {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) =>AddFood()),
                          );
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('權限不足'),
                              duration: Duration(seconds: 1)));
                        }
                        break;
                      }
                    case ('全部訂單查詢(admin)'):
                      {
                        if (gv.admin != 1) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('權限不足'),
                              duration: Duration(seconds: 1)));
                        }
                        break;
                      }
                  }
                },
              );
            }),
      ),
      onWillPop: () async {
        return _onWillPop();
      },
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(gv.Username+'你好'),
            content: new Text('確定登出?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          );
        }) ??
        false;
  }
}
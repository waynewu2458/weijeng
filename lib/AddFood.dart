import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'GlobalVariable.dart' as gv;
import 'Dashboard.dart';

void main() {
  runApp(AddFood());
}

class AddFood extends StatefulWidget {
  @override
  AddFoodState createState() => AddFoodState();
}

class AddFoodState extends State<AddFood> {
  final FoodNameController = TextEditingController();
  final FoodPictureURLController = TextEditingController();
  final priceURLController = TextEditingController();
  int _chosenValueindex = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    FoodNameController.dispose();
    FoodPictureURLController.dispose();
    priceURLController.dispose();
    super.dispose();
  }

  addfood() async {
    final response = await http.post(
      Uri.http('140.133.78.44:22692', 'getfood/Addfood'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer ${gv.Token}'
      },
      body: jsonEncode(<String, dynamic>{
        'FoodName': FoodNameController.text,
        'FoodPictureURL': FoodPictureURLController.text,
        'price': int.parse(priceURLController.text),
        'foodtype':_chosenValueindex
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      gv.Token = data['NewToken'];
      print('ok');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['Status'] == 1 ? "新增成功" : "新增失敗"),
          duration: Duration(seconds: 1)));
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    var arr = <String>[
      '早餐',
      '午餐',
      '飲料',
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("新增餐點"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 50, bottom: 0),
              child: TextField(
                controller: FoodNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '餐點名稱',
                    hintText: '餐點名稱'),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: FoodPictureURLController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '圖片網址',
                    hintText: '圖片網址'),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: priceURLController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '價格',
                    hintText: '價格'),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: DropdownButton<String>(
                focusColor: Colors.white,
                value: arr[_chosenValueindex],
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                iconEnabledColor: Colors.black,
                items: arr.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                hint: Text(
                  '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                onChanged: (String value) {
                  setState(() {
                    _chosenValueindex = arr.indexOf(value);
                  });

                },
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  addfood();
                },
                child: Text(
                  '提交',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}

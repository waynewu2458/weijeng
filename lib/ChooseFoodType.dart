import 'package:flutter/material.dart';
import 'FoodList.dart';
import 'GlobalVariable.dart' as gv;
import 'Checkout.dart';
import 'MyApp1.dart';
void main() {
  runApp(ChooseFoodType());
}

class ChooseFoodType extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<ChooseFoodType> {
  @override
  Widget build(BuildContext context) {
    final title ='選擇項目';
    var arr = ['餐點清單', '結帳'];
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
                    case ('餐點清單'):
                      {
                        gv.Foodtype = 0;
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => FoodList()),
                        );
                        break;
                      }
                    case ('飲料'):
                      {
                        gv.Foodtype = 1;
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => MyApp1()),
                        );
                        break;
                      }

                    case ('結帳'):
                      {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Checkout()),
                        );
                        break;
                      }

                  }
                },
              );
            }),
      ),

    );
  }


}

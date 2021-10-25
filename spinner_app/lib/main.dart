import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

void main() {
  runApp(SpinWheel());
}

class SpinWheel extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Spin Wheel',
      home: SpinWheelPage(),
    );
  }
}

class SpinWheelPage extends StatefulWidget {



  @override
  _SpinWheelPageState createState() => _SpinWheelPageState();
}

class _SpinWheelPageState extends State<SpinWheelPage> {

  Future createAlertDialog(BuildContext context) {

    TextEditingController customController = TextEditingController();

    return showDialog(context :context, builder:(context) {
      return AlertDialog(
        title: Text("Alert"),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget> [
          MaterialButton(onPressed: (){
            Navigator.of(context).pop(customController.text.toString());
          },
              child: Text("Change Text"))
        ],

      );
    });

  }

  int selected = 0;
  int rotation_count=10;
  List<int>point=[0,0,0,0,0,0,0,0,0,0,0];
  var map = {'Item 1': 0,'Item 2': 0,'Item 3': 0,'Item 4': 0};
  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4'
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Spin Wheel'),
      ),
      body: SingleChildScrollView(child:Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              selected = Random().nextInt(items.length);
              print(items[selected]);
              print(map);
              map.update(items[selected], (dynamic val) => ++val);
              print(map);
              point[selected]=point[selected]+1;
              print("Selected value1 $selected ${point[selected]}");
            });
          },
          child: Column(
            children: [
              Container(
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: FortuneWheel(
                        styleStrategy: AlternatingStyleStrategy( ),
                        rotationCount: rotation_count,
                        onFling: () => {
                          setState(() {
                            selected = Random().nextInt(items.length);
                            point[selected]=point[selected]+1;
                            print("Selected value1 $selected ${point[selected]}");
                          })
                        },
                        selected: selected,
                        items: [
                          for (var it in items) FortuneItem(child: Text(it)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10,bottom: 10),
                color: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Team",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("Points",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),

                    ],),
                ),
              ),
              ListView.builder(
                shrinkWrap: true
                ,itemBuilder: (context,index){
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${items[index]}",style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.bold),),
                          IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            createAlertDialog(context).then((onValue){
                              setState(() {
                                items[index] = onValue.toString();
                                // map.putIfAbsent(map[items[index]], ()=> null);
                              });
                            });
                          }),
                          Text("${point[index]}",style: TextStyle(color: Colors.purple,fontSize: 14,fontWeight: FontWeight.bold),),
                          IconButton(
                            icon: const Icon(Icons.highlight_remove),
                            onPressed: () {
                              setState(() {
                                if (items.length>2) {
                                  items.remove(items[index]);

                                }
                              });
                            },
                          ),
                        ],),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.blueGrey,
                    )
                  ],
                );
              },itemCount: items.length,),
              ElevatedButton(onPressed: () {
                setState(() {
                  items.add("New");
                  point.add(0);
                });
              }, child: Text('Add')),

              ElevatedButton(onPressed: () {
                setState(() {
                  for (int i =0; i<point.length; i++){
                    point[i] = 0;
                  }
                });
              }, child: Text('Clear Scores')),
            ],
          ),
        ),
      ),
      )
    );
  }
}

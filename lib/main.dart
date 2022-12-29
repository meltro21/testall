import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyCustomOffset {
  double dxStart;
  double dxEnd;
  double dyStart;
  double dyEnd;

  MyCustomOffset(this.dxStart, this.dxEnd, this.dyStart, this.dyEnd);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _gesture = "";
  var changeColor1 = false;
  var changeColor2 = false;
  var once = true;
  var colno = 5;
  var rowno = 10;
  double rows = 0;
  double cols = 0;

  List<List<bool>> colors = [];

  List<List<MyCustomOffset>> arr = [];

  late Future<String> _value;

  Future<String> setUp() async {
    //await Future.delayed(Duration(seconds: 2));
    rows = (700 / rowno);
    cols = 300 / colno;

    var storeCol = 1.0;
    for (int i = 0; i < rowno; i++) {
      List<bool> tempColors = [];
      List<MyCustomOffset> temp = <MyCustomOffset>[];

      var storeRow = 1.0;
      for (int j = 0; j < colno; j++) {
        MyCustomOffset myCustom = MyCustomOffset(
            storeRow, storeRow + rows, storeCol, storeCol + cols);

        storeRow = rows * (j + 1);
        temp.add(myCustom);
        tempColors.add(false);
      }
      storeCol = cols * (i + 1);

      arr.add(temp);
      colors.add(tempColors);
    }
    for (var i = 0; i < rowno; i++) {
      for (var j = 0; j < colno; j++) {
        print(
            'dx is ${arr[i][j].dxStart} dxEnd is ${arr[i][j].dxEnd} and dy is ${arr[i][j].dyStart} dyEnd is ${arr[i][j].dyEnd}');
      }
    }
    return 'hello';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _value = setUp();
  }

  @override
  Widget build(BuildContext context) {
    var mediaHeight = MediaQuery.of(context).size.height;
    var statusBarHeight = MediaQuery.of(context).viewPadding.top;
    mediaHeight -= statusBarHeight;
    var mediaWidth = MediaQuery.of(context).size.width;

    // if (once) {
    //   var storeCol = 1.0;
    //   for (int i = 0; i < rowno; i++) {
    //     List<bool> tempColors = [];
    //     List<MyCustomOffset> temp = <MyCustomOffset>[];

    //     var storeRow = 1.0;
    //     for (int j = 0; j < colno; j++) {
    //       MyCustomOffset myCustom = MyCustomOffset(
    //           storeRow, storeRow + rows, storeCol, storeCol + cols);

    //       storeRow = rows * (j + 1);
    //       temp.add(myCustom);
    //       tempColors.add(false);
    //     }
    //     storeCol = cols * (i + 1);

    //     arr.add(temp);
    //     colors.add(tempColors);
    //   }

    //   for (var i = 0; i < rowno; i++) {
    //     for (var j = 0; j < colno; j++) {
    //       print(
    //           'dx is ${arr[i][j].dxStart} dxEnd is ${arr[i][j].dxEnd} and dy is ${arr[i][j].dyStart} dyEnd is ${arr[i][j].dyEnd}');
    //     }
    //   }
    // }
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _value,
          builder: ((context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              print('data is ${snapshot.data}');
              if (snapshot.hasError) {
                print('Error occured');
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onPanStart: (details) {
                          print('pan started');
                        },
                        onPanUpdate: (details) {
                          print(details.localPosition);
                          print('details');

                          for (var i = 0; i < rowno; i++) {
                            for (var j = 0; j < colno; j++) {
                              if (details.localPosition.dx >=
                                      arr[i][j].dxStart &&
                                  details.localPosition.dx < arr[i][j].dxEnd &&
                                  details.localPosition.dy >=
                                      arr[i][j].dyStart &&
                                  details.localPosition.dy < arr[i][j].dyEnd) {
                                setState(() {
                                  colors[i][j] = true;
                                });
                              }
                              ;
                            }
                          }
                        },
                        child: Container(
                          color: Colors.orange,
                          child: Column(children: [
                            for (int i = 0; i < rowno; i++)
                              Row(
                                children: [
                                  for (int j = 0; j < colno; j++)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: colors[i][j] == false
                                              ? Colors.blue
                                              : Colors.purple,
                                          border:
                                              Border.all(color: Colors.black)),
                                      height: rows,
                                      width: cols,
                                    ),
                                ],
                              )
                          ]),
                        ),
                      )
                    ],
                  ),
                );
              }
            }
            return CircularProgressIndicator();
          }),
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(new MaterialApp(
//       home: new IssueExamplePage(),
//       debugShowCheckedModeBanner: false,
//     ));

// class IssueExamplePage extends StatefulWidget {
//   @override
//   _IssueExamplePageState createState() => _IssueExamplePageState();
// }

// class _IssueExamplePageState extends State<IssueExamplePage> {
//   bool drawingBlocked = false;
//   List<Offset> points = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           color: Colors.grey,
//           padding: EdgeInsets.all(5),
//           child: Container(
//             color: Colors.white,
//             child: InteractiveViewer(
//               child: AbsorbPointer(
//                 absorbing: drawingBlocked,
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onPanUpdate: (details) {
//                     RenderBox renderBox =
//                         context.findRenderObject() as RenderBox;
//                     Offset cursorLocation =
//                         renderBox.globalToLocal(details.localPosition);

//                     setState(() {
//                       points = List.of(points)..add(cursorLocation);
//                     });
//                   },
//                   onPanEnd: (details) {
//                     setState(() {
//                       points = List.of(points)..add(Offset(0, 0));
//                     });
//                   },
//                   child: CustomPaint(
//                       painter: MyPainter(points), size: Size.infinite),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//               child: Icon(drawingBlocked
//                   ? CupertinoIcons.hand_raised_fill
//                   : CupertinoIcons.hand_raised),
//               onPressed: () {
//                 setState(() {
//                   drawingBlocked = !drawingBlocked;
//                 });
//               }),
//           SizedBox(height: 10),
//           FloatingActionButton(
//               child: Icon(Icons.clear),
//               onPressed: () {
//                 setState(() {
//                   points = [];
//                 });
//               }),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// class MyPainter extends CustomPainter {
//   MyPainter(this.points);
//   List<Offset> points;
//   Paint paintBrush = Paint()
//     ..color = Colors.blue
//     ..strokeWidth = 5
//     ..strokeJoin = StrokeJoin.round
//     ..strokeCap = StrokeCap.round;

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (int i = 0; i < points.length - 1; i++) {
//       if (points[i] != null && points[i + 1] != null) {
//         canvas.drawLine(points[i], points[i + 1], paintBrush);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(MyPainter oldDelegate) {
//     return points != oldDelegate.points;
//   }
// }

import 'package:flutter/material.dart';
import 'package:fyp/plane.dart';
import 'dart:async';
import 'bar.dart';
import 'coverscreen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>  {
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();

  get notifications => null;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context)!.startShowCase(
        [
          _key1,
          _key2,
          _key3,
        ],
      ),
    );

  }


  // plane variables
  static double planeY = 0;
  double initialPos = planeY;
  double height = 0;
  double time = 0;
  double score = 0;
  String moode = 'Easy';
  int tempscore = 0;
  int hiscore = 0;
  double speedy = 0.005;
  double gravity = -2.5; // how strong the gravity is
  double velocity = 2.0; // how strong the jump is
  double planeWidth = 0.15; // out of 2, 2 being the entire width of the screen
  double planeHeight = 0.15; // out of 2, 2 being the entire height of the screen

  // game settings
  bool gameHasStarted = false;

  // barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5; // out of 2
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];



  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      // a real physical jump is the same as an upside down parabola
      // so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;

      setState(() {
        planeY = initialPos - height;
      });

      // check if plane is dead
      if (planeIsDead()) {
        timer.cancel();
        _showDialog();
      }

      // keep the map moving (move barriers)
      moveMap();

      // keep the time going!
      time += 0.01;
    });
  }

void moveMap()   {
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      score += 0.01;
      tempscore = score.ceil();
      if(tempscore > hiscore){
        hiscore = tempscore;
      }
      setState(() {
        barrierX[i] -= speedy;
      });

      // if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }

  }

  void resetGame() {

    Navigator.pop(context); // dismisses the alert dialog
    setState(() {
      planeY = 0;
      gameHasStarted = false;
      time = 0;
      initialPos = planeY;
      barrierX = [1.1, 1.1 + 1.5];
      score = 0;
    });
  }

  void easy() {
    moode = 'Easy';
    speedy = 0.005;
    setState(() {
      planeY = 0;
      time = 0;
      initialPos = planeY;
      barrierX = [1.1, 1.1 + 1.5];
      score = 0;
      velocity = 2.0;
    });
  }

  void medium() {
    moode = 'Medium';
    speedy = 0.01;
    setState(() {
      planeY = 0;
      time = 0;
      initialPos = planeY;
      barrierX = [1.1, 1.1 + 1.5];
      score = 0;
      velocity = 1.5;
    });
  }

  void hard() {
    moode = 'Hard';
    speedy = 0.015;
    setState(() {
      planeY = 0;
      time = 0;
      initialPos = planeY;
      barrierX = [1.1, 1.1 + 1.5];
      score = 0;
      velocity = 1.0;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: Column(
              children: [
                Center(
                  child: Text(
                    "PLANE CRASHED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = planeY;
    });
  }

  bool planeIsDead() {
    // check if the plane is hitting the top or the bottom of the screen
    if (planeY < -1.0 || planeY > 1.0) {
      return true;
    }

    // hits barriers
    // checks if plane is within x coordinates and y coordinates of barriers
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= planeWidth +0.06 &&
          barrierX[i] + barrierWidth >= -planeWidth &&
          (planeY <= -1.05 + barrierHeight[i][0] ||
              planeY + planeHeight >= 1.05 - barrierHeight[i][1])) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameHasStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                //color: Colors.green,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/nnn.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      // plane
                      Showcase(
                        key: _key1,
                        description:
                            'you can tap in this area of screen \nplane will jump to a certain height on tap \navoid upcoming hurdles to continue play ',
                        shapeBorder: const CircleBorder(),
                        showcaseBackgroundColor: Colors.indigo,
                        descTextStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        child: Myplane(
                          planeY: planeY,
                          planeWidth: planeWidth,
                          planeHeight: planeHeight,
                        ),
                      ),

                      // tap to play
                      MyCoverScreen(gameHasStarted: gameHasStarted),

                      MyBarrier(

                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][0],
                        isThisBottomBarrier: false,
                      ),

                      // Bottom barrier 0
                      MyBarrier(
                        barrierX: barrierX[0],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[0][1],
                        isThisBottomBarrier: true,
                      ),

                      // Top barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][0],
                        isThisBottomBarrier: false,
                      ),

                      // Bottom barrier 1
                      MyBarrier(
                        barrierX: barrierX[1],
                        barrierWidth: barrierWidth,
                        barrierHeight: barrierHeight[1][1],
                        isThisBottomBarrier: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container (

              color: Colors.black,
              child: Row (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Container(
                    child: Text(
                      '   Current mode => $moode ',
                     // textAlign: TextAlign.center,
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Container(

                    child: Text(
                    'HighScore => $hiscore',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Showcase(
                        key: _key2,
                        title: 'Total Score',
                        description: 'it keeps increasing on passing hurdles',
                        showArrow: false,
                        overlayPadding: const EdgeInsets.all(2),
                        showcaseBackgroundColor: Colors.indigo,
                        textColor: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '$tempscore',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'S C O R E',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Showcase(
                              key: _key3,
                              title: 'Playing Levels',
                              description:
                                  'You can choose Level \n By default, it is Easy',
                              child: Container(
                                  child: Row(
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text('Easy'),
                                      onPressed: easy,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: Container(
                                      child:ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: Text('Medium'),
                                        onPressed: medium,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                       backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Text('Hard'),
                                      onPressed: hard,
                                    ),
                                  ),

                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              height: 25,
              ),
          ],
        ),
      ),
    );
  }
}


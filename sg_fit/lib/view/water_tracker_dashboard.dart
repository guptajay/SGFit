import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'popup.dart';
import 'popup_content.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sgfit/model/weather_details.dart';
import 'package:sgfit/model/tips.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgfit/controller/user_data_read_write.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Display(title: 'Water Tracker'),
    );
  }
}

class Display extends StatefulWidget {
  Display({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  Future<WeatherDetails> tempdata;

  // @override
  void initState() {
    print('lalallalal');
    getdaily();
    super.initState();
    tempdata = getWeatherDetails();
  }

  Future<dynamic> getdaily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final waterdaily = prefs.get('waterconsumed');
    if (waterdaily != null) {
      setState(() {
        globals.waterconsumedi = waterdaily;
        waterconsumeds = waterdaily.toString();
      });
    } else {
      setState(() {
        globals.waterconsumedi = 0;
        waterconsumeds = "0";
      });
    }
    print('THIS IS WATER DAILY $waterdaily');
  }

  String waterconsumeds = '0';
  String finaltarget = '0';
  String tip = globals.tips;
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  Future<dynamic> reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.waterconsumedi = 0;
      waterconsumeds = "0";
    });
    await prefs.setInt('waterconsumed', 0);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 100,
        left: 45,
        right: 45,
        bottom: 100,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.cyan[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.cyan[700],
              leading: new Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    try {
                      Navigator.pop(context); //close the popup
                    } catch (e) {}
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            resizeToAvoidBottomPadding: false,
            body: widget,
            backgroundColor: Colors.cyan[700],
          ),
        ),
      ),
    );
  }

  Widget _popupBodyWorkout() {
    return Column(
      children: <Widget>[
        // Row(children: <Widget>[
        Container(
          height: 125,
          padding: EdgeInsets.only(top: 90),
          child: Text(
            "How long is your workout?",
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white, width: 2, style: BorderStyle.solid)),
          child: TextField(
            controller: myController1,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.cyan[900]),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Time in mins",
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.grey[400],
                )),
          ),
        ),
        Container(
          height: 125,
          padding: EdgeInsets.only(top: 90),
          child: Text(
            "Rate the Intensity",
            style: TextStyle(
                fontFamily: 'Roboto',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white, width: 2, style: BorderStyle.solid)),
          child: TextField(
            controller: myController2,
            keyboardType: TextInputType.number,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.cyan[900]),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "From 1 to 5",
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.grey[400],
                )),
          ),
        ),
        Container(
          child: FloatingActionButton.extended(
            onPressed: () {
              globals.workoutmins = int.parse(myController1.text);
              globals.workoutintensity = int.parse(myController2.text);
              //WaterTracker.calculateTarget();
              setState(() {
                finaltarget = globals.target.toString();
              });

              try {
                Navigator.pop(context); //close the popup
              } catch (e) {}
            },
            label: Text('CONFIRM',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.cyan[900],
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                )),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(),
          ),
          margin: const EdgeInsets.only(top: 50),
        ),

        // ]
        // ),
      ],
    );
  }

  Widget _popupBodyContainer() {
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
            margin: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            child: FloatingActionButton.extended(
              onPressed: () {
                globals.containersize = 100;

                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
                // Add your onPressed code here!
              },
              label: Text('100 ml',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.cyan[900],
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              icon: Icon(
                FontAwesome5Solid.glass_martini,
                color: Colors.cyan[900],
              ),
              //icon: Icon(FontAwesome5.getIconData("glass_martini", weight: IconWeight.Solid));
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
          ),
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2)),
            margin: EdgeInsets.only(
              top: 28,
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                globals.containersize = 250;

                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
                // Add your onPressed code here!
              },
              label: Text('250 ml',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.cyan[900],
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              icon: Icon(
                FontAwesome5Solid.coffee,
                color: Colors.cyan[900],
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
          ),
        ]),
        Row(children: <Widget>[
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2)),
            margin: EdgeInsets.all(20),
            child: FloatingActionButton.extended(
              onPressed: () {
                globals.containersize = 350;

                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
                // Add your onPressed code here!
              },
              label: Text('350 ml',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.cyan[900],
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              icon: Icon(
                FontAwesome5Solid.glass_whiskey,
                color: Colors.cyan[900],
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
          ),
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2)),
            child: FloatingActionButton.extended(
              onPressed: () {
                globals.containersize = 500;

                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
                // Add your onPressed code here!
              },
              label: Text('500 ml',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.cyan[900],
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              icon: Icon(
                MaterialCommunityIcons.glass_mug,
                color: Colors.cyan[900],
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
          ),
        ]),
        Row(children: <Widget>[
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2)),
            margin: EdgeInsets.all(20),
            child: FloatingActionButton.extended(
              onPressed: () {
                globals.containersize = 750;

                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
                // Add your onPressed code here!
              },
              label: Text('750 ml',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.cyan[900],
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              icon: Icon(
                FontAwesome5Solid.prescription_bottle,
                color: Colors.cyan[900],
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
          ),
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                globals.containersize = 1000;

                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
                // Add your onPressed code here!
              },
              label: Text('1000 ml',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.cyan[900],
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  )),
              icon: Icon(
                MaterialCommunityIcons.bottle_wine,
                color: Colors.cyan[900],
                size: 35,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int age = 0;
    int weight = 0;
    return Scaffold(
      backgroundColor: Colors.cyan[900],
      body: Column(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  disabledColor: Colors.white,
                  tooltip: 'Navigation menu',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 50.0,
                  padding: EdgeInsets.only(left: 10, top: 40),
                ),
                IconButton(
                  icon: Icon(Icons.cloud),
                  tooltip: 'Navigation menu',
                  onPressed: null,
                  alignment: Alignment.topRight,
                  iconSize: 50.0,
                  padding: EdgeInsets.only(left: 180, top: 40),
                  disabledColor: Colors.white,
                ),
                Container(
                  child: FutureBuilder<WeatherDetails>(
                    future: tempdata,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.temp.toString() + '°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                  margin: const EdgeInsets.only(top: 40, left: 15),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$waterconsumeds' + ' ml',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                        ),
                      ),
                      FutureBuilder(
                          future: readFromFileAge(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> data) {
                            if (data.hasData != null) {
                              age = int.parse(data.data.toString());
                              print(age);
                              return Text('');
                            }
                          }),
                      FutureBuilder(
                          future: readFromFileWeight(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> data) {
                            if (data.hasData != null) {
                              weight = int.parse(data.data.toString());
                              print(weight);
                              return Text('');
                            }
                          }),
                      FutureBuilder<WeatherDetails>(
                        future: tempdata,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            double a = (snapshot.data.temp.toInt() * 6.5) +
                                (globals.workoutintensity * 75) +
                                (globals.workoutmins * 0.845) -
                                (age * 0.15) +
                                (weight * 28.4) +
                                (globals.gender * 200);
                            globals.target = a.toInt();
                            finaltarget = globals.target.toString();
                            return Text(
                              '/' + '$finaltarget' + 'ml',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          // By default, show a loading spinner.
                          return CircularProgressIndicator();
                        },
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(top: 40),
                  width: 250,
                  height: 250,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white, width: 6)),
                ),
              ],
            ),
            Row(children: <Widget>[
              Container(
                  child: IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Reset water consumed',
                color: Colors.white,
                padding: EdgeInsets.only(left: 70),
                onPressed: () {
                  reset();
                },
                iconSize: 50.0,
              )),
              IconButton(
                icon: Icon(Icons.local_drink),
                tooltip: 'Navigation menu',
                color: Colors.white,
                onPressed: () {
                  showPopup(
                      context, _popupBodyContainer(), 'CHOOSE A CONTAINER');
                },
                alignment: Alignment.topRight,
                iconSize: 50.0,
                padding: EdgeInsets.only(left: 160),
                disabledColor: Colors.white,
              ),
              Container(
                child: Text('CHANGE',
                    style: TextStyle(color: Colors.white, fontSize: 13)),
                padding: EdgeInsets.only(top: 25),
              ),
            ]),
            Row(children: <Widget>[
              Container(
                  child: FlatButton(
                    color: Colors.cyan[700],
                    onPressed: () async {
                      print('start');
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      setState(() {
                        globals.waterconsumedi =
                            globals.waterconsumedi + globals.containersize;
                        waterconsumeds = (globals.waterconsumedi).toString();
                        print(globals.containersize);
                      });

                      await prefs.setInt(
                          'waterconsumed', globals.waterconsumedi);
                      print('end');
                    },
                    disabledColor: Colors.white,
                    child: Text('CONFIRM WATER INTAKE!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        )),

                    //textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  ),
                  padding: EdgeInsets.only(top: 60, left: 38))
            ]),
            Row(children: <Widget>[
              Container(
                child: Column(
                    // decoration: BoxDecoration(),
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                      ),
                      Text('$tip',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            color: Colors.white,
                          ))
                    ] //
                    ),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.white,
                )),
                margin: const EdgeInsets.only(left: 30, top: 32),
                width: 150,
                height: 95,
              ),
              Container(
                  width: 180,
                  height: 130,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      showPopup(
                          context, _popupBodyWorkout(), 'WORKOUT DETAILS');
                      //reset();
                    },
                    backgroundColor: Colors.white,

                    label: Text('ADD WORKOUT\nDETAILS!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.cyan[700],
                          fontSize: 18,
                        )),

                    //textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.cyan[700],
                            width: 3,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10)),
                    // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                  ),
                  padding: EdgeInsets.only(top: 35, left: 5)),
            ]),
          ]),
    );
  }
}

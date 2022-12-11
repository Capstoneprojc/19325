import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cap_4/graph.dart';
import 'package:cap_4/table.dart';

class showReads extends StatefulWidget {
  const showReads({Key? key}) : super(key: key);

  @override
  State<showReads> createState() => _showReads();
}

class _showReads extends State<showReads> {
  final _database = FirebaseDatabase.instance.reference();
  dynamic temp = 0.00;
  dynamic ph = 0.00;

  @override
  void initState() {
    _activateListners();
    super.initState();
  }

  void _activateListners() {
    _database.child('sensor/temp').onValue.listen((event) {
      final dynamic tempRead = event.snapshot.value as dynamic;
      setState(() {
        temp = tempRead;
      });
    });
    _database.child('sensor/ph').onValue.listen((event) {
      final dynamic phRead = event.snapshot.value as dynamic;
      setState(() {
        if (phRead >= 0){
          ph= phRead;
        }
        else {
          ph = 0;
        }
      });
    });
  }

  MaterialColor T () {
    if (temp >=0.00 && temp <= 45) {
      return Colors.green;
    } else if (temp > 45.00 && temp<80.00) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  MaterialColor p () {
    if (ph >= 6.50 && ph <= 8.00) {
      return Colors.green;
    } else if (ph > 8.00) {
      return Colors.red;
    } else {
      return Colors.red;
    }
  }
  Widget build(BuildContext context) {
    print ({temp, ph});
    return Scaffold(
      backgroundColor: Colors.cyan[900],
      appBar: AppBar(
        title: Text(
          'Sensors readings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[700],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: showData(temp, 'C', T(), 100.00)),
              Expanded(child: showData(ph, '', p(), 14.00),),
              Row(children:[Text('Normal readings', style: TextStyle(color: Colors.white, fontSize: 15),), SizedBox(width: 10,) ,dataLabel(color:Colors.green)]),
              SizedBox(height: 10,),
              Row(children:[Text('dynamicermediate Readings', style: TextStyle(color: Colors.white, fontSize: 15),),SizedBox(width: 10,), dataLabel(color:Colors.orange)]),
              SizedBox(height: 10,),
              Row(children:[Text('Dangerous Readings',style: TextStyle(color: Colors.white, fontSize: 15),),SizedBox(width: 10,), dataLabel(color:Colors.red)]),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.cyan,
        children: [
          SpeedDialChild(
              child: Icon(Icons.auto_graph, color: Colors.white,),
              label: 'ph - temperature',
              backgroundColor: Colors.cyan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          phTemp() //here pass the actual values of these dynamiciables, for example false if the payment isn't successfull..etc
                  ),
                );
              }),
          SpeedDialChild(
              child: Icon(Icons.table_chart, color: Colors.white,),
              label: 'Table of data',
              backgroundColor: Colors.cyan,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          dataTable() //here pass the actual values of these dynamiciables, for example false if the payment isn't successfull..etc
                  ),
                );
              })
        ],
      ),
    );
  }

  Widget showData(dynamic value, String unit, Color Colr, dynamic scale) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.cyan[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 150,
              height: 150,
              child: Stack(fit: StackFit.expand, children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colr),
                  strokeWidth: 10,
                  value: value / scale,
                  backgroundColor: Colors.grey,
                ),
                Center(
                  child: Text(
                    '${value.toStringAsFixed(2).toString()} $unit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ])),
        ],
      ),
    );
  }
  Container dataLabel ({required Color color}) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: color,
      ),
      alignment: Alignment.bottomLeft,
    );
  }
}

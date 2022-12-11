import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class phTemp extends StatefulWidget {
  const phTemp({Key? key}) : super(key: key);

  @override
  State<phTemp> createState() => _phTemp();
}

class _phTemp extends State<phTemp> {
  final _database = FirebaseDatabase.instance.reference();
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  dynamic temp = 0;
  dynamic ph = 0;
  dynamic lastTemp = 0;
  dynamic lastPh = 0;

  @override
  void initState() {
    _activateListners();
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  void _activateListners() {
    _database
        .child('sensor/temp')
        .onValue
        .listen((event) {
      temp = event.snapshot.value as dynamic;
    });
    _database
        .child('sensor/ph')
        .onValue
        .listen((event) {
      ph = event.snapshot.value as dynamic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Graph of Temberature and Ph',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              centerTitle: true,
              backgroundColor: Colors.cyan[800],
            ),
            body:
            SfCartesianChart(
                series: <LineSeries<LiveData, dynamic>>[
                  LineSeries<LiveData, dynamic>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: Colors.cyan[900],
                    xValueMapper: (LiveData sales, _) => sales.temp,
                    yValueMapper: (LiveData sales, _) => sales.ph,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Temperature in C')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Ph'))))
    );
  }

  void updateDataSource(Timer timer) {
    if (temp != lastTemp || lastPh != ph) {
      chartData.add(LiveData(temp, ph));
      chartData.removeAt(0);
      _chartSeriesController.updateDataSource(
          addedDataIndex: chartData.length - 1, removedDataIndex: 0);
      lastPh = ph;
      lastTemp = temp;
    }
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 0),
      LiveData(temp, ph),
    ];
  }
}

class LiveData {
  LiveData(this.temp, this.ph);

  final dynamic ph;
  final dynamic temp;
}

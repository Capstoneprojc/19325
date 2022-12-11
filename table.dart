import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class dataTable extends StatefulWidget {
  const dataTable({Key? key}) : super(key: key);

  @override
  State<dataTable> createState() => _dataTableState();
}

class _dataTableState extends State<dataTable> {
  final _database = FirebaseDatabase.instance.reference();
  dynamic temp = 0;
  dynamic ph = 0;
  late MyData _data;
  final numberOfRows = 10;
  dynamic time = 0;

  @override
  void initState() {
    _data = MyData.dynamiciation(numberOfRows: numberOfRows);
    _activateListners();
    super.initState();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
  }

  void _activateListners() {
    _database.child('sensor/temp').onValue.listen((event) {
      temp = event.snapshot.value as dynamic;
    });
    _database.child('sensor/ph').onValue.listen((event) {
      ph = event.snapshot.value as dynamic;
      if (ph >= 0){
        ph = ph;
      }
      else{
        ph = 0;
      }
    });
  }

  void updateDataSource(Timer timer) {
    _activateListners();
    setState(() {
      _data.updateData(temp: temp, ph: ph, time: time);
      _data = MyData(numberOfRows: numberOfRows);
    });
    time++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table of data'),
        centerTitle: true,
        backgroundColor: Colors.cyan[800],
      ),
      body: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.cyan[900],
             // dividerColor: Colors.white,
            ),
            child: PaginatedDataTable(
              source: _data,
              columns: const [
                DataColumn(label: Text("Time", style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('Tempreture', style: TextStyle(color: Colors.white))),
                DataColumn(label: Text('ph', style: TextStyle(color: Colors.white)))
              ],
              header: const Center(child: Text('Sensor Readings', style: TextStyle(color: Colors.white),)),
              columnSpacing: 50,
              horizontalMargin: 100,
              rowsPerPage: numberOfRows,
            ),
          )
        ],
      ),
    );
  }
}

class MyData extends DataTableSource {
  late dynamic tempRead, phRead;
  static List<Map<String, dynamic>> _data = [];
  static dynamic counter = 0;
  late dynamic numberOfRows;

  MyData({this.tempRead = 0, this.phRead = 0, required this.numberOfRows});

  MyData.dynamiciation(
      {this.tempRead = 0, this.phRead = 0, required this.numberOfRows}) {
    _data = List.generate(numberOfRows, (index) {
      return {"Time": "__", "Tempreture": "__", "ph": "__"};
    });
  }

  updateData({temp, ph, time}) {
    _data.removeAt(_data.length - 1);
    _data.insert(0, {"Time": time, "Tempreture": temp, "ph": ph});
  }

  @override
  DataRow? getRow(dynamic index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['Time'].toString(), style: TextStyle(color: Colors.white))),
      DataCell(Text(_data[index]['Tempreture'].toString(), style: TextStyle(color: Colors.white))),
      DataCell(Text(_data[index]["ph"].toString(), style: TextStyle(color: Colors.white))),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => _data.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cap_4/sensor_reads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot){
            if (snapshot.hasError){
              print ('You have an error! ${snapshot.error.toString()}');
              return Text('Something went wrong');
            }else if (snapshot.hasData){
              return MyHomePage(title: 'Flutter Demo Home Page');
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      //const
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[900],
      appBar: AppBar (
        title:  Text('Ph - Temperature data collector',
          style: TextStyle(color: Colors.white,
              fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan[800],
      ),
      body: Padding(padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text('Welcome to Ph - Temperature data collector',
                    style: TextStyle(color: Colors.white,
                        fontSize:30),
                    textAlign: TextAlign.center,
                  ),),
                SizedBox(height:50),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(
                        width: 2,
                        color: Colors.white
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => showReads()));
                  },
                  child: Text("Get started",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:40)),
                ),
              ])),
    );
  }
}

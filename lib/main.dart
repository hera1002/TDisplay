import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travels_displayboard/data/FetchData.dart';

import 'data/bus_schedule.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // Than we setup preferred orientations,
  // and only after it finished we run our app
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((value) => runApp(MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Future<List<BusSchedule>>? currentSchedule ;
  DataProvider _dataProvider = DataProvider();
  PageController _pageController = PageController( );
  int _currentPage = 0;
  late Timer _timer;
  List<List<BusSchedule>> chunks = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    setUpTimedFetch();
    setUpTimedPageTransition();

  }
  setUpTimedPageTransition(){

    Timer.periodic(Duration(seconds: 10), (timer) {
      print(chunks);
      if(chunks.isNotEmpty){
          if (_currentPage < chunks.length-1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: Duration(seconds: 3),
            curve: _currentPage!=0 ?Curves.easeIn:Curves.bounceIn,
          );
      }
    });

  }

  setUpTimedFetch() {
    Timer.periodic(Duration(seconds:60), (timer) {
      setState(()  {
        currentSchedule =  _dataProvider.getData();
        currentSchedule!.asStream().forEach((element) {
          print(element);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<BusSchedule>>(
            future: currentSchedule,
            builder: (context, snapshot){
              if (snapshot.connectionState == ConnectionState.done) {
                // If we got an error
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${snapshot.error} occured',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                  // if we got our data
                } else if (snapshot.hasData) {
                  List<BusSchedule> buslist=  snapshot.data!;
                  int chunkSize = 5;
                  chunks=[];
                  for (var i = 0; i < buslist.length; i += chunkSize) {
                    chunks.add(buslist.sublist(i, i+chunkSize > buslist.length ? buslist.length : i + chunkSize));
                  }
                  print(chunks.length);
                  return Center(
                    child: PageView.builder(
                      controller: _pageController,
                        itemCount: chunks.length,
                        itemBuilder: (BuildContext context,int pageIndex){
                               List<BusSchedule> pageData =  chunks[pageIndex];
                               print(pageIndex);
                              return  Center(

                                child: ListView.builder(
                                    itemCount: pageData.length,
                                    itemBuilder: (BuildContext context,int listIndex){
                                      return Card(
                                           child: Container(
                                             height: MediaQuery.of(context).size.height/6,
                                               child: Center(child: Text(pageData[listIndex].service.toString()))))
                                      ;
                                    }
                                ),
                              );
                    }
                    ),
                  );
                }
              }
              //Rest of your code
              return  CircularProgressIndicator(color: Colors.indigo,);
            }),
      )

    );
  }
}

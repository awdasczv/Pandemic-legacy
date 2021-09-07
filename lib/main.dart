import 'package:buttom_navigated_bar/DB.dart';
import 'package:flutter/material.dart';
import 'package:buttom_navigated_bar/Details.dart';
import 'package:buttom_navigated_bar/ShowCityList.dart';
import 'package:buttom_navigated_bar/Settings.dart';
import 'package:buttom_navigated_bar/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  final List<Widget> pages = [
    Home(),
    DetailsPage(),
    ShowCityList(),
    SettingPage()
  ];

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:IndexedStack(
        index: _currentPageIndex,
        children: [
          Home(),
          DetailsPage(),
          ShowCityList(),
          SettingPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index){
          setState(() {
            _currentPageIndex=index;
          });
        },
        currentIndex: _currentPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.details),label: '자세히'),
          BottomNavigationBarItem(icon: Icon(Icons.list),label: '도시목록'),
          BottomNavigationBarItem(icon: Icon(Icons.settings),label: '설정'),
        ],
      ),
    );
  }
}



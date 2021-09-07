import 'package:buttom_navigated_bar/DB.dart';
import 'package:flutter/material.dart';

class AddCity extends StatefulWidget {
  @override
  _AddCityState createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  final _tc1 = TextEditingController();
  final _tc2 = TextEditingController();
  final _tc3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('도시카드추가'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 10,),
                Text('도시 이름 : ',style: TextStyle(fontSize: 17),),
                Expanded(child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: _tc1,
                    decoration: InputDecoration(
                      hintText: '필수'
                    ),
                  ),
                ))
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10,),
                Text('도시카드 개수 : ',style: TextStyle(fontSize: 17),),
                Expanded(child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: _tc2,
                    decoration: InputDecoration(
                      hintText: '안적어도 ㄱㅊ'
                    ),
                  ),
                ))
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: (){
          _insertCity();
          Navigator.pop(context,1);
          },
      ),
    );
  }

  void _insertCity() async{
    List<String> _cityName = [];
    List<City> _res = [];
    List<City> _original = await readfile();

    if(_res.isNotEmpty || _cityName.isNotEmpty){_res.clear(); _cityName.clear();}

    for(int i = 0 ; i < _original.length ; i++){
      _cityName.add(_original[i].cityName);
    }

    if(_tc1.text.length > 0){_cityName.add(_tc1.text);}
    _cityName.sort();

    for(int i = 0 ; i < _cityName.length ; i++){
      _res.add(City(cityName: _cityName[i], id: i + 1, cardNum: 3));
    }

    writeFile(_res);
  }
}

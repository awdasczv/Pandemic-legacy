import 'package:buttom_navigated_bar/DB.dart';
import 'package:flutter/material.dart';

class Vaccine extends StatefulWidget {
  final List<City> drawnCards;
  const Vaccine({Key? key, required this.drawnCards}) : super(key: key);

  @override
  _VaccineState createState() => _VaccineState();
}

class _VaccineState extends State<Vaccine> {
  late List<bool> _checkedList;
  late List<int> _cardNum;
  late List<City> _drawnCards;
  List<City> _list = [];
  List<City> _temp = [];
  List<City> _res = [];

  @override
  void initState() {
    super.initState();
    _drawnCards = widget.drawnCards;
    _list = _drawnCards.where((element) => element.cardNum! > 0).toList();
    _checkedList = List<bool>.filled(_drawnCards.length, false);
    _cardNum = List<int>.filled(_drawnCards.length, 0);

    if(_list.isNotEmpty || _temp.isNotEmpty){_list.clear(); _temp.clear();}

    for(int i = 0 ; i <_drawnCards.length ; i++){
      if(_drawnCards[i].cardNum! > 0){
        _list.add(City(cityName: _drawnCards[i].cityName, id: _drawnCards[i].id, cardNum: 0));
        _temp.add(City(cityName: _drawnCards[i].cityName, id: _drawnCards[i].id, cardNum: _drawnCards[i].cardNum));
      }
      _res.add(City(cityName: _drawnCards[i].cityName, id: _drawnCards[i].id, cardNum: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('백신'),
        actions: [
          ElevatedButton(
              onPressed: (){
                Navigator.pop(
                    context,
                    _list
                );
              },
              child: Text('완료'))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: Checkbox(
                        value: _checkedList[index],
                        onChanged: (bool? value){
                          setState(() {
                            _checkedList[index] = value!;
                            if(!_checkedList[index]) {
                              _cardNum[index] = 0;
                              _list[index].cardNum = 0;
                            }
                            if(_checkedList[index] && _cardNum[index] == 0) {
                              _cardNum[index]++;
                              _list[index].cardNum = _list[index].cardNum! + 1;
                            }
                          });
                        },
                      ),
                      title: Text(_list[index].cityName),
                      trailing: Container(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                onPressed: (){_decrease(index);},
                                icon: Icon(Icons.remove)),
                            Text(_cardNum[index].toString(),style: TextStyle(fontSize: 17),),
                            IconButton(
                                onPressed: (){_increase(index);},
                                icon: Icon(Icons.add)),
                          ],
                        ),
                      ),
                      onTap: (){_increase(index);},
                    );
                  }
              )
          )
        ],
      ),
    );
  }

  void _increase(int index){
    setState(() {
      if(_cardNum[index] < _temp[index].cardNum!)
      _cardNum[index]++;
      _list[index].cardNum = _list[index].cardNum! + 1;

      if(!_checkedList[index]){
        _checkedList[index] = true;
      }
    });
  }
  void _decrease(int index){
    setState(() {
      if(_cardNum[index] > 0) {
        _cardNum[index]--;
        _list[index].cardNum = _list[index].cardNum! - 1;
      }
      if(_cardNum[index]== 0){
        _checkedList[index] = false;
      }
    });
  }
}

import 'package:buttom_navigated_bar/DB.dart';
import 'package:flutter/material.dart';

class Infection extends StatefulWidget {
  final List<City> entireCity;
  final List<City> drawnCard;

  const Infection({Key? key, required this.entireCity,required this.drawnCard}) : super(key: key);

  @override
  _InfectionState createState() => _InfectionState();
}

class _InfectionState extends State<Infection> {
  late List<bool> _checkedList;
  late List<City> _drawnCards;
  bool _isCheck = false;
  int _checkedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    _checkedList =  List<bool>.filled(widget.entireCity.length,false);
    _drawnCards = widget.drawnCard;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _fun(int index){
      setState(() {
        if(_isCheck == true && _checkedIndex != index){
          _checkedList[_checkedIndex] = false;
          _checkedIndex = index;
          _checkedList[_checkedIndex] = true;
        }
        else if(_isCheck == true && _checkedIndex == index){
          _checkedList[index] = false;
          _isCheck = false;
        }
        else{
          _isCheck = true;
          _checkedList[index] = true;
          _checkedIndex = index;
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('감염/제일 아래카드 선택'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: ()async{
                if(_checkedList.where((element) => element == true).toList().length < 1){
                  List<List<City>>? a = await Navigator.push(context, MaterialPageRoute(builder: (context) => Infection2(drawnCards:_drawnCards)));
                  if(a != null){
                    Navigator.pop(context,a);
                  }
                }
                else{
                  _drawnCards[_checkedIndex].cardNum = _drawnCards[_checkedIndex].cardNum! + 1;
                  List<List<City>>? a = await Navigator.push(context, MaterialPageRoute(builder: (context) => Infection2(drawnCards:_drawnCards)));
                  if(a != null){
                    Navigator.pop(context,a);
                  }
                  else{
                    _drawnCards[_checkedIndex].cardNum = _drawnCards[_checkedIndex].cardNum! - 1;
                  }
                }
              },
              child: Text('도시카드 선택으로 이동')),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.entireCity.length,
                  itemBuilder: (BuildContext _ctx,int index){
                    return ListTile(
                      leading:  Checkbox(
                        checkColor: Colors.amberAccent,
                        value: _checkedList[index],
                        onChanged: (bool? value){_fun(index);},
                      ),
                      title: Text(widget.entireCity[index].cityName),
                      onTap: (){_fun(index);},
                    );
                  }
              )
          )
        ],
      ),
    );
  }
}

class Infection2 extends StatefulWidget {
  final List<City> drawnCards;
  const Infection2({Key? key, required this.drawnCards}) : super(key: key);

  @override
  _Infection2State createState() => _Infection2State();
}

class _Infection2State extends State<Infection2> {
  late List<bool> _checkedList;
  late List<int> _cardNum;
  late List<City> _drawnCards;
  late List<City> _temp;
  List<City> _list = [];
  List<City> _res = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _drawnCards = widget.drawnCards;
    _temp = _drawnCards.where((element) => element.cardNum! > 0).toList();

    _checkedList = List<bool>.filled(_drawnCards.length, false);
    _cardNum = List<int>.filled(_drawnCards.length, 0);

    if(_list.isNotEmpty){_list.clear();}

    for(int i = 0 ; i <_drawnCards.length ; i++){
      if(_drawnCards[i].cardNum! > 0){
        _list.add(City(cityName: _drawnCards[i].cityName, id: _drawnCards[i].id, cardNum: 0));
      }
      _res.add(City(cityName: _drawnCards[i].cityName, id: _drawnCards[i].id, cardNum: 0));
    }
  }

  @override
  Widget build(BuildContext context) {

    void _increase(int index){
      setState(() {
        if(_cardNum[index] < _temp[index].cardNum!){
          _cardNum[index]++;
          _list[index].cardNum = _list[index].cardNum! + 1;
        }

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

    return Scaffold(
      appBar: AppBar(
        title: Text('감염/카드 선택'),
        actions: [
          ElevatedButton(
              onPressed: (){
                for(int i = 0 ; i < _list.length; i++){
                  if(_list[i].cardNum! > 0){
                    _res[_list[i].id - 1].cardNum = _list[i].cardNum;
                    _drawnCards[_list[i].id - 1].cardNum = _drawnCards[_list[i].id - 1].cardNum! - _list[i].cardNum!;
                  }
                }
                Navigator.pop(
                    context,
                    [_drawnCards, _res]
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
}

import 'package:buttom_navigated_bar/Infection.dart';
import 'package:buttom_navigated_bar/Vaccine.dart';
import 'package:flutter/material.dart';
import 'package:buttom_navigated_bar/DB.dart';
import 'package:buttom_navigated_bar/Draw.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<int> _numofDrawCard = [2,2,2,3,3,4,4,5];
  List<City> _entireCard = [];
  List<City> _undrawnCard = [];
  List<List<City>> _newUndrawnCard = [];
  List<City> _drawnCities = [];
  int _currentPage = 0;
  int _phase = 1;
  int _sort = 1;
  int _turnAfterInfection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home / Phase = $_phase'),
        actions: [
          ElevatedButton(
              onPressed: ()async{
                var a = await showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('게임을 종료하시겠습니까?'),
                        actions: [
                          TextButton(onPressed: (){Navigator.pop(context,1);}, child: Text('예')),
                          TextButton(onPressed: (){Navigator.pop(context,2);}, child: Text('아니요')),
                        ],
                      );
                    }
                );
                if(a == 1){
                  setState(() {
                    _phase = 1;
                    _currentPage = 0;
                  });
                }

              },
              child: Text('게임종료')),
          SizedBox(width: 10,),
          IconButton(onPressed: (){setState(() {});}, icon: Icon(Icons.refresh))
        ],
      ),
      body: IndexedStack(
        index: _currentPage,
        children: [
          _gameStartPage(),
          _mainGame()
        ],
      )
    );
  }



  ListView _listView(List<City> _tmp){
    int _total = 0;

    for(int i = 0 ; i < _tmp.length ; i++){
      _total += _tmp[i].cardNum!;
    }

    _tmp.add(City(cityName: 'Total', id: _tmp.length , cardNum: _total));

    return ListView.separated(
      itemCount: (_tmp.length/2).ceil() + 1,
      itemBuilder: (BuildContext _ctx, int _idx){
        if(_idx == 0){
          return Table(
            children: [
              TableRow(
                children: [
                  Center(child: Text('도시명'),),
                  Center(child: Text('카드개수'),),
                  Center(child: Text('도시명'),),
                  Center(child: Text('카드개수'),),
                ]
              )
            ],
          );
        }
        else if(_idx == (_tmp.length/2).ceil()){
          if(_tmp.length.isOdd){
            return Table(
              children: [
                TableRow(
                    children: [
                      Center(child: Text(_tmp[_idx-1].cityName),),
                      Center(child: Text(_tmp[_idx-1].cardNum.toString()),),
                      Center(child: Text(''),),
                      Center(child: Text(''),),
                    ]
                )
              ],
            );
          }
          else return Table(
            children: [
              TableRow(
                  children: [
                    Center(child: Text(_tmp[_idx-1].cityName),),
                    Center(child: Text(_tmp[_idx-1].cardNum.toString()),),
                    Center(child: Text(_tmp[_idx - 1 + (_tmp.length/2).ceil()].cityName),),
                    Center(child: Text(_tmp[_idx - 1+ (_tmp.length/2).ceil()].cardNum.toString()),),
                  ]
              )
            ],
          );

        }
        else return Table(
            children: [
              TableRow(
                children: [
                  Center(child: Text(_tmp[_idx-1].cityName),),
                  Center(child: Text(_tmp[_idx-1].cardNum.toString()),),
                  Center(child: Text(_tmp[_idx - 1 + (_tmp.length/2).ceil()].cityName),),
                  Center(child: Text(_tmp[_idx - 1+ (_tmp.length/2).ceil()].cardNum.toString()),),
                ]
              )
            ],
          );
      },
      separatorBuilder:(BuildContext _ctx, int _idx){
        return Divider(
          thickness: 1,
          color: Colors.black,
          indent: 10,
          endIndent: 10,
        );
      }
    );
  }

  Center _gameStartPage(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          ElevatedButton(
              onPressed: () async{
                _entireCard = await readfile();
                if(_undrawnCard.isNotEmpty || _drawnCities.isNotEmpty || _newUndrawnCard.isNotEmpty){
                  _undrawnCard.clear();
                  _drawnCities.clear();
                  _newUndrawnCard.clear();
                }
                for(int i = 0 ; i < _entireCard.length ; i++){
                  _drawnCities.add(City(cityName: _entireCard[i].cityName, id: _entireCard[i].id, cardNum: 0));
                  _undrawnCard.add(City(cityName: _entireCard[i].cityName, id: _entireCard[i].id, cardNum: 0));
                }

                setState(() {
                  _currentPage =1;
                  _turnAfterInfection = 0;
                });

                },
              child: Text('게임 시작!!')),
          Spacer(),
          Text('앱 최초실행시(아예 처음 실행할때) 설정에서 최초설치 한번만 누르고 진행해주세요'),
        ],
      ),
    );
  }

  Center _mainGame(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: ()async{
                    int _total = 0;
                    for(int i = 0 ; i < _undrawnCard.length ; i++){
                      _total += _undrawnCard[i].cardNum!;
                    }
                    late List<City>? _getDrawnCard;
                    if(_undrawnCard.where((element) => element.cardNum! > 0).toList().length > 0 && _total > _numofDrawCard[_phase - 1]){
                      _getDrawnCard = await Navigator.push(context, MaterialPageRoute(builder: (context) => DrawPage(undrawnCard: _undrawnCard,)));
                    }
                    else{
                      _getDrawnCard = await Navigator.push(context, MaterialPageRoute(builder: (context) => DrawPage()));
                    }

                    List<City> _tmp = _drawnCities;
                    List<City> _tmp2 = _undrawnCard;
                    List<List<City>> _tmpnewUndrawncard = _newUndrawnCard;
                    for(int i = 0 ; i < _getDrawnCard!.length ; i++){
                      _tmp[_getDrawnCard[i].id -1].cardNum = _tmp[_getDrawnCard[i].id -1].cardNum! + _getDrawnCard[i].cardNum!; //버린카드더미 개수 증가
                      if(_phase > 1 && _undrawnCard.where((element) => element.cardNum! > 0).toList().length > 0) {
                        _tmp2[_getDrawnCard[i].id -1].cardNum = _tmp2[_getDrawnCard[i].id -1].cardNum! - _getDrawnCard[i].cardNum!;
                      } //덱에있는 카드 개수 감소
                      print(_getDrawnCard[i].cityName + ' / ' +_getDrawnCard[i].cardNum.toString());
                    }

                    for(int i = 0 ; i < _getDrawnCard.length ; i++){
                      for(int j = 0 ; j < _tmpnewUndrawncard.length ; j++){
                        _tmpnewUndrawncard[j][_getDrawnCard[i].id - 1].cardNum = _tmpnewUndrawncard[j][_getDrawnCard[i].id - 1].cardNum! - _getDrawnCard[i].cardNum!;
                        _getDrawnCard[i].cardNum = 0;
                        if(_tmpnewUndrawncard[j][_getDrawnCard[i].id - 1].cardNum! < 0){
                          _getDrawnCard[i].cardNum = -_tmpnewUndrawncard[j][_getDrawnCard[i].id - 1].cardNum!;
                          _tmpnewUndrawncard[j][_getDrawnCard[i].id - 1].cardNum = 0;
                        }
                      }
                    }

                    for(int i = 0 ; i < _tmpnewUndrawncard.length ; i++){
                      if(_tmpnewUndrawncard[i].where((element) => element.cardNum != 0).toList().length == 0){
                        _tmpnewUndrawncard.removeAt(i);
                        i--;
                      }
                    }

                    setState(() {
                      _drawnCities = _tmp;
                      _undrawnCard = _tmp2;
                      _newUndrawnCard = _tmpnewUndrawncard;
                      _turnAfterInfection++;
                    });

                  },
                  child: Text('드로우')),
              ElevatedButton(
                  onPressed: ()async{
                    List<City>? _get = await Navigator.push(context, MaterialPageRoute(builder: (context) => Vaccine(drawnCards: _drawnCities)));
                    List<City> _tmp = _drawnCities;
                    if(_get != null){
                      for(int i = 0 ; i < _get.length ; i++){
                        if(_get[i].cardNum! > 0){
                          _tmp[_get[i].id - 1].cardNum = _tmp[_get[i].id - 1].cardNum! - _get[i].cardNum!;
                        }
                      }
                      setState(() {
                        _drawnCities = _tmp;
                      });
                    }
                  },
                  child: Text('백신')),
              ElevatedButton(
                  onPressed: ()async{
                    List<List<City>>? a = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Infection(entireCity: _entireCard,drawnCard: _drawnCities)));
                    //a[0] => 덱으로 가야되는 카드들
                    //a[1] => 확산으로 뽑은카드들(버린카드더미로)
                    if(a != null){
                      List<City> _tmp = _undrawnCard;
                      List<List<City>> _temp2 = _newUndrawnCard;
                      _temp2.insert(0, a[0]);
                      for(int i = 0 ; i < a[0].length ; i++){
                        _tmp[i].cardNum = _tmp[i].cardNum! + a[0][i].cardNum!;
                      }

                      setState(() {
                        _phase++;
                        _drawnCities = a[1];
                        _undrawnCard = _tmp;
                        _newUndrawnCard = _temp2;
                        _turnAfterInfection = 1;
                      });
                    }
                    },
                  child: Text('사건발생')),
              ElevatedButton(onPressed: _sorting, child: Text('정렬')),
            ],
          ),
          Text('전염 후 $_turnAfterInfection번째 턴'),
          Divider(),
          Expanded(child: _listView( _drawnCities.where((element) => element.cardNum != 0).toList()),flex: 2,),
          Divider(),
          Expanded(child: _listView2( _undrawnCard.where((element) => element.cardNum != 0).toList(),_newUndrawnCard,_sort),flex: 3,)
        ],
      ),
    );
  }

  Future<void> _sorting() async{
    var a = await showDialog(
        context: context,
        builder: (BuildContext _ctx){
          return AlertDialog(
            title: Text('정렬기준'),
            content: Container(
              width: double.minPositive,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: <Widget>[
                  SimpleDialogOption(
                    child: Text('도시명순',style: TextStyle(fontSize: 17),), onPressed: (){Navigator.pop(context,1);},
                  ),
                  SimpleDialogOption(
                    child: Text('최근사건 카드개수순',style: TextStyle(fontSize: 17),),onPressed: (){Navigator.pop(context,2);},
                  ),
                  SimpleDialogOption(
                    child: Text('1장 확률순',style: TextStyle(fontSize: 17),),onPressed: (){Navigator.pop(context,3);},
                  ),
                  SimpleDialogOption(
                    child: Text('2장 확률순',style: TextStyle(fontSize: 17),),onPressed: (){Navigator.pop(context,4);},
                  ),
                  SimpleDialogOption(
                    child: Text('3장 확률순',style: TextStyle(fontSize: 17),),onPressed: (){Navigator.pop(context,5);},
                  ),
                ],
              ),
            ),
          );
        }
    );
    setState(() {
      _sort = a;
    });
  }

  ListView _listView2(List<City> _unDrawn,List<List<City>> _data, int sort){//sort 1 => 도시 이름순, sort 2 => 확률순(카드개수순)

    if(sort == 1){_unDrawn.sort((a,b) => a.cityName.compareTo(b.cityName));}
    else if(sort == 2){_unDrawn.sort((b,a) => _data[0][a.id - 1].cardNum!.compareTo(_data[0][b.id - 1].cardNum!));}
    else if (sort == 3){_unDrawn.sort((b,a) => _calPercentN(_data, a.id ,1).compareTo(_calPercentN(_data, b.id ,1)));}
    else if (sort == 4){_unDrawn.sort((b,a) => _calPercentN(_data, a.id ,2).compareTo(_calPercentN(_data, b.id ,2)));}
    else if (sort == 4){_unDrawn.sort((b,a) => _calPercentN(_data, a.id ,2).compareTo(_calPercentN(_data, b.id ,3)));}

    return ListView.separated(
        itemCount: _unDrawn.length + 1,
        itemBuilder: (BuildContext _ctx, int _idx){
          if(_idx == 0){
            return Table(
              children: [
                TableRow(
                    children: [
                      Center(child: Text('도시명'),),
                      Center(child: Text('최근사건\n카드개수'),),
                      Center(child: Text('1장 나올 %'),),
                      Center(child: Text('2장 나올 %'),),
                      Center(child: Text('3장 나올 %'),),

                    ]
                )
              ],
            );
          }
          else return Table(
            children: [
              TableRow(
                  children:[
                    Center(child: Text(_unDrawn[_idx-1].cityName),),
                    Center(child: Text(_data[0][_unDrawn[_idx - 1].id - 1].cardNum.toString())),
                    Center(child: Text(_calPercentN(_data, _unDrawn[_idx - 1].id,1).toStringAsFixed(2)),),
                    Center(child: Text(_calPercentN(_data, _unDrawn[_idx - 1].id,2).toStringAsFixed(2)),),
                    Center(child: Text(_calPercentN(_data, _unDrawn[_idx - 1].id,3).toStringAsFixed(2)),),

                  ]
              )
            ],
          );
        },
        separatorBuilder:(BuildContext _ctx, int _idx){
          return Divider(
            thickness: 1,
            color: Colors.black,
            indent: 10,
            endIndent: 10,
          );
        }
    );
  }


  double _calPercentN( List<List<City>> _originalData, int id, int n){//n => 4장을 뽑는데 트리폴리가 n장 나올 확률
    List<List<City>> _data = [];
    for(int i = 0 ; i < _originalData.length ; i++){
      List<City> _tempData = [];
      for(int j = 0 ; j < _originalData[i].length ; j++){
        _tempData.add(City(cityName: _originalData[i][j].cityName, cardNum: _originalData[i][j].cardNum, id: _originalData[i][j].id));
      }
      _data.add(_tempData);
    }

    int _drawCardNum = _numofDrawCard[_phase - 1]; //_drawCardNum 만큼의 장수를 뽑음

    for(int i = 0; i < _data.length ; i++){

      int _total = 0;
      for(int j = 0 ; j < _data[i].length ; j++){
        _total += _data[i][j].cardNum!;
      }

      if(_drawCardNum <= _total){

        int _son = _combination(_data[i][id - 1].cardNum!, n) * _combination(_total - _data[i][id - 1].cardNum!, _drawCardNum - n);
        int _par = _combination(_total, _drawCardNum);
        return 100*_son/_par;
      }
      else{
        if(_data[i][id - 1].cardNum! >= n) return 100;
        else{
          n -= _data[i][id - 1].cardNum!;
          _data[i][id - 1].cardNum = 0;
          _drawCardNum -= _total;
        }
      }
    }
    return 0;
  }

  int _combination(int a, int b){
    if(a<b) return 0;
    int _son = _fact(a);
    int _parent = _fact(b)*_fact(a-b);
    return _son~/_parent;
  }

  int _fact(int a){
    int _res = 1;
    while(a>1){
      _res = _res*a;
      a--;
    }
    return _res;
  }

}


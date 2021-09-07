import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buttom_navigated_bar/DB.dart';

class DrawPage extends StatefulWidget {
  final List<City>? undrawnCard;
  const DrawPage({Key? key, this.undrawnCard}) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  final _tc = TextEditingController();

  late Future<List<City>> _citylist;
  List<City> _nowcitylist = [];

  late List<bool> _checkedList;
  late List<int> _cardNum;
  late String _isnull;

  List<City> _drawedcard = [];


  @override
  void initState() {
    super.initState();

    if(widget.undrawnCard == null){
      _citylist = readfile().then(
              (value){
            _checkedList =  List<bool>.filled(value.length,false) ;
            _cardNum = List<int>.filled(value.length,0);
            _nowcitylist = value;
            return value;
          }
      );
      _isnull = 'null';
    }
    else {
      List<City> _tmp = widget.undrawnCard!.where((element) => element.cardNum != 0).toList();
      _checkedList =  List<bool>.filled(_tmp.length,false) ;
      _cardNum = List<int>.filled(_tmp.length,0);
      _nowcitylist = _tmp;
      _isnull = 'hasdata';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('드로우' + '/' + _isnull),
        actions: <Widget>[
          OutlinedButton(
              onPressed: (){
                _drawCard(context, _nowcitylist);
              },
              child: Text('드로우',style: TextStyle(color: Colors.white,fontSize: 17),),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: TextField(
              controller: _tc,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '검색',
                  hintText: '검색할 도시를 입력하세요'
              ),
              onChanged: (String txt){setState(() {});},
            ),
          ),
          _widget()
        ],
      ),
    );
  }

  Widget _widget(){
    if(widget.undrawnCard == null){
      return FutureBuilder(
        future: _citylist,
        builder: (context,snapshot){
          if(snapshot.hasData){
            List<City> _tempCityList = snapshot.data as List<City>;
            return Expanded(
              child: _listView(_tempCityList),
            );
          }
          else return Text("${snapshot.error}");
        },
      );
    }
    else return Expanded(child: _listView(widget.undrawnCard!.where((element) => element.cardNum != 0).toList()));
  }

  ListView _listView(List<City> _data){
    void _func(int index){
      setState(() {
        if(_cardNum[index] < _data[index].cardNum!) _cardNum[index]++;
        if(!_checkedList[index]){
          _checkedList[index] = true;
        }
      });
    }
    return ListView.builder(
        itemCount: _data.where((element) => element.cityName.startsWith(_tc.text)).toList().length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            onTap: (){_func(index);},
            leading: Checkbox(
              checkColor: Colors.amberAccent,
              value: _checkedList[index],
              onChanged: (bool? value){
                setState(() {
                  _checkedList[index] = value!;
                  if(!_checkedList[index]) _cardNum[index] = 0;
                  if(_checkedList[index] && _cardNum[index] == 0) _cardNum[index]++;
                });
              },
            ),
            title: Text(_data.where((element) => element.cityName.startsWith(_tc.text)).toList()[index].cityName),
            trailing: Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                      onPressed: (){
                        setState(() {
                          if(_cardNum[index] > 0) _cardNum[index]--;
                          if(_cardNum[index]== 0){
                            _checkedList[index] = false;
                          }
                        });
                      },
                      icon: Icon(Icons.remove)),
                  Text(_cardNum[index].toString(),style: TextStyle(fontSize: 17),),
                  IconButton(
                      onPressed: (){_func(index);},
                      icon: Icon(Icons.add)),
                ],
              ),
            ),
          );
        }
    );
  }

  void _drawCard(BuildContext _ctx, List<City> _data)async{

    for(int i = 0 ; i < _data.length ; i++){
      if(_checkedList[i]){
        _drawedcard.add(City(id:_data[i].id,cityName: _data[i].cityName,cardNum: _cardNum[i]));
      }
    }
    Navigator.pop(_ctx, _drawedcard);
  }

  GridView _gridView(List<City> _data){
    return GridView.builder(
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          childAspectRatio: 2.3
        ),
        shrinkWrap: true,
        itemCount: _data.length,
        itemBuilder: (context, index){
          return OutlinedButton(onPressed: (){}, child: Text(_data[index].cityName,style: TextStyle(fontSize: 17),));
        }
    );
  }

  Future<void> _alertDialog(BuildContext _ctx)async{
    List<City> _tmp = [];
    if(_tmp.isNotEmpty) {_tmp.clear();}
    for(int i = 0 ; i < _nowcitylist.length ; i++){
      if(_checkedList[i]){
        _tmp.add(City(id:_nowcitylist[i].id,cityName: _nowcitylist[i].cityName,cardNum: _cardNum[i]));
      }
    }
    var a = await showDialog(
        context: context,
        builder: (BuildContext context)  {
          return AlertDialog(
            title: Text('백신하시겠습니까?'),
            content:  Container(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: _tmp.where((element) => element.cardNum! > 0).toList().length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Text('${_tmp.where((element) => element.cardNum! > 0).toList()[index].cityName}카드 ${_tmp.where((element) => element.cardNum! > 0).toList()[index].cardNum}장'),
                    );
                  }
              ),
            ),
            actions: [
              TextButton(
                child: Text('예'),
                onPressed: (){Navigator.pop(context,1);},
              ),
              TextButton(
                child: Text('아니요'),
                onPressed: (){Navigator.pop(context,2);},
              ),
            ],
          );
        }
    );
    if(a == 1){
      Navigator.pop(_ctx);
    } else print('a=2');
  }
}


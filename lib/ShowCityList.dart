import 'package:buttom_navigated_bar/AddCity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buttom_navigated_bar/DB.dart';

class ShowCityList extends StatefulWidget {
  const ShowCityList({Key? key}) : super(key: key);

  @override
  _ShowCityListState createState() => _ShowCityListState();
}

class _ShowCityListState extends State<ShowCityList> {

  late Future<List<City>> _futureCityList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _futureCityList = readfile();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '도시목록'
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _futureCityList = readfile();
                });
              })
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
                future: _futureCityList,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return Expanded(child: _listView(snapshot.data as List<City>));
                  }
                  else if (snapshot.hasError){return Text("errorrororor");}
                  return CircularProgressIndicator();
                }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCity()));
          setState(() {
            _futureCityList = readfile();
          });
          },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _listView(List<City> _data){
    return ListView.builder(
      itemCount: _data.length + 1,
      itemBuilder: (BuildContext context, int index){
        if(index == 0){
          return ListTile(
            title: Table(
              children: [
                TableRow(
                    children: [
                      Center(child: Text('id',style: _textStyle(),), ),
                      Center(child: Text('CityName',style: _textStyle()),),
                      Center(child: Text('CardNum',style: _textStyle()))
                    ]
                ),
              ],
            ),
          );
        }
        else return ListTile(
          title: Table(
            children: [
              TableRow(
                  children: [
                    Center(child: Text(_data[index - 1].id.toString()),),
                    Center(child: Text(_data[index - 1].cityName),),
                    Center(child: Text(_data[index - 1].cardNum.toString()),),
                  ]
              ),
            ],
          ),
          onLongPress: () async{
            var a = await showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text(_data[index-1].cityName + "카드를 제거하겠습니까?"),
                    actions: [
                      TextButton(onPressed: (){Navigator.pop(context,1);}, child: Text('예')),
                      TextButton(onPressed: (){Navigator.pop(context,2);}, child: Text('아니요')),
                    ],
                  );
                }
            );

            if(a==1){
              await _deleteCard(_data,index);
            }

          },
        );
      },
    );
  }
  TextStyle _textStyle(){
    return TextStyle(
      fontSize: 17
    );
  }
  Future<void> _deleteCard (List<City> _data,int _id)async{
    for(int i = _id - 1 ; i < _data.length ; i++){
      _data[i].id--;
    }
    _data.removeAt(_id - 1);
    writeFile(_data).then(
            (value){
              setState(() {
                _futureCityList =  readfile();
              });
              return value;
            }
    );
  }

}

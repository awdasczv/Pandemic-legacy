import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class City{
  String cityName;
  int id;
  int? cardNum;

  City({required this.cityName,required this.id,this.cardNum});

  factory City.fromString(String _data){
    List<String> _tmp = _data.split(' ');
    return City(
      id: int.parse(_tmp[0]),
      cityName: _tmp[1],
      cardNum: int.parse(_tmp[2])
    );
  }
  factory City.fromStringButZero(String _data){
    List<String> _tmp = _data.split(' ');
    return City(
        id: int.parse(_tmp[0]),
        cityName: _tmp[1],
        cardNum: 0
    );
  }
}

List<String> cities = ["샌프란시스코","부에노스","리야드","바그다드", "테헤란", "모스크바", "이스탄불", "프랑크푸르트", "상트페테르브루크", "파리", "런던",
  "라고스", "산티아고", "덴버", "상파울루", "리마", "보고타", "뉴욕", "워싱턴", "잭슨빌", "멕시코시티", "애틀란타", "시카고", "로스앤젤레스", "트리폴리"
];

Future<String> get _localPath async{
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async{
  final path = await _localPath;
  return File('$path/City_File.txt');
}

Future<List<City>> readfile() async{
  List<String> _tmp = [];
  List<City> _res = [];

  final _path = await _localPath;
  final _file = File('$_path.City_File.txt');
  String _str = await _file.readAsString(encoding: utf8);

  _tmp = _str.split('\n');
  print('readFile');
  for(int i = 0 ; i < _tmp.length ; i++){
    _res.add(City.fromString(_tmp[i]));
  }
  return _res;
}

Future<void> tmpwriteFile() async{

  final _path = await _localPath;
  final _file = File('$_path.City_File.txt');
  print('tmpwriteFile');
  await _file.writeAsString("01 뉴뭄바이 3\n02 뉴욕 3\n03 덴버 3\n04 델리 3\n05 라고스 3\n06 런던 3\n07 로스앤젤레스 3\n08 리마 3\n"
      "09 리야드 3\n10 멕시코시티 3\n11 모스크바 3\n12 바그다드 3\n13 보고타 3\n14 부에노스아이레스 3\n"
      "15 산티아고 3\n16 상트페테르부르크 3\n17 상파울루 3\n18 샌프란시스코 3\n19 시카고 3\n20 애틀란타 3\n"
      "21 워싱턴 3\n22 이스탄불 3\n23 잭슨빌 3\n24 카이로 3\n25 킨샤샤 3\n26 테헤란 3\n27 트리폴리 3\n28 파리 3\n29 프랑크푸르트 3");
}

Future<void> tmpwriteFile2() async{
  final _path = await _localPath;
  final _file = File('$_path.City_File.txt');
  print('tmpwriteFile');
  await _file.writeAsString("1 뉴욕 3\n2 델리 3\n3 도쿄 3\n4 라고스 3\n5 런던 3\n6 로스앤젤레스 3\n7 리마 3\n8 리야드 3\n9 마닐라 3\n"
      "10 마드리드 3\n11 마이애미 3\n12 멕시코시티 3\n13 모스크바 3\n14 몬트리올 3\n15 뭄바이 3\n16 밀라노 3\n17 바그다드 3\n18 바리 3\n"
      "19 방콩 3\n20 베이징 3\n21 보고타 3\n22 부에노스아이레스 3\n23 산티아고 3\n24 상트페테르부르크 3\n25 상파울루 3\n26 상하이 3\n"
      "27 서울 3\n28 센프란시스코 3\n29 시드니 3\n30 시카고 3\n31 알제 3\n32 애틀란타 3\n33 에센 3\n34 오사카 3\n35 요하네스버그 3\n"
      "36 워싱턴 3\n37 이스탄불 3\n38 자카르타 3\n39 첸나이 3\n40 카라치 3\n41 카르툼 3\n42 카이로 3\n43 콜카타 3\n44 킨샤샤 3\n"
      "45 타이베이 3\n46 테헤란 3\n47 파리 3\n48 호치민시티 3\n49 홍콩 3");
}

Future<void> writeFile(List<City> data) async{
  if(data.isEmpty) {print('No data to write'); return;}
  final _path = await _localPath;
  final _file = File('$_path.City_File.txt');
  print('Write File');

  String _buff = "";
  for(int i = 0 ; i < data.length - 1; i++){
    _buff = _buff + data[i].id.toString() + " " + data[i].cityName + " " + data[i].cardNum.toString() + "\n";
  }
  _buff = _buff + data.last.id.toString() + " " + data.last.cityName + " " + data.last.cardNum.toString();

  await _file.writeAsString(_buff);
}

void printCityList(List<City>? _list){
  if(_list != null){
    for(int i = 0 ; i < _list.length ; i++){
      print('id = ${_list[i].id}\t / cityName = ${_list[i].cityName}\t\t/ cardNum = ${_list[i].cardNum}');
    }
  }
}

void printData() async{
  final _path = await _localPath;
  final _file = File('$_path.City_File.txt');
  String _str = await _file.readAsString(encoding: utf8);
  print(_str);
}

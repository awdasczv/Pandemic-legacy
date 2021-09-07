import 'package:buttom_navigated_bar/AddCity.dart';
import 'package:flutter/material.dart';
import 'package:buttom_navigated_bar/DB.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('최초 설치(시즌 1)',style: TextStyle(fontSize: 18),),
                      onTap: ()async{
                        var a = await showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('최초설치(시즌 1) 진행하시겠습니까?'),
                                actions: [
                                  TextButton(onPressed: (){Navigator.pop(context,1);}, child: Text('예')),
                                  TextButton(onPressed: (){Navigator.pop(context,2);}, child: Text('아니요')),
                                ],
                              );
                            }
                        );
                        if(a == 1){
                          tmpwriteFile2();
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('최초설치(시즌 1) 완료!'),
                                  actions: [
                                    TextButton(onPressed: (){Navigator.pop(context);}, child: Text('확인'))
                                  ],
                                );
                              }
                          );
                        }
                      },
                    ),
                    ListTile(
                      title: Text('최초 설치(시즌 2)',style: TextStyle(fontSize: 18),),
                      onTap: ()async{
                        var a = await showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('최초설치(시즌 2) 진행하시겠습니까?'),
                                actions: [
                                  TextButton(onPressed: (){Navigator.pop(context,1);}, child: Text('예')),
                                  TextButton(onPressed: (){Navigator.pop(context,2);}, child: Text('아니요')),
                                ],
                              );
                            }
                        );
                        if(a == 1){
                          tmpwriteFile();
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text('최초설치(시즌 2) 완료!'),
                                  actions: [
                                    TextButton(onPressed: (){Navigator.pop(context);}, child: Text('확인'))
                                  ],
                                );
                              }
                          );
                        }
                        },
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}

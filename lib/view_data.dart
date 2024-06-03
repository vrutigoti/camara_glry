

import 'dart:io';

import 'package:camara_glry/edit_data.dart';
import 'package:camara_glry/first.dart';
import 'package:flutter/material.dart';

class view_data extends StatefulWidget {
  const view_data({super.key});

  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {
  List <Map> l=[];
  bool s=true;
  List name=[];
  List t_name=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }
  get()
  {
    String sql="select * from student1";
    first.database!.rawQuery(sql).then((value) {
      l=value;


      for(int i=0;i<l.length;i++)
        {
          name.add(l[i]['name']);
        }
      t_name=name;
      print(l);
      setState(() {

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (s)?TextField(
          onChanged: (value) {
            name=t_name.where((element) => element.toString().startsWith(value)).toList();
            setState(() {

            });
          },
          autofocus: true,
          cursorColor: Colors.black,
        ):null,
        actions: [
          IconButton(onPressed: () {
            s=!s;
            setState(() {
              
            });
          }, icon: (s)?Icon(Icons.close):Icon(Icons.search_rounded))
        ],
        backgroundColor: Colors.pink,
      ),
      body: ListView.builder(itemCount: name.length,itemBuilder: (context, index) {
        int originalindex=t_name.indexOf(name[index]);
        print(originalindex);
        print(name[index]);
        String img_path="${first.dir!.path}/${l[originalindex]['image']}";
        File f=File(img_path);

        return Card(
          child: ListTile(
            title: Text("${l[originalindex]['name']}"),
            subtitle: Text("${l[originalindex]['contact']}") ,
            leading: CircleAvatar(
              backgroundImage: FileImage(f),
            ),
            trailing: Wrap(
              children: [
                IconButton(onPressed: () {
                  String sql="delete from student1 where id=${l[originalindex]['id']}";
                  first.database!.rawDelete(sql);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return view_data();
                  },));
                  setState(() {

                  });

                }, icon: Icon(Icons.delete)),
                IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return edit_data(l[index]);
                  },));
                }, icon: Icon(Icons.edit))
              ],
            ),
          ),
        );
      },),
    );
  }
}
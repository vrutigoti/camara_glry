

import 'dart:io';
import 'dart:math';

import 'package:camara_glry/view_data.dart';
import 'package:email_validator/email_validator.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main()
{
  runApp(MaterialApp(
    home: first(),
    debugShowCheckedModeBanner: false,
  ));
}class first extends StatefulWidget {
  static Directory ? dir;
  static Database ? database;

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  final ImagePicker picker = ImagePicker();
  XFile? image;
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  TextEditingController t4=TextEditingController();
  String gender="";
  String city="surat";
  bool  t=false;
  bool error_name=false;
  bool error_contact=false;
  bool error_email=false;
  bool error_password=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
    data();
  }
  data()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');


// open the database
    first.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE student1 (id INTEGER PRIMARY KEY, name TEXT,contact TEXT,email TEXT,password TEXT,city TEXT,gender TEXT,image TEXT )');
        });
  }
  get()
  async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
    var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/pic";
    print(path);

    first.dir=Directory(path);
    if(! await first.dir!.exists())
    {
      first.dir!.create();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Photo Gallary"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Enter Name",
                errorText: (error_name)?"Enter Name":null),
            controller: t1,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter Contact",
                 errorText: (error_contact)?"Enter Valid Number":null),
            controller: t2,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter email",
                errorText: (error_email)?"Enter Valid email":null),
            controller: t3,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter password",
                errorText: (error_password)?"Enter Valid password":null),
            controller: t4,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RadioMenuButton(value: 'male', groupValue: gender, onChanged: (value) {
                gender=value!;
                setState(() {

                });
              }, child: Text("Male")),
              RadioMenuButton(value: 'female', groupValue: gender, onChanged: (value) {
                gender=value!;
                setState(() {
                });
              }, child: Text("Female")),
            ],
          ),
          DropdownButton(value: city, items:[DropdownMenuItem(child: Text("surat"),value: "surat"),
            DropdownMenuItem(child: Text("baroda"),value: "baroda"),
            DropdownMenuItem(child: Text("vapi"),value: "vapi"),
            DropdownMenuItem(child: Text("valsad"),value: "valsad"),
            DropdownMenuItem(child: Text("amreli"),value: "amreli"),
            DropdownMenuItem(child: Text("ahemdabad"),value: "ahemdabad"),

          ],onChanged:(value) {
            city=value.toString();
            setState(() {

            });
          },),
          ElevatedButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Choose any one"),
                actions: [
                  Row(
                    children: [

                      TextButton(onPressed: () async {
                        image = await picker.pickImage(source: ImageSource.camera);
                        t=true;
                        Navigator.pop(context);
                        setState(() {

                        });
                      }, child: Text("Camera")),
                      TextButton(onPressed: () async {
                        image = await picker.pickImage(source: ImageSource.gallery);
                        t=true;
                        Navigator.pop(context);
                        setState(() {

                        });
                      }, child: Text("Gallary"))
                    ],
                  )
                ],
              );
            },);
          }, child: Text("Choose")),
          Row(
            children: [
              Container(
                  height: 200,
                  width: 200,
                  color: Colors.pinkAccent,
                  child: (t)?(image!=null)?Image.file(File(image!.path)):null:null
              ),
            ],

          ),
          ElevatedButton(onPressed: () async {
    String name=t1.text;
    String contact=t2.text;
    String email=t3.text;
    String password=t4.text;

    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if(name=="")
    {
    error_name=true;
    }
    if(contact==""|| !regExp.hasMatch(contact))
    {
    error_contact=true;
    }
   else
   {
     error_contact=false;
   }

    if(email.trim()==""|| !EmailValidator.validate(email.trim()))
    {
    error_email=true;
    }
   else
   {
     error_email=false;
   }
    if(password=="")
    {
    error_password=true;
    }
    setState(() {

    });
    if(!error_name && !error_contact && !error_email && !error_password) {
      int r = Random().nextInt(100);
      String img_name = "${r}img.png";

      File f = File('${first.dir!.path}/${img_name}');
      await f.writeAsBytes(await image!.readAsBytes());
      String qry = "insert into student1 values(null,'$name','$contact','$email','$password','$city','$gender','$img_name')";
      first.database!.rawInsert(qry);
      print(qry);
      // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //   return view_data();
      // },));
      setState(() {

      });
    }
    },
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return view_data();
            // },));
    child: Text("Add")),
    ElevatedButton(onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return view_data();
    },));
    }, child: Text("View")),


    ]
      ),
    );
  }
}
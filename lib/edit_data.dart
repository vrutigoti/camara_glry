import 'dart:io';
import 'dart:math';

import 'package:camara_glry/first.dart';
import 'package:camara_glry/view_data.dart';
//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class edit_data extends StatefulWidget {
Map l;
edit_data (this.l);

  @override
  State<edit_data> createState() => _edit_dataState();
}

class _edit_dataState extends State<edit_data> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String new_img="";
  File ? file;
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  TextEditingController t4=TextEditingController();
  String gen="";
  String city="surat";
  bool  t=false;
  // bool error_name=false;
  // bool error_contact=false;
  // bool error_email=false;
  // bool error_password=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.l);
    if(widget.l!=null)
      {
        t1.text=widget.l['name'];
        t2.text=widget.l['contact'];
        t3.text=widget.l['email'];
        t4.text=widget.l['password'];
        gen=widget.l['gender'];
        city=widget.l['city'];
        new_img=widget.l['image'];


        String new_path="${first.dir!.path}/${widget.l['image']}";
        file=File(new_path);
        setState(() {

        });
      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Edit Data"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Enter Name"),
            controller: t1,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter Contact"),
            controller: t2,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter email"),
            controller: t3,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Enter password"),
            controller: t4,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RadioMenuButton(value: 'male', groupValue: gen, onChanged: (value) {
                gen=value!;
                setState(() {

                });
              }, child: Text("Male")),
              RadioMenuButton(value: 'female', groupValue: gen, onChanged: (value) {
                gen=value!;
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
                  child: (t)?Image.file(File(image!.path)):Image.file(file!)
              ),
            ],

          ),
          ElevatedButton(onPressed: () async {
            String name=t1.text;
            String contact=t2.text;
            String email=t3.text;
            String password=t4.text;

            // String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
            // RegExp regExp = new RegExp(patttern);
            // if(name=="")
            // {
            //   error_name=true;
            // }
            // if(contact=="")
            // {
            //   error_contact=true;
            // }
            // else if (contact=="" || !regExp.hasMatch(contact)) {
            //   error_contact=true;
            // }
            // if(email.trim()=="")
            // {
            //   error_email=true;
            // }
            // else if(email.trim()=="" || !EmailValidator.validate(email.trim()))
            // {
            //   error_email=true;
            // }
            // if(password=="")
            // {
            //   error_password=true;
            // }
            // setState(() {
            //
            // });


            if(image!=null)
              {
                File file1=File("${first.dir!.path}/$new_img");
                file1.delete();
                new_img="${Random().nextInt(100)}.png";
                File f=File("${first.dir!.path}/${new_img}");
                f.writeAsBytes(await image!.readAsBytes());

              }

           String sql="update student2 set name='$name',contact='$contact',email='$email',password='$password',"
               "gender='$gen',city='$city',image='$new_img' where id=${widget.l['id']}";
            first.database!.rawUpdate(sql);
            setState(() {

            });


          }, child: Text("Add")),
          ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return view_data();
            },));
          }, child: Text("View")),

        ],
      ),
    );
  }
}


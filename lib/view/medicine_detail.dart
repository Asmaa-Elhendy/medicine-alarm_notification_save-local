import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/painting.dart';

class MedicineDetail extends StatefulWidget {
  String ?payload;
  String title;
  String description;
  String imagpath;
  String datefrompicker;
  String selectedshow;
  MedicineDetail({required this.payload,required this.title,required this.description,required this.imagpath,required this.datefrompicker,required this.selectedshow});

  @override
  _MedicineDetailState createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetail> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    var date=DateTime.parse(widget.datefrompicker);
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.all(height*.03),
                child: CircleAvatar(backgroundImage:FileImage(File(widget.imagpath)),radius: 85,),
              ),
              Text(widget.title,style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.blue),),
              SizedBox(height: height*.06,),
                Text(widget.description,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.blue),),
              SizedBox(height: height*.06,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text(widget.selectedshow,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.blue),),
                     SizedBox(width: width*.1,),
                     Text('${date.year}-${date.month}-${date.day}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.blue),),
                   ],
                 )

            ],
          )
        ],
      ),
    );
  }
}

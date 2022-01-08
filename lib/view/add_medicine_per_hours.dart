import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:medicine_alarm/controller/database_connection.dart';
import 'package:medicine_alarm/controller/dateprovider.dart';
import 'package:medicine_alarm/controller/getdatabaseprovider.dart';
import 'package:medicine_alarm/controller/notification.dart';
import 'package:medicine_alarm/controller/timer_provider.dart';
import 'package:medicine_alarm/model/medicine_model.dart';
import 'package:medicine_alarm/view/widgets/alert_camera.dart';
import 'package:medicine_alarm/view/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class ADDNewMedicinePerHours extends StatefulWidget {
  const ADDNewMedicinePerHours({Key? key}) : super(key: key);

  @override
  _ADDNewMedicinePerHoursState createState() => _ADDNewMedicinePerHoursState();
}

class _ADDNewMedicinePerHoursState extends State<ADDNewMedicinePerHours> {
  late  XFile? imgpicked;
  File?  file=null;
  late int hours=0;
  late int minute=0;
  TextEditingController _titleEditingController=TextEditingController();
  TextEditingController _bodyEditingController=TextEditingController();
  TextEditingController _timeEditingController=TextEditingController();
  DatabaseConnection databaseConnection=DatabaseConnection();
  ImagePicker imagePicker = ImagePicker();
 Timer? timer;
  var  selectedshow='';
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    GetDataBaseProvider providerdatabase= Provider.of<GetDataBaseProvider>(context);
    DateProvider dateprovider= Provider.of<DateProvider>(context);
    Timerprovider timerprovider= Provider.of<Timerprovider>(context);
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus;
        currentFocus=FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }},
      child: Scaffold(
        body:   ListView(
          children: [
            Padding(
              padding:  EdgeInsets.only(top:height*.12),
              child: Center(
                child: Column(
                  children: [
                    file==null? GestureDetector(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:  Colors.transparent.withOpacity(.1),
                        child: const Icon(Icons.add_a_photo_outlined,color: Colors.blue,size: 40,),
                      ),onTap: (){
                      AlertCameraOrDate.showMyDialog(context,true,uploadImagefromcamera,uploadImagefromgallery);

                    },
                    ):Stack(
                      children: [
                        CircleAvatar(radius: 60,
                            backgroundColor: Colors.grey.withOpacity(.3),
                            backgroundImage:FileImage(file!)),
                        Padding(
                            padding:EdgeInsets.only(top: height*.09,left: width*.2 ),
                            child: IconButton(onPressed: (){
                              AlertCameraOrDate.showMyDialog(context,true,uploadImagefromcamera,uploadImagefromgallery);
                            }, icon: const Icon(Icons.add_a_photo,color: Colors.white,)))
                      ],
                    ),
                    Form(
                      child: Center(
                        child: Column(
                          children: [
                            FormDesign(title: 'title',controllerValue: _titleEditingController, icon: Icons.title,enabled: true,),
                            FormDesign(title: 'description',controllerValue: _bodyEditingController, icon: Icons.text_fields_sharp,enabled: true,),
                            FormDesign(title: 'time per hours',controllerValue: _timeEditingController, icon: Icons.timelapse,enabled: true,),


                            ElevatedButton(
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              style: ButtonStyle(
                                  overlayColor:  MaterialStateProperty.all<Color>(
                                      Colors.grey.withOpacity(.5)),
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                            color: Colors.blue,
                                          )))),
                              onPressed: ()async {
                                var medicine_item=Medicine(title: _titleEditingController.text, description: _bodyEditingController.text, hour: hours, minute: minute, imageFile:imgpicked!.path,selectedshow: selectedshow,datefrompicker: dateprovider.date.toString());
                                try{
                                  providerdatabase.savedatabase(medicine_item);
                                  print(medicine_item.imageFile);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                                  // اعمل متغير ادخل عدد الساعات كل ساعتين مثلا
                               // for (int i=0; i<=3;i++){ //3 عدد المرات
                               //   await NotificationClass.showScheduledNotification(
                               //       id:Random().nextInt(100000),
                               //       scheduledate:DateTime.now().add(Duration(minutes: 2)),
                               //       title: medicine_item.title+'$i',
                               //       body: medicine_item.description,
                               //       payload: medicine_item.title,
                               //       bigpicturepath: medicine_item.imageFile
                               //   );
                               // }
                  timer =   Timer.periodic(Duration(minutes: 2), (Timer t) async {
                              await NotificationClass.showScheduledNotification(
                                  id:Random().nextInt(100000),
                                  scheduledate:DateTime.now().add(Duration(seconds: 2)),
                                  title: medicine_item.title,
                                  body: medicine_item.description,
                                  payload: medicine_item.title,
                                  bigpicturepath: medicine_item.imageFile
                              );
                              print(timer.toString());
                              print(timer.runtimeType);
                              timerprovider.addtimer(timer!);
                          });
                                }catch(e){
                                  print(e);
                                }finally{
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
                                }


                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  uploadImagefromcamera()async{
    imgpicked =await imagePicker.pickImage(source: ImageSource.camera);
    if(imgpicked !=null){
      file=File(imgpicked!.path);
      //store imagepicked.path in db because its string
      setState(() {

      });
      var image_name = basename(imgpicked!.path);
      image_name='${Random().nextInt(10000)}$image_name';

    }else{
      print('please choose image from camera');
    }
  }

  uploadImagefromgallery()async{
    imgpicked =await imagePicker.pickImage(source: ImageSource.gallery);
    if(imgpicked !=null){
      file=File(imgpicked!.path);
      setState(() {

      });
      var image_name = basename(imgpicked!.path);
      image_name='${Random().nextInt(10000)}$image_name';

    }else{
      print('please choose image from gallery');
    }
  }


}

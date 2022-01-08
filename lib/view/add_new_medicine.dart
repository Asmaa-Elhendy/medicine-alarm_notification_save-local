import 'dart:math';
import 'package:flutter/material.dart';
import 'package:medicine_alarm/controller/database_connection.dart';
import 'package:medicine_alarm/controller/dateprovider.dart';
import 'package:medicine_alarm/controller/getdatabaseprovider.dart';
import 'package:medicine_alarm/controller/notification.dart';
import 'package:medicine_alarm/model/medicine_model.dart';
import 'package:medicine_alarm/view/widgets/alert_camera.dart';
import 'package:medicine_alarm/view/widgets/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'home.dart';

class ADDNewMedicine extends StatefulWidget {
  const ADDNewMedicine({Key? key}) : super(key: key);

  @override
  _ADDNewMedicineState createState() => _ADDNewMedicineState();
}

class _ADDNewMedicineState extends State<ADDNewMedicine> {
  late  XFile? imgpicked;
   File?  file=null;
   late int hours;
   late int minute;
   TextEditingController _titleEditingController=TextEditingController();
   TextEditingController _bodyEditingController=TextEditingController();
   DatabaseConnection databaseConnection=DatabaseConnection();
   ImagePicker imagePicker = ImagePicker();

  var  selectedshow='';
  @override
  Widget build(BuildContext context) {
    double height= MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    GetDataBaseProvider providerdatabase= Provider.of<GetDataBaseProvider>(context);
    DateProvider dateprovider= Provider.of<DateProvider>(context);
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
                       Row(mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Column(
                             children: [
                               GestureDetector(
                                 onTap: () async {
                                   var result= await showTimePicker(
                                     context: context,
                                     initialTime: TimeOfDay.now(),
                                   );

                                   setState(() {
                                     hours=result!.hour;
                                     minute=result.minute;
                                     print(hours);
                                     // print(result.runtimeType);
                                         selectedshow= result.format(context);
                                       print(selectedshow);
                                   });
                                 },
                                 child: Container(
                                   height: height*.06,
                                   width: width*.4,
                                   decoration: BoxDecoration(
                                       color: Colors.blue.withOpacity(.2),
                                       border: Border.all(color: Colors.blue.withOpacity(.3)),
                                       borderRadius: BorderRadius.all(const Radius.circular(15))
                                   ),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: const [
                                       Text('select Time  '),
                                       Icon(Icons.timelapse_outlined)
                                     ],
                                   ),
                                 ),
                               ),
                               Text(selectedshow)
                             ],
                           ),SizedBox(width: width*.02,),
                           GestureDetector(child:Container(
                             height: height*.06,
                             width: width*.4,
                             decoration: BoxDecoration(
                                 color: Colors.blue.withOpacity(.2),
                                 border: Border.all(color: Colors.blue.withOpacity(.3)),
                                 borderRadius: const BorderRadius.all(Radius.circular(15))
                             ),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: const [
                                 Text('select Date  '),
                                 Icon(Icons.date_range)
                               ],
                             ),
                           ),
                             onTap: (){
                             AlertCameraOrDate.showMyDialog(context, false,uploadImagefromcamera,uploadImagefromgallery);},),
                         ],
                       ),

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
                            await NotificationClass.showScheduledNotification(
                                id:Random().nextInt(100000),
                                scheduledate:DateTime(dateprovider.date.year,dateprovider.date.month,dateprovider.date.day,hours,minute),
                                title: medicine_item.title,
                                body: medicine_item.description,
                                payload: medicine_item.title,
                                bigpicturepath: medicine_item.imageFile
                            );
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

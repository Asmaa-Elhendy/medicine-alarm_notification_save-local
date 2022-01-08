import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:medicine_alarm/controller/dateprovider.dart';
import 'package:medicine_alarm/view/add_new_medicine.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
class AlertCameraOrDate{
  static var dateTime;
  static Future<void> showMyDialog(context, bool camera, fromcamera, fromgallery) async {
    DateProvider dateProvider=DateProvider();
    return showDialog<void>(
      context: context,
      barrierDismissible:camera?true: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: camera? Text('Add image of medicine : '):Text('Select Date'),
          content: SingleChildScrollView(
            child: camera?Center(
              child: Column(   //listbody
                children:[
              ElevatedButton(
              child: Text(
              "select from camera",
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
                          side: BorderSide(
                            color: Colors.blue,
                          )))),
              onPressed: () async{
               print('camera');
              await  fromcamera();
               Navigator.pop(context);

              },
                 ),
                  ElevatedButton(
                    child: Text(
                      "select from gallery",
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
                                side: BorderSide(
                                  color: Colors.blue,
                                )))),
                    onPressed: () async{
                      print('gallery');
                       await fromgallery();
                       Navigator.pop(context);
                    },
                  )
                ]
              )
            ):
            SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
               print(args);
               dateTime=args.value;
               print(DateFormat('EEEE').format(dateTime));
              },
              selectionMode: DateRangePickerSelectionMode.single,
            ),
          ),
        actions: camera?[]:[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                dateProvider.edit_date(dateTime);
                print(dateProvider.date);
                Navigator.of(context).pop();

              },
            ),
          ]

        );
      },
    );
  }
}
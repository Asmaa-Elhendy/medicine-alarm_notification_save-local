import 'package:flutter/material.dart';
import 'package:medicine_alarm/controller/database_connection.dart';
import 'package:medicine_alarm/model/medicine_model.dart';


class GetDataBaseProvider extends ChangeNotifier {
  List<Map<String,dynamic>> dataList = [];
  DatabaseConnection databaseConnection= DatabaseConnection();



  savedatabase(Medicine medicine)async{
   await  databaseConnection.saveitem(medicine);
    dataList.add(medicine.medicine_to_map());
    notifyListeners();
  }




}
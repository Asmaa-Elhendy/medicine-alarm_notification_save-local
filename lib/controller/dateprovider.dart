

import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  DateTime date =DateTime.now();

 edit_date(DateTime dateTime){
   date=dateTime;
   notifyListeners();
 }




}
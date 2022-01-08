
import 'dart:async';
import 'package:flutter/material.dart';

class Timerprovider extends ChangeNotifier {

   late Timer timer ;
   List<Timer> timerslist =[];



  addtimer(Timer timer)async{
   timerslist.add(timer);
    notifyListeners();
  }




}
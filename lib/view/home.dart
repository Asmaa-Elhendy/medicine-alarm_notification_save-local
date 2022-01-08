import 'package:flutter/material.dart';
import 'package:medicine_alarm/controller/database_connection.dart';
import 'package:medicine_alarm/controller/getdatabaseprovider.dart';
import 'package:medicine_alarm/controller/notification.dart';
import 'package:medicine_alarm/controller/timer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'add_medicine_per_hours.dart';
import 'add_new_medicine.dart';
import 'medicine_detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseConnection databaseConnection =DatabaseConnection();
  GetDataBaseProvider _getDataBaseProvider =GetDataBaseProvider();

  getdatabase()async{
    await databaseConnection.getdatabase().then((value) {
    setState(() {
      _getDataBaseProvider.dataList = value ;
    });
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();
    NotificationClass.init();
    ListenNotification();
  }
  @override
  Widget build(BuildContext context) {
    Timerprovider timerprovider= Provider.of<Timerprovider>(context);
    return Scaffold(

    floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ADDNewMedicine()));
        },heroTag: 'one',
          child: Icon(Icons.add),
          tooltip: 'Add new medicine',
        ),
        SizedBox(height: 12,),
        FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ADDNewMedicinePerHours()));
        },heroTag: 'two',
          child: Icon(Icons.lock_clock),
          tooltip: 'Add new medicine',
        ),
      ],
    ),

      body: _getDataBaseProvider.dataList==null||_getDataBaseProvider.dataList.length==0?
    Center(child: Text('No data to show '),):
    ListView.builder( // for
        itemCount:_getDataBaseProvider.dataList.length,
        itemBuilder: (context,int i ){
          return ListTile(
            leading: CircleAvatar(backgroundImage:FileImage(File(_getDataBaseProvider.dataList[i]['imageFile'])),radius: 28,),
            title: Text(_getDataBaseProvider.dataList[i]['title']),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_getDataBaseProvider.dataList[i]['description']),
                Text(_getDataBaseProvider.dataList[i]['selectedshow']),
              ],
            ),
            trailing: IconButton(icon: Icon(Icons.delete),onPressed: ()async{
              await  databaseConnection.deleteItem(_getDataBaseProvider.dataList[i]['id']);
              setState(() {
                _getDataBaseProvider.dataList;
                getdatabase();
              });

            },),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicineDetail(
                  payload: _getDataBaseProvider.dataList[i]['id'].toString(),
                  title:_getDataBaseProvider.dataList[i]['title'],
                  description:_getDataBaseProvider.dataList[i]['description'],
                  selectedshow: _getDataBaseProvider.dataList[i]['selectedshow'],
                  imagpath: _getDataBaseProvider.dataList[i]['imageFile'],
                  datefrompicker:  _getDataBaseProvider.dataList[i]['datefrompicker']
              )));
            },

          );
        }),




    );
  }
  void ListenNotification(){
    NotificationClass.onNotification.stream.listen(onClickNotification);
  }
  void onClickNotification(String? payload){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
  }

}

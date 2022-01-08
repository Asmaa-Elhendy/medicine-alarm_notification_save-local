import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart'as tz;


class NotificationClass {

static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =FlutterLocalNotificationsPlugin();
static final onNotification =BehaviorSubject<String>();





static Future init({bool initscheduled=false})async{

   final android= AndroidInitializationSettings('@mipmap/ic_launcher');
   final ios= IOSInitializationSettings();
   final settings=  InitializationSettings(android:android,iOS:ios);

   final details= await _localNotificationsPlugin.getNotificationAppLaunchDetails();  // to navigate when app is closed
   if(details !=null && details.didNotificationLaunchApp){
     onNotification.add(details.payload!);
   }

   await _localNotificationsPlugin.initialize(settings,onSelectNotification: (payload)async{
         onNotification.add(payload!);
   });

}
static Future _notificationdetails(bigpicturepath)async{

  final style_information=BigPictureStyleInformation(
      FilePathAndroidBitmap(bigpicturepath),
    largeIcon: FilePathAndroidBitmap(bigpicturepath)
  );
 // final sound= 'filesound.wav';
  return NotificationDetails(
    android: AndroidNotificationDetails('channel_id', 'channelName',importance: Importance.max,styleInformation:style_information ,
     //   sound: RawResourceAndroidNotificationSound(sound.split('.').first)
    ),
    iOS: IOSNotificationDetails(
        //sound: sound
    )

  );
}

static Future showNotification({int id=0 , String?title, String? body , String? payload ,String? bigpicturepath})async{

  _localNotificationsPlugin.show(id, title, body, await _notificationdetails(bigpicturepath),payload: payload);
}

//********************************** scheduled notification **************************

  static Future showScheduledNotification({int id=0, String?title, String? body , String? payload ,  required DateTime scheduledate,String ?bigpicturepath})async{

    _localNotificationsPlugin.zonedSchedule(
        id, title, body,
      tz.TZDateTime.from(scheduledate,tz.local),
      await _notificationdetails(bigpicturepath),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime

         );
  }

//
//
//   static Future showperiodicNotification({int id =0,String ?title,String?body,String? bigpicturepath})async{
//   _localNotificationsPlugin.periodicallyShow(id, title, body,, await _notificationdetails(bigpicturepath),androidAllowWhileIdle: true);
//   }
//   UILocalNotification *locNot = [[UILocalNotification alloc] init];
//   NSDate *now = [NSDate date];
//   NSInterval interval;
//   switch( freqFlag ) {     // Where freqFlag is NSHourCalendarUnit for example
//   case NSHourCalendarUnit:
//   interval = 60 * 60;  // One hour in seconds
//   break;
//   case NSDayCalendarUnit:
//   interval = 24 * 60 * 60; // One day in seconds
//   break;
//   }
//   if( every == 1 ) {
//   locNot.fireDate = [NSDate dateWithTimeInterval: interval fromDate: now];
//   locNot.repeatInterval = freqFlag;
//   [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
//   } else {
//   for( int i = 1; i <= repeatCountDesired; ++i ) {
//   locNot.fireDate = [NSDate dateWithTimeInterval: interval*i fromDate: now];
//   [[UIApplication sharedApplication] scheduleLocalNotification: locNot];
//   }
//   }
//   [locNot release];
//   }
// static void cancel(int id ){_localNotificationsPlugin.cancel(id);}
//   static void cancelAll( ){_localNotificationsPlugin.cancelAll();}
 }
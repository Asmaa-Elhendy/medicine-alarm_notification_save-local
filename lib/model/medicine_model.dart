class Medicine {

  String title;
  String description;
  int hour;
  int minute;
  String imageFile;
  String  selectedshow;
  String datefrompicker;

  Medicine(
      {required this.title, required this.description, required this.hour,required this.minute,required this.imageFile,required this.selectedshow,required this.datefrompicker});

  Medicine.fromJson(Map<String, dynamic> json)
      :
        title = json['title'],
        description = json['description'],
        hour= json['hour'],
        minute= json['minute'],
        imageFile=json['imageFile'],
        selectedshow=json['selectedshow'],
        datefrompicker=json['datefrompicker'];






  Map<String,dynamic> medicine_to_map(){
    var mapping = Map<String,dynamic>();

    mapping['title']=title;
    mapping['description']=description;
    mapping['hour']=hour;
    mapping['minute']=minute;
    mapping['imageFile']=imageFile;
    mapping['selectedshow']=selectedshow;
    mapping['datefrompicker']=datefrompicker;
    return mapping;
  }
}

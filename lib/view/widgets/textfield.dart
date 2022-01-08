import 'package:flutter/material.dart';
class FormDesign extends StatefulWidget {
  String title;
  IconData icon;
  bool enabled;
  TextEditingController controllerValue;

  FormDesign(
      {Key? key,
      required this.title,
      required this.icon,
        required this.enabled,
      required this.controllerValue})
      : super(key: key);

  @override
  _FormDesignState createState() => _FormDesignState();
}

class _FormDesignState extends State<FormDesign> {


  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          //   color: Color(0xfff79281).withOpacity(0.3),
        ),
        child: TextFormField(
          enabled: widget.enabled,
            controller: widget.controllerValue,
            style: TextStyle(color: Colors.grey[600]),
            keyboardType:  TextInputType.text,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.withOpacity(.2),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color:Colors.blue,
                    )),
                prefixIcon: Icon(
                  widget.icon,
                  color: Colors.black87,
                ),

                labelText: '${widget.title}',
                labelStyle: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w600,
                )),
            validator: (value) {
                if (value == null || value.isEmpty) {
                  return '* Please enter ${widget.title}';
                }
                return null;
              }
            ),
      ),
    );
  }
}


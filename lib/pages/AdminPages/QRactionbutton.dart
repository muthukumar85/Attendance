
import 'package:attendance/pages/AdminPages/generateQR.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QRFloatButton extends StatefulWidget{
  const QRFloatButton({Key? key , required this.users , required this.classdata}) : super(key: key);
  final User users;
  final Map<dynamic,dynamic> classdata;
  @override
  State<QRFloatButton> createState() => _QRFloatButtonState();
}

class _QRFloatButtonState extends State<QRFloatButton> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  late User users;
  late Map classdata;
  String date = "";
  String period ="";
  final String _fromDate = "";
  String currentdate = DateFormat('yyyy-mm-dd').format(DateTime.now());
  DateTime? SelectedDate;
  void _submit() async{
    // if(myController2.text == ""){
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter period')));
    // }
    classdata['date'] = myController1.text;
    classdata['period'] = myController2.text.toString();
    Navigator.push(
        context, MaterialPageRoute<dynamic>(
      builder: (BuildContext context) =>
          generateQR(users: users, class_info: classdata,),
    )
    );
  }
  TextEditingController myController1 = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());
  TextEditingController myController2 = TextEditingController();
  @override
  void initState() {
    users = widget.users;
    classdata = widget.classdata;
    // print(classdata.length);
    super.initState();
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }
  String? _errorText() {
    // at any time, we can get the text from _controller.value.text
    final text = myController2.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      return 'Enter Period *';
    }
    if (text.length > 2) {
      return 'Too Large';
    }
    // return null if the text is valid
    return null;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: FloatingActionButton(
          shape:const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (BuildContext context){
              return  SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const Text('Generate QR Code',
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0,
                            fontStyle: FontStyle.italic,
                            fontFamily: ''
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                             TextFormField(
                              onTap: () async{
                               SelectedDate =  await showDatePicker(
                                    context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                              // print(SelectedDate);
                              myController1.text = DateFormat('dd-MM-yyyy').format(SelectedDate!).toString();
                              },
                              controller:myController1,
                               readOnly: true,
                              decoration: const InputDecoration(
                                // filled:true,
                                  suffixIcon: Icon(Icons.drive_file_rename_outline_rounded,
                                    color: Colors.purple,),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purple,
                                      width: 1.8,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.purple,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.purple,

                                  ),
                                  labelText: 'Date',
                                  hoverColor: Colors.purple
                              ),
                              onFieldSubmitted: (value) {
                                setState(() {
                                  date = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return 'Invalid date!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              controller:myController2,
                              decoration: InputDecoration(
                                // filled:true,
                                  suffixIcon: const Icon(Icons.person,
                                    color: Colors.purple,),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purple,
                                      width: 1.8,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.purple,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.purple,

                                  ),
                                  labelText: 'Period',
                                  hoverColor: Colors.purple,
                                helperText: _errorText(),
                                helperStyle: TextStyle(
                                  color: Colors.red[800]
                                )
                              ),
                              onChanged: (text)=>setState(() => period),
                              keyboardType: TextInputType.number,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  period = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty ) {
                                  return 'Invalid period!';
                                }
                                return null;
                              },

                            ),
                            const SizedBox(height: 20,),

                            RaisedButton(
                              onPressed: _submit,
                              padding: const EdgeInsets.fromLTRB(20, 20 , 20, 20),
                              color: Colors.purple,
                              textColor: Colors.white,
                              child: const Text("Generate QR",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal
                                ),),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  <Widget>[
                                 const Text('Trainer   Name : ' ,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple
                                ),
                                ),
                                Text( classdata['trainername'] ,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  <Widget>[
                                const Text('Subject  Name : ' ,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.purple
                                  ),
                                ),
                                Text( classdata['subjectname'] ,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  <Widget>[
                                const Text('Class     Name : ' ,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.purple
                                  ),
                                ),
                                Text( classdata['classname'] ,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.purple
                                  ),
                                )
                              ],
                            )
                            // Text("Note: Don't put past and future dates",
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     color: Colors.purple,
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            });
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute<dynamic>(
            //   builder: (BuildContext context) => generateQR(),
            // ),
            //         (route)=>false
            // );
          },
          backgroundColor: Colors.purple,
          child: const Text('Generate QR',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
          )
      ),
    );
  }
}

import 'package:attendance/pages/NavBar.dart';
import 'package:attendance/pages/mainHome.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class createClass extends StatefulWidget {
  const createClass({Key? key , required this.users}) : super(key: key);
  final User users;
  @override
  State<createClass> createState() => _createClassState();
}

class _createClassState extends State<createClass> {
  bool isCallGoogle = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String subjectname = "";
  String classname = "";
  String semester = "";
  String name = "";
  late User user_info;
  @override
  void initState() {
    user_info = widget.users;
    super.initState();
  }
  void _submit() async{
    setState(() { isCallGoogle = true; });

      await AdminService.CreateClass(
          users: user_info,
          name: myController1.text,
          classname: myController3.text,
          subjectname: myController2.text,
          semester: myController4.text
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Class Created Successfully')));
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => mainhome(users: user_info),
      ),
          (route) => false,//if you want to disable back feature set to false
    );

    setState(() { isCallGoogle = false; });
  }
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  TextEditingController myController4 = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // myController1.dispose();
    // myController2.dispose();
    // myController3.dispose();
    // myController4.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(isCallGoogle){
      return const Scaffold(
          body:Center(
            child: SpinKitCircle(
              color: Colors.purple,
              size: 100.0,
            ),
          ));
    }
    else {
      return Scaffold(
        backgroundColor: Colors.purple[400],
        appBar: AppBar(
          title:const Text('Attendance' ,
            style: TextStyle(
                color: Colors.white
            ),),
          backgroundColor: Colors.purple,
        ),
        drawer: NavBar(users: user_info, IsAdmin: true,),
        body:
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0,0,0,20),
                  //   child: Text('Note : Only use numbers for semester',
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.w300,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 30,),
                  Center(
                    child: Container(
                      child: SizedBox(

                        // width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              const Text('Create Class',
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
                                      controller:myController1,
                                      decoration: const InputDecoration(
                                        // filled:true,
                                          suffixIcon: Icon(Icons.person,
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
                                          labelText: 'Trainer Name',
                                          hoverColor: Colors.purple
                                      ),
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          name = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty ) {
                                          return 'Invalid name!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20,),
                                    TextFormField(
                                      controller:myController2,
                                      decoration: const InputDecoration(
                                        // filled:true,
                                          suffixIcon: Icon(Icons.subject,
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
                                          labelText: 'Subject Name',
                                          hoverColor: Colors.purple
                                      ),
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          subjectname = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return 'Invalid email!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20,),
                                    TextFormField(
                                      controller:myController3,
                                      decoration: const InputDecoration(
                                        // filled:true,
                                          suffixIcon: Icon(Icons.class_,
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
                                          labelText: 'Class Name',
                                          hoverColor: Colors.purple
                                      ),
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          classname = value;
                                        });
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty || !value.contains('@')) {
                                          return 'Invalid email!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20,),
                                    TextFormField(
                                      controller: myController4,
                                      decoration: const InputDecoration(
                                        suffixIcon: Icon(Icons.timer,
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
                                        labelText: 'semester',
                                        labelStyle: TextStyle(
                                          color: Colors.purple,

                                        ),

                                      ),
                                      keyboardType: TextInputType.number,
                                      // obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty && value.length > 2) {
                                          return 'Invalid Semester!';
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          semester = value;
                                        });
                                      },
                                    ),


                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        RaisedButton(
                                          onPressed: _submit,
                                          padding: const EdgeInsets.fromLTRB(20, 20 , 20, 20),
                                          color: Colors.purple,
                                          textColor: Colors.white,
                                          child: const Text("Create Class",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal
                                            ),),
                                        ),
                                        const SizedBox(width: 20,),



                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  )

                ],
              ),

            ),
          ),
        ),
      );}
  }
}

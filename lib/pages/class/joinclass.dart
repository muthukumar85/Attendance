
import 'package:attendance/services/UserDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Joinclass extends StatefulWidget {
  const Joinclass({Key? key , required this.users}) : super(key: key);
  final User users;
  @override
  State<Joinclass> createState() => _JoinclassState();
}

class _JoinclassState extends State<Joinclass> {
  bool isCallGoogle = false;
  late User users;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String classcode = "";
  @override
  void initState() {
    users = widget.users;
    super.initState();
  }
  void _submit() async{
    setState(() { isCallGoogle = true; });
    await UserService.JoinClass(users: users, context: context, classid: myController1.text.toString());


    setState(() { isCallGoogle = false; });
  }
  TextEditingController myController1 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();

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
        body:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0,0,0,20),
                //   child: Text('Note : you can not create admin account with your student mail id',
                //     style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.white,
                //       fontWeight: FontWeight.w300,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 30,),
                Center(
                  child: Container(
                    child: SizedBox(

                      // width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            const Text('Join Class',
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
                                  const SizedBox(height: 20,),
                                  TextFormField(
                                    controller:myController1,
                                    decoration: const InputDecoration(
                                      // filled:true,
                                        suffixIcon: Icon(Icons.event,
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
                                        labelText: 'Class Code',
                                        hoverColor: Colors.purple
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        classcode = value;
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
                                  Row(
                                    children: [
                                      RaisedButton(
                                        onPressed: _submit,
                                        padding: const EdgeInsets.fromLTRB(20, 15 , 20, 15),
                                        color: Colors.purple,
                                        textColor: Colors.white,
                                        child: const Text("Join",
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
      );}
  }
}

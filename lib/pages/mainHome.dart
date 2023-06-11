//ca-app-pub-8563292994790453~2585894334
import 'dart:math';

import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/NavBar.dart';
import 'package:attendance/pages/actionButton.dart';
import 'package:attendance/pages/charts/mainchart.dart';
import 'package:attendance/pages/charts/subchart2.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/adminDataService.dart';
class mainhome extends StatefulWidget {
  const mainhome({Key? key , required this.users}) : super(key: key);
  final User? users;
  @override
  State<mainhome> createState() => _mainhomeState();
}

class _mainhomeState extends State<mainhome> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isCallGoogle = false;
  String classcode = "";
  late User current_user;
  bool isRegister = false;
  bool isAdmin = false;
  Map users = {};
  Map classdata = {};
  List classlist = [];
  Map Graphdata={};
  @override
  void initState(){
    current_user = widget.users!;
    // print(users);
  // print(current_user);
    AdminCheck();
    super.initState();
  }
  _submit() async{
    setState(() {
      isCallGoogle = true;
    });
  await UserService.RegisterNumber(users: current_user, context: context, regno: myController1.text.toString().toUpperCase());
  }
  AdminCheck()async{
    setState(() {
      isCallGoogle = true;
    });
    isAdmin = await AdminService.IsAdmin(users: current_user);
    if(!isAdmin){
      users = await UserService.GetData(userdata: current_user);
      print(users);
      users['registernumber']!=null?isRegister=true:isRegister=false;
      if(users['classes']!=null){
        classdata = users['classes'];
        classlist = classdata.keys.toList();
        final random = Random();
        var i = random.nextInt(classlist.length);
        Graphdata = await UserService.GetGraphData(userdata: current_user, classdata: classlist[i]);
        // print(Graphdata);
      }
    }else{
      isRegister = true;
    }
    setState(() {
      isCallGoogle = false;
      // print(isAdmin);
    });
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
        body: SpinKitCircle(
          color: Colors.purple,
          size: 100,
        ),
      );
    }
    else {
      if (!isRegister) {
        return Scaffold(
          appBar: AppBars(),
          body: Center(
            child: Padding(padding: const EdgeInsets.all(10),
              child: Center(
                child: Container(
                  child: SizedBox(

                    // width: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          const Text('Enter Register Number',
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
                                  controller: myController1,
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
                                      labelText: 'Register number',
                                      hoverColor: Colors.purple
                                  ),
                                  keyboardType: TextInputType
                                      .emailAddress,
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      classcode = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty ) {
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
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
                                      color: Colors.purple,
                                      textColor: Colors.white,
                                      child: const Text("Submit",
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
              ),
            ),
          ),
        );
      }
      else {
        return Scaffold(
          backgroundColor: Colors.purple[400],
          appBar: AppBars(),
          drawer: NavBar(users: current_user, IsAdmin: isAdmin,),
          body: SingleChildScrollView(
            child: Column(
              children:  <Widget>[

                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: AspectRatio(aspectRatio: 1,
                    child: Image(
                        image:AssetImage('assets/scanner.jpg') ),

                  ),
                ),
                isAdmin?SizedBox():
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: BarChartSample2(graphdata: Graphdata, classdata: users,),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: BarChartSample1(),
                ),




              ],
            ),
          ),
          floatingActionButton: isAdmin? const SizedBox(): FloatButton(users: current_user,),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerFloat,
        );
      }
    }
  }
}

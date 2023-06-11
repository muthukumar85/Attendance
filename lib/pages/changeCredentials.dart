import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangeCredential extends StatefulWidget {
  const ChangeCredential({Key? key , required User this.users , required bool this.credential , required Map this.userdata}) : super(key: key);
  final User users;
  final bool credential;
  final Map userdata;
  @override
  State<ChangeCredential> createState() => _ChangeCredentialState();
}

class _ChangeCredentialState extends State<ChangeCredential> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late User users;
  late bool typecre;
  late Map userdata;
  String registernumber = "";
  String username = "";
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  @override
  void initState() {
    users = widget.users;
    typecre = widget.credential;
    userdata = widget.userdata;
    myController1.text = userdata['registernumber'];
    myController2.text = users.displayName.toString();
    super.initState();
  }
  void _submit()async{

      await UserService.ChangeCredential(context: context, users: users, registernumber: myController1.text.toString(), username: myController2.text.toString(), credential: typecre, userdata: userdata);

  }
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars(),
      body: typecre?
         Center(
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
      const Text('Note : If you change your register number , your attendance report are lost To regain it update to previous reg.no',
        style: TextStyle(
            color: Colors.purple,
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 0,

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
    registernumber = value;
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
    ):Center(
    child: Padding(padding: const EdgeInsets.all(10),
    child: Center(
    child: Container(
    child: SizedBox(

    // width: 300,
    child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    children: <Widget>[
    const Text('Enter User Name',
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
    controller: myController2,
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
    labelText: 'Username',
    hoverColor: Colors.purple
    ),
    keyboardType: TextInputType
        .emailAddress,
    onFieldSubmitted: (value) {
    setState(() {
    username = value;
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
    )

    );
  }
}

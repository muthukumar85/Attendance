import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/register.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../globals/globals.dart';
import '../services/loginWithCredentials.dart';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  bool isCallGoogle = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  String email = "";
  String password = "";
  //submit form ------------------
  Future<void> _submit() async{
      // print('${myController2.value} ${myController1.value}');
      setState(() { isCallGoogle = true; });
      await LoginWithCredentials.signInUsingEmailPassword(
          email: myController1.text, password: myController2.text, context: context);

    setState(() { isCallGoogle = true; });

    }
    //google login ---------------------
  Future<void> loginCredential() async {

    setState(() { isCallGoogle = true; });
    dynamic users= await LoginWithCredentials.signInWithGoogle(context: context);
    setState(() { isCallGoogle = false; });
    if(users!=null){
      variable.isLoggedIn = true;
    }

    // print(users);

  }
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }
  @override
  void initState() {

    super.initState();
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
      backgroundColor: Colors.purple,
      appBar: AppBars(),
      body:
      Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: SizedBox(

                      // width: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text('Login',
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0,
                                      fontStyle: FontStyle.italic,
                                      fontFamily: ''
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (
                                            BuildContext context) => const registerUser())
                                    );
                                  },
                                  icon: const Icon(Icons.autorenew),
                                  iconSize: 30.0,
                                  color: Colors.purple,
                                )
                              ],
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
                                        labelText: 'E-Mail',
                                        hoverColor: Colors.purple
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        email = value;
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
                                    controller: myController2,
                                    decoration: const InputDecoration(
                                      suffixIcon: Icon(Icons.wifi_password,
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
                                      labelText: 'password',
                                      labelStyle: TextStyle(
                                        color: Colors.purple,

                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value!.isEmpty && value.length < 7) {
                                        return 'Invalid password!';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      RaisedButton(
                                        onPressed: _submit,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 20),
                                        color: Colors.purple,
                                        textColor: Colors.white,
                                        child: const Text("submit",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),),
                                      ),
                                      const SizedBox(width: 20,),

                                      RaisedButton(
                                        onPressed: loginCredential,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 20, 20, 20),
                                        color: Colors.white,
                                        textColor: Colors.black,
                                        child: const Text("Google",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal
                                          ),),
                                      ),

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
                  )

                ],
              ),
            ),
          ),

        ),
      ),
    );
  }



  }
}

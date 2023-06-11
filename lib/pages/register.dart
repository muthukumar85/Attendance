
import 'package:attendance/services/loginWithCredentials.dart';
import 'package:flutter/material.dart';

class registerUser extends StatefulWidget {
  const registerUser({Key? key}) : super(key: key);

  @override
  State<registerUser> createState() => _registerUserState();
}

class _registerUserState extends State<registerUser> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String email = "";
  String password = "";
  String name = "";
  void _submit() async{
    setState(() async{
      await LoginWithCredentials.registerUsingEmailPassword(name: myController3.text, email: myController1.text, password: myController2.text, context: context);
    });
  }
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
      Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: SizedBox(


                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          const Text('Register As a User',
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
                                TextFormField(
                                  controller:myController3,
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
                                      labelText: 'Name',
                                      hoverColor: Colors.purple
                                  ),
                                  keyboardType: TextInputType.emailAddress,
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
                                Row(
                                  children: [
                                    RaisedButton(
                                      onPressed: _submit,
                                      padding: const EdgeInsets.fromLTRB(20, 20 , 20, 20),
                                      color: Colors.purple,
                                      textColor: Colors.white,
                                      child: const Text("submit",
                                        style: TextStyle(
                                            fontSize: 16,
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
                )

              ],
            ),
          ),
        ),

      ),
    );
  }
}

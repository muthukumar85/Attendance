import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
class SuccessPresent extends StatefulWidget {
  const SuccessPresent({Key? key , required this.users ,required this.classdata}) : super(key: key);
  final User users;
  final Map classdata;
  @override
  State<SuccessPresent> createState() => _SuccessPresentState();
}

class _SuccessPresentState extends State<SuccessPresent> {
  bool isCallGoogle = false;
  late User users;
  late Map classdata;
  @override
  void initState() {
    users = widget.users;
    classdata = widget.classdata;
    super.initState();
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
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBars(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50,),
                    Container(
                      child: Lottie.asset('assets/success.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Text('Attendance Marked Successfully',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Divider(),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text('Subject : ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Name : ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Date : ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Period : ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${classdata['subjectname']}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.purple
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text('${users.displayName}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.purple
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text('${classdata['date']}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.purple
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text('${classdata['period']}',
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.purple
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    RaisedButton(
                      onPressed: () async{
                            setState(() {
                              isCallGoogle = true;
                            });
                            await UserService.GetClassList(context: context, users: users);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Continue',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                      ),
                      // color: Colors.purple,
                      color: const Color.fromRGBO(190, 40, 200, 1),
                      textColor: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

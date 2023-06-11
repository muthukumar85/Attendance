import 'dart:convert';

import 'package:attendance/pages/AdminPages/adminRegister.dart';
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/pages/NavBar.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
class titles{
  String title;
  titles({required this.title});
}
class premium extends StatefulWidget {
  const premium({Key? key , required this.users}) : super(key: key);
  final User users;
  @override
  State<premium> createState() => _premiumState();
}

class _premiumState extends State<premium> {
   Map<String , dynamic>? paymentIndentData;
   List datam = <titles>[
    titles(title: "UnLimited Yearly Class Access"),
    titles(title: "Personalized activity insights"),
    titles(title: "Advanced Visualized datas"),
  ];
  late User users;
  late String role;
  bool admin = false;
  String stripePublishableKey = 'pk_live_51LVEK1SEHPdKn5w8u3WvTr0Y2AvE4icGKf0qAGDESQEZHWjVp28neVZiV4rVx8rO2pAV8e1Auew5myYaUtJ3ceAw00WOui2nym';
  @override
  void initState() {
    users = widget.users;
    WidgetsFlutterBinding.ensureInitialized();
    Stripe.publishableKey = stripePublishableKey;
    Stripe.instance.applySettings();
    super.initState();
    IsAdmin();

  }
   void IsAdmin() async{
    // print('isadmin');
    admin = await AdminService.IsAdmin(users: users);
    setState(() {
print(admin);
    });
     if(admin){
        role = 'admin';
        CheckPay();
     }
     else{
       role = 'students';
       CheckPay();
     }
   }
   void CheckPay()async{
     var pay = await AdminService.IsPay(users: users , role: role);
     // print(pay);
     if(pay){
       Navigator.pushAndRemoveUntil<dynamic>(
         context,
         MaterialPageRoute<dynamic>(
           builder: (BuildContext context) => const registerAdmin(),
         ),
             (route) => false,//if you want to disable back feature set to false
       );
     }
   }
  void update(){
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(titles data) => ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
      horizontalTitleGap: 5,
      minVerticalPadding: 0,
      leading: const Icon(Icons.check_circle,color: Colors.white,),
      title: Text(
        data.title.toString(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400 ,fontSize: 16 ),
      ),
      dense: true,
    );

    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBars(),
      drawer: NavBar(users: users, IsAdmin: admin,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0,50,0,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Image(
                    image: AssetImage('assets/icons8-diamond-100.png')
                ),
                // Icon(
                //     Icons.diamond ,
                //   color: Colors.white,
                //   size: 100,
                // ),
                const Text('Get Premium' ,
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w100
                ),
                ),
                const Text('To create an admin account ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300
                ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                      itemCount: datam.length,
                      itemBuilder: (context , index){
                        print(datam[index]);
                        return makeListTile(datam[index]);
                      },

                  ),
                ),
                const SizedBox(height: 30,),
                const Text("Choose a Plan",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                  color: Colors.white
                ),
                ),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(width: 20,),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text('1 Month Plan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                              ),
                              ),
                              const Text('₹ 99.0',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              RaisedButton(
                                color: Colors.yellow,
                                child: const Text('Get 50% OFF',
                                  style: TextStyle(
                                      color: Colors.black
                                  ),
                                ),

                                onPressed: () async {
                                  await makePayment(rupee: '9900');
                                },)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container()),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              const Text('6 Month Plan',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                              const Text('₹ 449.0',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              RaisedButton(
                                color: Colors.purple,
                                child: const Text('Get 20% OFF',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                                ),
                                onPressed: () async{
                                  await makePayment(rupee: '44900');
                                },),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,)
                  ],
                )
                //
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> makePayment({required String rupee})async {
    try{
        paymentIndentData = await createPaymentIntent(rupee,'INR');
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIndentData!['client_secret'],
          merchantDisplayName: 'NK0507',
          googlePay: true,
          applePay: true,
          style: ThemeMode.dark,
          merchantCountryCode: 'IN',
        ));
        // await Stripe.instance.initGooglePay(
        //     GooglePayInitParams(
        //         merchantName: 'NK0507',
        //         countryCode: 'IN'));
        displayPaymentSheet();
    }
    catch(e){
      print('exception'+e.toString());
    }
  }
  displayPaymentSheet() async{
    try{
       await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: paymentIndentData!['client_secret'],
          confirmPayment: true
        )
      );
      // await Stripe.instance.presentGooglePay(
      //  PresentGooglePayParams(clientSecret: paymentIndentData!['client_secret'],currencyCode: 'INR')
      // );
      setState(() {
        paymentIndentData = null;
      });
      var payRegister = await AdminService.SetPay(users: users, role: role);
      ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('paid successfully')));
      Future.delayed(const Duration(seconds: 2),(){
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const registerAdmin(),
          ),
              (route) => false,//if you want to disable back feature set to false
        );
      });
    }on StripeException catch(e){

      print(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('payment Cancelled')));
    }
  }
  createPaymentIntent(String amount , String currency) async{
    try{
        Map<String , dynamic> body ={
          'amount': amount,
          'currency':currency,
          'payment_method_types[]':'card'
        };
      // Map<String , dynamic> body ={
      //   'email': 'admin@gmail.com',
      //   'currency':currency,
      //   'payment_method_types[]':'acss_debit'
      // };

        var response = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body:body,
          headers: {
          'Authorization':'Bearer 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',

            //'Content-Type':'application/json'
          });
        return jsonDecode(response.body.toString());
    }
    catch(e){
      print('exception'+e.toString());
    }
  }
  calculateAmount(String amount){
    final price = int.parse(amount) * 100;
    return price;
  }
}

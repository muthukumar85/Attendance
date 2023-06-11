import 'package:attendance/pages/mainHome.dart';
import 'package:attendance/services/UserDataService.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/home.dart';
class LoginWithCredentials{
// Sign In with Auth provider
//-------------------------------------------
static Future<User?> signInWithGoogle({required BuildContext context}) async {
FirebaseAuth auth = FirebaseAuth.instance;
User? user;

final GoogleSignIn googleSignIn = GoogleSignIn(
   // clientId: '1020462632114-pdm4itfufnmarj9vnfvsgo8b2p8h153f.apps.googleusercontent.com',
);

final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

if (googleSignInAccount != null) {
final GoogleSignInAuthentication googleSignInAuthentication =
await googleSignInAccount.authentication;

final AuthCredential credential = GoogleAuthProvider.credential(
accessToken: googleSignInAuthentication.accessToken,
idToken: googleSignInAuthentication.idToken,
);

try {
final UserCredential userCredential =
await auth.signInWithCredential(credential);

user = userCredential.user;
// print(user);

await UserService.RegisterUserdata(userdata: user!);

} on FirebaseAuthException catch (e) {
if (e.code == 'account-exists-with-different-credential') {
// handle the error here
}
else if (e.code == 'invalid-credential') {
// handle the error here
}
} catch (e) {
// handle the error here
}
Navigator.push<dynamic>(
    context,
    MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => mainhome(users: user,),
    ),//if you want to disable back feature set to false
);
}
else{

}
return null;
// await Fluttertoast.showToast(
//     msg: "Login Successfully",
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 3,
//     backgroundColor: Colors.greenAccent,
//     textColor: Colors.white,
//     fontSize: 16.0
// );

}
//--end
//Create User With Email and password
//-------------------------------
    static Future<User?> registerUsingEmailPassword({
        required String name,
        required String email,
        required String password,
        required BuildContext context,
    }) async {
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user;
        try {
            UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                email: email,
                password: password,
            );
            user = userCredential.user;
            await user!.updateDisplayName(name);
            await user.reload();
            user = auth.currentUser;
            await UserService.RegisterUserdata(userdata: user!);
        } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
                print('The password provided is too weak.');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
                    children: const [
                        FaIcon(FontAwesomeIcons.userLargeSlash , color: Colors.white,size: 15,),
                        SizedBox(width: 20,),
                        Text('Weak Password for that email.')
                    ],
                )));
            } else if (e.code == 'email-already-in-use') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
                    children: const [
                        FaIcon(FontAwesomeIcons.mailchimp , color: Colors.white,size: 15,),
                        SizedBox(width: 20,),
                        Text('Email Already Exists')
                    ],
                )));
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => const home(),
                    ),
                        (route) => false,//if you want to disable back feature set to false
                );
            }
        } catch (e) {
            print(e);
        }

        Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const home(),
            ),
                (route) => false,//if you want to disable back feature set to false
        );
        return null;
    }
//--------------------------------
// Sign in with Email and password
static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
        );
        user = userCredential.user;
        Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => mainhome(users: user,),
            ),
              //if you want to disable back feature set to false
        );
    } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
            print('No user found for that email.');

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
                children: const [
                    FaIcon(FontAwesomeIcons.userLargeSlash , color: Colors.white,size: 15,),
                    SizedBox(width: 20,),
                    Text('No user found for that email.')
                ],
            )));
            Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const home(),
                ),
                    (route) => false,//if you want to disable back feature set to false
            );
        } else if (e.code == 'wrong-password') {
            print('Wrong password provided.');

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
              children: const [
                FaIcon(FontAwesomeIcons.squareXmark,color: Colors.white,size: 15,),
                SizedBox(width: 20,),
                Text('Password Wrong')
              ],
            )));
            Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const home(),
                ),
                    (route) => false,//if you want to disable back feature set to false
            );
        }
    }


    return null;
}
//--------------------------------
//Refresh User
static Future<User?> refreshUser({required BuildContext context,required User user}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => mainhome(users: refreshedUser,),
        ),
            (route) => false,//if you want to disable back feature set to false
    );
    return null;


}
//--------------------------
    static Future<User?> registerAdminUsingEmailPassword({
        required String name,
        required String email,
        required String password,
        required BuildContext context,
    }) async {
        FirebaseAuth auth = FirebaseAuth.instance;
        User? user;
        try {
            UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                email: email,
                password: password,
            );
            user = userCredential.user;
            await user!.updateDisplayName(name);
            await user.reload();
            user = auth.currentUser;
            await AdminService.RegisterAdmindata(userdata: user);
        } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
                print('The password provided is too weak.');


            } else if (e.code == 'email-already-in-use') {
                print('The account already exists for that email.');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(
                    children: const [
                        FaIcon(FontAwesomeIcons.userLargeSlash , color: Colors.white,size: 15,),
                        SizedBox(width: 20,),
                        Text('Email Already Exists')
                    ],
                )));
                Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => const home(),
                    ),
                        (route) => false,//if you want to disable back feature set to false
                );
            }
        } catch (e) {
            print(e);
        }
        Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const home(),
            ),
                (route) => false,//if you want to disable back feature set to false
        );
        return null;
    }
//--------------------------
//Sign Out
static Future<void> SignOut({required BuildContext context}) async{
    try {
        final GoogleSignIn googleSignIn = GoogleSignIn(
            //clientId: '1020462632114-6qj19epek5nicgr9sc6kjiuvtn33bmg1.apps.googleusercontent.com'
        );
        await googleSignIn.disconnect();
    }
    catch(e){

    }
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const home(),
        ),
            (route) => false,//if you want to disable back feature set to false
    );
}
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/custom_widgets/app_widgets.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/screens/users_panel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController passwordCtrl = TextEditingController();
  late FirebaseFirestore db;
  var passKey;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("credentials").doc("adminCredentials").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
            Color(0xff330040),
            Color(0xff5d0076),
            Color(0xff8900ae),
          ]
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
              child: StreamBuilder(
                stream: db.collection("credentials").doc("adminCredentials").snapshots(),
                builder: (_, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }else if(snapshot.hasData){
                    var ref = snapshot.data;
                    passKey = ref!["adminPass"];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/adminlogocir.png", width: 80, height: 80,),
                        vSpace(mHeight: 7),
                        textBox(text: "Task Handler Admin", weight: FontWeight.bold, size: 21, clr: Colors.white),
                        vSpace(mHeight: 10),
                        TextField(
                          obscuringCharacter: "*",
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          controller: passwordCtrl,
                          decoration: const InputDecoration(
                            //label and hints
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.normal),
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontWeight: FontWeight.normal),
                            //border
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(width: 1, color: Colors.grey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.blue)),
                          ),
                        ),
                      ],
                    );
                  }else{
                    return const Center(child: Text("Unknown Error Occured"),);
                  }
                }
              )),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        var enteredPassword = passwordCtrl.text.toString();
        if(enteredPassword==passKey){
          showToast(message: "Welcome Admin");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => UserPanel()));
        }else{
          showToast(message: "password is incorrect");
        }
      },
        child: const Icon(Icons.login),
      ),
    );
  }
}


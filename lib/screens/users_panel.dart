import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/custom_widgets/app_widgets.dart';
import 'package:task_manager/screens/portal.dart';

class UserPanel extends StatefulWidget {
  const UserPanel({super.key});

  @override
  State<UserPanel> createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  late FirebaseFirestore db;
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("users").snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Users Panel"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
            stream: db.collection("users").snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, index){
                      var eachUser = snapshot.data!.docs[index];
                      return InkWell(
                        onTap: (){
                          showToast(message: "Opening Portal of ${eachUser.id}");
                          //send document id with constructor
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => Portal(mDocId: eachUser.id)));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(radius: 20, child: Text('${index+1}'),),
                              title: Text(eachUser.id),
                              trailing: InkWell(
                                  onTap: (){
                                    Widget cancelButton = TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                    Widget actionBtn = TextButton(
                                      onPressed: () {
                                        db.collection("users").doc(eachUser.id).delete();
                                        showToast(message: '${eachUser.id} Deleted Successfully');
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete"),
                                    );

                                    AlertDialog alert = AlertDialog(
                                      backgroundColor: Colors.white,
                                      title: Text(
                                        "Delete User ${eachUser.id}",
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      actions: [
                                        cancelButton,
                                        actionBtn,
                                      ],
                                    );

                                    // show the dialog
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        });
                                  },
                                  child: const Icon(Icons.delete)),
                            ),
                            Divider(color: Colors.grey.shade900,),
                          ],
                        ),
                      );
                    });
              }else{
                return const Center(child: Text("Unknown Error Occured"),);
              }
            }
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {

        Widget cancelButton = TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            usernameCtrl.clear();
            passwordCtrl.clear();
            Navigator.pop(context);
          },
        );
        Widget actionBtn = TextButton(
          onPressed: (){
            if(usernameCtrl.text.isEmpty || passwordCtrl.text.isEmpty){
              showToast(message: "All fields are mandatory");
            }else{
              var diaInput = usernameCtrl.text.toString();
              var id = generateID().toString();
              var len = id.length;
              String USERNAME = "$diaInput${id[len-1]}${id[len-2]}${id[len-3]}${id[len-4]}${id[len-5]}${id[len-6]}";
              String PASSWORD = passwordCtrl.text.toString();
              db.collection("users").doc("$USERNAME").set({
                "password" : PASSWORD,
              });
              usernameCtrl.clear();
              passwordCtrl.clear();
              Navigator.pop(context);
            }
          },
          child: const Text("Add User"),
        );

        AlertDialog alert = AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Enter User Credentials",
            style: TextStyle(color: Colors.black),
          ),
          content: SizedBox(
            width: 130,
            height: 150,
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: usernameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Enter name",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: passwordCtrl,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Set password",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            cancelButton,
            actionBtn,
          ],
        );

        // show the dialog
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            });

        setState(() {

        });

      },
        tooltip: "Add New User",
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(7),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

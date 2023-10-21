import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/custom_widgets/app_widgets.dart';
import 'package:task_manager/screens/view_all_tasks.dart';

String? DOC_ID;

class Portal extends StatefulWidget {
  Portal({required String mDocId}) {
    DOC_ID = mDocId;
  }

  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  late FirebaseFirestore db;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("users").doc(DOC_ID).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("User Portal"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
              stream: db.collection("users").doc(DOC_ID).snapshots(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  var userData = snapshot.data!;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textBox(text: "Username", weight: FontWeight.bold, size: 19),
                      textBox(text: DOC_ID.toString(), weight: FontWeight.normal, size: 17),
                      vSpace(mHeight: 10),
                      textBox(text: "Password", weight: FontWeight.bold, size: 19),
                      textBox(text: userData["password"], weight: FontWeight.normal, size: 17),
                      vSpace(mHeight: 20),
                      Center(child: textBox(text: "Rooms", weight: FontWeight.bold, size: 19)),
                      vSpace(mHeight: 10),
                      Divider(color: Colors.grey.shade900,),
                      Expanded(
                        child: StreamBuilder(
                            stream: db.collection("users").doc(DOC_ID).collection("tasks").snapshots(),
                            builder: (_,snap){
                              if(snap.connectionState==ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator());
                              }else if(snap.hasData){
                                return ListView.builder(
                                    itemCount: snap.data!.docs.length,
                                    itemBuilder: (_, index){
                                      var taskDates = snap.data!.docs[index];
                                      return InkWell(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (builder) => ViewAllTasks(mUserID: DOC_ID.toString(), mDate: taskDates.id)));
                                        },
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(radius: 20, child: Text('${index+1}'),),
                                              title: Text(taskDates.id, style: TextStyle(fontSize: 16),),
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
                                                      db.collection("users").doc(DOC_ID).collection("tasks").doc(taskDates.id).delete();
                                                      showToast(message: '${taskDates.id} Deleted Successfully');
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Delete"),
                                                  );

                                                  AlertDialog alert = AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    title: Text(
                                                      "Delete Room ${taskDates.id}",
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
                                return const Center(
                                  child: Text("Unknown Error occurred in fetching dates"),
                                );
                              }
                        }),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("Unknown Error Occurred in fetching user details"),
                  );
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Room",
        onPressed: () {
        Widget cancelButton = TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        );
        Widget actionBtn = TextButton(
          onPressed: () async{

              var date = "${DateTime.now().day}_${DateTime.now().month}_${DateTime.now().year}";

              final snapShot = await db.collection("users").doc(DOC_ID).collection("tasks").doc(date).get();
              if(snapShot.exists){
                //room already exist
                //redirect to tasks page with user id and date id
                showToast(message: "$date room already exist, redirecting to task page");
              }else{
                //create room
                db.collection("users").doc(DOC_ID).collection("tasks").doc(date).set({});
              }

              Navigator.pop(context);

              if(snapShot.exists){
                //room already exist
                //redirect to tasks page with user id and date id
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ViewAllTasks(mUserID: DOC_ID.toString(), mDate: date)));
              }

          },
          child: const Text("Create"),
        );

        AlertDialog alert = AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Create Today's Room",
            style: TextStyle(color: Colors.black),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

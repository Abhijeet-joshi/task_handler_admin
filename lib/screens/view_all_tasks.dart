import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/app_widgets.dart';

String? USER_ID;
String? DATE;

class ViewAllTasks extends StatefulWidget {
  ViewAllTasks({required String mUserID, required String mDate}) {
    USER_ID = mUserID;
    DATE = mDate;
  }

  @override
  State<ViewAllTasks> createState() => _ViewAllTasksState();
}

class _ViewAllTasksState extends State<ViewAllTasks> {
  late FirebaseFirestore db;
  TextEditingController taskCtrl = TextEditingController();
  TextEditingController deadlineCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = FirebaseFirestore.instance;
    db.collection("users").doc(USER_ID).collection("tasks").doc().collection("all tasks").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tasks of $DATE"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: StreamBuilder(
              stream: db.collection("users").doc(USER_ID).collection("tasks").doc(DATE).collection("all tasks").snapshots(),
              builder: (_,snap){
                if(snap.connectionState==ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if(snap.hasData){
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snap.data!.docs.length,
                        itemBuilder: (_,index){
                      var eachTask = snap.data!.docs[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(radius: 21, child: Text('${index + 1}'),),
                            title: Text(eachTask["task"]),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(eachTask["status"], style: TextStyle(fontWeight: FontWeight.bold,
                                    color: eachTask["status"]=="Pending" ? Colors.red : Colors.green),),
                                Divider(color: Colors.purple,),
                                vSpace(mHeight: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Deadline - ", style: TextStyle(color: Colors.black),),
                                    Text(eachTask["deadline"],style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                                vSpace(mHeight: 10),
                                Text("Task uploaded at - ${eachTask["uploaded at"]}", style: TextStyle(fontSize: 15),),
                                vSpace(mHeight: 10),
                                Text("Status updated at - ${eachTask["status updated at"]}", style: TextStyle(fontSize: 15),),
                              ],
                            ),
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
                                      db.collection("users").doc(USER_ID).collection("tasks").doc(DATE).collection("all tasks").doc(eachTask.id).delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"),
                                  );

                                  AlertDialog alert = AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      "Delete Task",
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

                                },
                                child: Icon(Icons.delete)),
                          ),
                          Divider(color: Colors.grey.shade800,),
                        ],
                      );
                    }),
                  );
                }
                else if(snap.data!.docs.isEmpty){
                  return Center(
                    child: Text("No Tasks added in $DATE"),
                  );
                }
                else{
                  return const Center(
                    child: Text("Unknown Error occurred in fetching tasks"),
                  );
                }
          })
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Task",
        onPressed: () {
          Widget cancelButton = TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              taskCtrl.clear();
              deadlineCtrl.clear();
              Navigator.pop(context);
            },
          );
          Widget actionBtn = TextButton(
            onPressed: () async {
              var uploadTime = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
              var statusUpdateTime = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
              var TASK = taskCtrl.text.toString();
              var DEADLINE = deadlineCtrl.text.toString();

              db
                  .collection("users")
                  .doc(USER_ID)
                  .collection("tasks")
                  .doc(DATE)
                  .collection("all tasks")
                  .doc()
                  .set({
                "task": TASK,
                "deadline": DEADLINE,
                "status": "Pending",
                "uploaded at": uploadTime,
                "status updated at" : statusUpdateTime,
              });

              taskCtrl.clear();
              deadlineCtrl.clear();
              Navigator.pop(context);

            },
            child: const Text("Add"),
          );

          AlertDialog alert = AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Add Task",
              style: TextStyle(color: Colors.black),
            ),
            content: SizedBox(
              width: 130,
              height: 150,
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: taskCtrl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Enter Task",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: deadlineCtrl,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: "Set Deadline",
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

          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/blocs/folder/FolderBloc.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderDetail.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/FolderDao.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderCreatePage extends StatefulWidget {
  const FolderCreatePage({super.key});

  @override
  State<FolderCreatePage> createState() => _FolderCreatePageState();
}

class _FolderCreatePageState extends State<FolderCreatePage> {

  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  late Future<UserModel?> _userFuture;
  late UserModel user;
  @override
  void initState() {
    super.initState();
    _userFuture = AuthService().getCurrentUser();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Folder",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              if(_titleEditingController.text.isNotEmpty){
                
                //Tạo folder
                FolderModel newFolder = FolderModel(userId: user.id!
                , name: _titleEditingController.text, description: _descriptionEditingController.text, topicIds: []);
                // var result = await FolderDao().addFolder(newFolder);
                
                try {
                    AddFolder addFolderEvent = AddFolder(newFolder);
                    context.read<FolderBloc>().add(addFolderEvent);
                    String folderId = await addFolderEvent.completer.future;
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FolderDetail(folderId: folderId)));
                }
                catch(e){
                  showScaffoldMessage(context, e.toString());
                }
              }
              else{
                 showScaffoldMessage(context, 'Title is required');
              }
            },
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.lightGreen),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    user = snapshot.data as UserModel;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _titleEditingController,
                              decoration: const InputDecoration(
                                labelText: "Title",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                hintText: 'Subject, chapter, unit',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightGreen),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _descriptionEditingController,
                              decoration: const InputDecoration(
                                labelText: "Description",
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                hintText: 'What is your folder about?',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle: TextStyle(color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.lightGreen),
                                ),
                              ),
                            ),
                          ]
                        )
                      ),
                    );
                  }
                }
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.lightGreen,
                      ),
                    ],
                  )),
                );
              })),
    );
  }
}
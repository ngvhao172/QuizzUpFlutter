import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/blocs/folder/FolderBloc.dart';
import 'package:final_quizlet_english/blocs/folder/FolderDetailBloc.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderDetail.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderUpdatePage extends StatefulWidget {
  const FolderUpdatePage({super.key, required this.folder});

  final FolderModel folder;

  @override
  State<FolderUpdatePage> createState() => _FolderUpdatePageState();
}

class _FolderUpdatePageState extends State<FolderUpdatePage> {


  late TextEditingController _titleEditingController;
  late TextEditingController _descriptionEditingController;
  late Future<UserModel?> _userFuture;
  late UserModel user;
  @override
  void initState() {
    _userFuture = AuthService().getCurrentUser();
    super.initState();
      _titleEditingController =
        TextEditingController(text: widget.folder.name);
    _descriptionEditingController =
        TextEditingController(text: widget.folder.description);
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
                FolderModel update = FolderModel(userId: user.id!
                , name: _titleEditingController.text, description: _descriptionEditingController.text, id: widget.folder.id);
                // var result = await FolderDao().addFolder(newFolder);
                
                try {
                    UpdateFolder updateFolder = UpdateFolder(update);
                    context.read<FolderBloc>().add(updateFolder);
                    context.read<FolderBloc>().add(LoadFolders(user.id!));
                    context.read<FolderDetailBloc>().add(LoadFolder(update.id!));
                    Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => FolderDetail(folderId: update.id!)));
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
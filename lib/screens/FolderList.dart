import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/blocs/folder/FolderBloc.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderCreate.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/FolderDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderListAdd extends StatefulWidget {
  const FolderListAdd({super.key, required this.topicId});

  final String topicId;

  @override
  State<FolderListAdd> createState() => _FolderListAddState();
}

class _FolderListAddState extends State<FolderListAdd>
     {
  // @override
  // bool get wantKeepAlive => true;

  late UserModel _user;

  late List<FolderModel> folder;

  List<String> foldersClicked = [];

  List<String> addedFoldersAlready = [];

  bool isLoading = false;

  @override
  void initState() {
    FolderDao().getFoldersByTopicId(widget.topicId).then((result) {
      if (result["status"]) {
        folder = result["data"];
        for (var i = 0; i < folder.length; i++) {
          foldersClicked.add(folder[i].id!);
          addedFoldersAlready.add(folder[i].id!);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Add Topic to Folder"),
            centerTitle: true,
            actions: [
              TextButton(
                child: const Text("Done"),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (foldersClicked.isNotEmpty) {
                    for (var i = 0; i < foldersClicked.length; i++) {
                      if (!addedFoldersAlready.contains(foldersClicked[i])) {
                        //chưa tồn tại trong list cũ => thêm
                        FolderDao().addTopicIdToFolder(
                            foldersClicked[i], widget.topicId);
                      }
                    }
                    for (var i = 0; i < addedFoldersAlready.length; i++) {
                      if (!foldersClicked.contains(addedFoldersAlready[i])) {
                        //không tồn tại trong list thêm => xóa
                        FolderDao().removeTopicIdFromFolder(
                            foldersClicked[i], widget.topicId);
                      }
                    }
                  }
                  context.read<FolderBloc>().add(LoadFolders(_user.id!));
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pop(context);
                },
              )
            ]),
        body: (isLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: FutureBuilder(
                      future: AuthService().getCurrentUser(),
                      builder: (context, snaphot) {
                        if (snaphot.connectionState == ConnectionState.done) {
                          _user = snaphot.data!;
                          context.read<FolderBloc>().add(LoadFolders(_user.id!));
                          return Column(
                            children: [
                              BlocBuilder<FolderBloc, FolderState>(
                                builder: (context, state) {
                                  print(state);
                                  if (state is FolderLoading) {
                                    return SizedBox(
                                      height: 500,
                                      child: Skeletonizer(
                                        enabled: true,
                                        child: ListView.builder(
                                          itemCount: 7,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return FolderInfo(
                                                folder: FolderModel(
                                                    name: "", userId: ""),
                                                userName: "123",
                                                userAvatar: null);
                                          },
                                        ),
                                      ),
                                    );
                                  } else if (state is FolderLoaded) {
                                    List<FolderModel> data = state.folders;
                                    if (data.isEmpty) {
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                  Icons.create_new_folder),
                                              title:
                                                  const Text('Create Folder'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const FolderCreatePage()));
                                              },
                                            ),
                                            Text("Chưa có topic nào được thêm"),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              String folderId = data[index].id!;

                                              setState(() {
                                                if (!foldersClicked
                                                    .contains(folderId)) {
                                                  foldersClicked.add(folderId);
                                                } else {
                                                  foldersClicked.removeWhere(
                                                      (item) =>
                                                          item == folderId);
                                                }
                                              });
                                              print(foldersClicked);
                                            },
                                            child: Card(
                                              shape: (foldersClicked.contains(
                                                      data[index].id!))
                                                  ? const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      side: BorderSide(
                                                          color: Colors
                                                              .lightGreen))
                                                  : null,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 20,
                                                    bottom: 10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Icon(Icons
                                                            .folder_open_outlined),
                                                        const SizedBox(
                                                          width: 40,
                                                        ),
                                                        Text(data[index].name)
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                      child: Row(
                                                        children: [
                                                          (data[index].topicIds !=
                                                                  null)
                                                              ? Text(
                                                                  "${data[index].topicIds!.length} topics")
                                                              : const Text(
                                                                  "0 topics"),
                                                          VerticalDivider(
                                                            thickness: 1,
                                                          ),
                                                          CircleAvatar(
                                                            backgroundImage: (_user
                                                                        .photoURL) !=
                                                                    null
                                                                ? CachedNetworkImageProvider(
                                                                    _user
                                                                        .photoURL!)
                                                                : const AssetImage(
                                                                        'assets/images/user.png')
                                                                    as ImageProvider<
                                                                        Object>,
                                                            radius: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            _user.displayName,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.lightGreen,
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.lightGreen,
                          ),
                        );
                      }),
                ),
              ));
  }
}

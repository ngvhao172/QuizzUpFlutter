import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/blocs/folder/FolderBloc.dart';
import 'package:final_quizlet_english/blocs/folder/FolderDetailBloc.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/screens/FolderUpdate.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/screens/TopicAddToFolder.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FolderDetail extends StatefulWidget {
  const FolderDetail({super.key, required this.folderId});

  final String folderId;


  @override
  State<FolderDetail> createState() => _FolderDetailState();
}

class _FolderDetailState extends State<FolderDetail>  {

  late FolderModel lateFolder;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<FolderDetailBloc>().add(LoadFolder(widget.folderId));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Folder'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FolderUpdatePage(folder: lateFolder)));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete Folder'),
                          onTap: () {
                            //delete r về lại trang library
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => LibraryPage()),
                            // );

                            showDialogMessage(
                                context, "Are you sure you want to continue?",
                                () {
                              try {
                                context
                                    .read<FolderBloc>()
                                    .add(RemoveFolder(widget.folderId));
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } catch (e) {
                                showScaffoldMessage(context, e.toString());
                              }
                            }, () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }, "Delete", "Cancel");

                            // context.read<TopicBloc>().add(RemoveTopic(widget.topicId));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.folder_open),
                          title: const Text('Add Topic'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTopicToFolder(folderId: widget.folderId,)));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<FolderDetailBloc, FolderState>(
            builder: (context, state) {
          if (state is FolderDetailLoaded) {
            var folderInfoDTO = state.folderInfoDTO;
            var folder = folderInfoDTO.folder;
            var topics = folderInfoDTO.topics;
            lateFolder = folderInfoDTO.folder;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  folder.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      Text("${topics.length} topics"),
                      const VerticalDivider(
                        thickness: 1,
                      ),
                      CircleAvatar(
                        backgroundImage: (folderInfoDTO.userAvatar != null &&
                                folderInfoDTO.userAvatar != "null")
                            ? CachedNetworkImageProvider(
                                folderInfoDTO.userAvatar!)
                            : const AssetImage("assets/images/user.png")
                                as ImageProvider<Object>?,
                        radius: 10,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        folderInfoDTO.userName,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.lightGreen)),
                    child: const Text(
                      "Học thư mục này",
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                (topics.isNotEmpty) ?  Expanded(
                  child: ListView.builder(
                    itemCount: topics.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TopicInfo(
                        topicId: topics[index].topic.id!,
                        title: topics[index].topic.name,
                        termNumbers: topics[index].termNumbers,
                        authorName: topics[index].authorName,
                        playersCount: topics[index].playersCount,
                        userAvatar: topics[index].userAvatar,
                        userId: folder.userId,
                      );
                    },
                  ),
                )
                : Expanded(child: const Center(child: Text("Chưa có topic nào được thêm trong folder này"),))
              ],
            );
          } else {
            return Skeletonizer(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thức ăn và nước uống",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      Text("0 topics"),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/user.png')
                            as ImageProvider<Object>,
                        radius: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Nguyễn Văn Hào",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.lightGreen)),
                    child: const Text(
                      "Học thư mục này",
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
                ]),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      return const TopicInfo(
                        topicId: "1234",
                        title: "1234",
                        termNumbers: 2,
                        authorName: "1234",
                        playersCount: 2,
                        userAvatar: null,
                        userId: "",
                      );
                    },
                  ),
                )
              ],
            ));
          }
        }),
      ),
    );
  }
}

// class FolderDetailInfo extends StatelessWidget {
//   const FolderDetailInfo({
//     super.key,
//     required this.folder,
//     required this.topics,
//   });

//   final FolderModel folder;
//   final List<TopicInfoDTO> topics;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Thức ăn và nước uống",
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         SizedBox(
//           height: 20,
//           child: Row(
//             children: [
//               Text("0 topics"),
//               VerticalDivider(
//                 thickness: 1,
//               ),
//               CircleAvatar(
//                 backgroundImage: AssetImage('assets/images/user.png')
//                     as ImageProvider<Object>,
//                 radius: 10,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 "Nguyễn Văn Hào",
//                 style: TextStyle(color: Colors.grey, fontSize: 10),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Row(children: [
//           Expanded(
//               child: ElevatedButton(
//             onPressed: () {},
//             child: const Text(
//               "Học thư mục này",
//               style: TextStyle(color: Colors.white),
//             ),
//             style: ButtonStyle(
//                 backgroundColor:
//                     MaterialStatePropertyAll<Color>(Colors.lightGreen)),
//           ))
//         ]),
//         SizedBox(
//           height: 20,
//         ),
//         TopicInfo(
//           topicId: "2",
//           title: "Food",
//           termNumbers: 4,
//           authorName: "Nguyen Van Hao",
//           playersCount: 2,
//           userAvatar: null,
//           userId: "123",
//         ),
//         TopicInfo(
//           topicId: "2",
//           title: "Food",
//           termNumbers: 4,
//           authorName: "Nguyen Van Hao",
//           playersCount: 2,
//           userAvatar: null,
//           userId: "123",
//         ),
//         TopicInfo(
//           topicId: "2",
//           title: "Food",
//           termNumbers: 4,
//           authorName: "Nguyen Van Hao",
//           playersCount: 2,
//           userAvatar: null,
//           userId: "123",
//         ),
//         TopicInfo(
//           topicId: "2",
//           title: "Food",
//           termNumbers: 4,
//           authorName: "Nguyen Van Hao",
//           playersCount: 2,
//           userAvatar: null,
//           userId: "123",
//         ),
//       ],
//     );
//   }
// }

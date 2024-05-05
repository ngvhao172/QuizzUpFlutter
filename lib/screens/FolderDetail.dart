import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FolderDetail extends StatefulWidget {
  const FolderDetail({super.key});

  @override
  State<FolderDetail> createState() => _FolderDetailState();
}

class _FolderDetailState extends State<FolderDetail> {
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
                              Navigator.pop(context);
                              Navigator.pop(context);
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
                          onTap: () {},
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.more_vert))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thức ăn và nước uống",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
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
            SizedBox(
              height: 20,
            ),
            Row(children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Học thư mục này",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.lightGreen)),
              ))
            ]),
            SizedBox(
              height: 20,
            ),
            TopicInfo(
              topicId: "2",
              title: "Food",
              termNumbers: 4,
              authorName: "Nguyen Van Hao",
              playersCount: 2,
              userAvatar: null,
              userId: "123",
            ),
            TopicInfo(
              topicId: "2",
              title: "Food",
              termNumbers: 4,
              authorName: "Nguyen Van Hao",
              playersCount: 2,
              userAvatar: null,
              userId: "123",
            ),
            TopicInfo(
              topicId: "2",
              title: "Food",
              termNumbers: 4,
              authorName: "Nguyen Van Hao",
              playersCount: 2,
              userAvatar: null,
              userId: "123",
            ),
            TopicInfo(
              topicId: "2",
              title: "Food",
              termNumbers: 4,
              authorName: "Nguyen Van Hao",
              playersCount: 2,
              userAvatar: null,
              userId: "123",
            ),
          ],
        ),
      ),
    );
  }
}

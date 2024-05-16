import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/dtos/FolderInfo.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderDetail.dart';
import 'package:final_quizlet_english/screens/Report.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:final_quizlet_english/screens/searchPage.dart';
import 'package:final_quizlet_english/services/FolderDao.dart';
import 'package:final_quizlet_english/services/PageChangeNotifier.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  List<TopicInfoDTO>? topicDTOs;
  List<FolderModel>? folderDTOs;
  UserModel? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthService().getCurrentUser().then((value) {
      setState(() {
        _user = value;
      });
      TopicDao()
          .getPublicTopicInfoDTOsRecentlyAccessed(_user!.id!)
          .then((value) {
        print(value);
        if (value["status"]) {
          setState(() {
            topicDTOs = value["data"];
          });
        }
      });
      FolderDao().getFoldersByUserId(_user!.id!).then((value) {
        print(value);
        if (value["status"]) {
          List<FolderModel> folders = [];
          for (var folder in value["data"]) {
            folders.add(folder);
          }
          setState(() {
            folderDTOs = folders;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (_user != null)
        ? Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          (_user!.photoURL != null && _user!.photoURL != "null")
                              ? CachedNetworkImageProvider(_user!.photoURL!)
                              : const AssetImage("assets/images/user.png")
                                  as ImageProvider<Object>?,
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      _user!.displayName,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 12.0),
                  child: Image.asset(
                    "assets/images/QLogo.png",
                    fit: BoxFit.cover, // Ensure the image covers the container
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: AuthService().getCurrentUser(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          _user = snapshot.data as UserModel;
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: TextField(
                                          keyboardType: TextInputType.none,
                                          onChanged: (value) {},
                                          decoration: const InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            hintText:
                                                "Search topic, creator, ...",
                                            prefixIcon: Icon(Icons.search),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchPage(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => ReportPage()),
                                        // );
                                        PageProvider dataProvider =
                                            context.read<PageProvider>();
                                        dataProvider.updateData(1);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightBlue[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 20, right: 12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  'View Reports ',
                                                  style: TextStyle(
                                                    //fontSize: 16,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14,
                                                  color: Colors.grey.shade700,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Image.asset(
                                              'assets/images/studyboy.png',
                                              height: 85,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        PageProvider dataProvider =
                                            context.read<PageProvider>();
                                        dataProvider.updateData(2);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange[50],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 20, right: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  'My Library ',
                                                  style: TextStyle(
                                                    //fontSize: 16,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14,
                                                  color: Colors.grey.shade700,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Image.asset(
                                              'assets/images/studygirl.png',
                                              height: 95,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Topics",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LibraryPage()));
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "See more",
                                            style: TextStyle(
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                            color: Colors.lightGreen,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: (topicDTOs != null)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // ListView.builder(
                                            //     reverse: true,
                                            //     scrollDirection: Axis.horizontal,
                                            //     itemCount: topicDTOs!.length,
                                            //     itemBuilder: (context, index) {
                                            //       return topicOption(
                                            //         color: Colors.orange[50]!,
                                            //         title: topicDTOs![index].topic.name,
                                            //         subtitle: topicDTOs![index].authorName,
                                            //         image: topicDTOs![index].userAvatar,
                                            //         term: topicDTOs![index].termNumbers.toString());
                                            //   },),
                                            for (int index = 0;
                                                index < topicDTOs!.length;
                                                index++)
                                              topicOption(
                                                  topicId: topicDTOs![index]
                                                      .topic
                                                      .id!,
                                                  color: Colors.orange[50]!,
                                                  title: topicDTOs![index]
                                                      .topic
                                                      .name,
                                                  subtitle: topicDTOs![index]
                                                      .authorName,
                                                  image: topicDTOs![index]
                                                      .userAvatar,
                                                  term: topicDTOs![index]
                                                      .termNumbers
                                                      .toString())
                                          ],
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(
                                          color: Colors.lightGreen,
                                        )),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Folders",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        PageProvider dataProvider =
                                            context.read<PageProvider>();
                                        dataProvider.updateData(2);
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "See more",
                                            style: TextStyle(
                                              color: Colors.lightGreen,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                            color: Colors.lightGreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: (folderDTOs != null)
                                          ? Row(
                                              children: [
                                                for (int index = 0;
                                                    index < folderDTOs!.length;
                                                    index++)
                                                  folderOption(
                                                      folderId:
                                                          folderDTOs![index]
                                                              .id!,
                                                      color: Colors.orange[50]!,
                                                      title: folderDTOs![index]
                                                          .name,
                                                      subtitle:
                                                          _user!.displayName,
                                                      image: _user!.photoURL,
                                                      topic: (folderDTOs![index]
                                                                  .topicIds !=
                                                              null)
                                                          ? folderDTOs![index]
                                                              .topicIds!
                                                              .length
                                                              .toString()
                                                          : "0"),
                                              ],
                                            )
                                          : const Center(
                                              child: CircularProgressIndicator(
                                              color: Colors.lightGreen,
                                            )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.lightGreen,
                      ));
                    }),
              ),
            ),
          )
        : const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.lightGreen,
            )),
          );
  }

  Widget topicOption({
    required Color color,
    required String title,
    required String subtitle,
    String? image,
    required String term,
    required String topicId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TDetailPage(
                      topicId: topicId,
                      userId: _user!.id!,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.only(left: 20),
        height: 120,
        width: 240,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.orange.shade200, width: 0.7),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.lightGreen[100],
                ),
                child: Text(
                  '$term terms',
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: (image != null && image != "null")
                        ? CachedNetworkImageProvider(image)
                        : const AssetImage("assets/images/user.png")
                            as ImageProvider<Object>?,
                    radius: 12,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              )
            ]),
      ),
    );
  }

  Widget folderOption({
    required Color color,
    required String title,
    required String subtitle,
    required String folderId,
    String? image,
    required String topic,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FolderDetail(
                      folderId: folderId,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.only(left: 20),
        height: 120,
        width: 240,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.orange.shade200, width: 0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_open_outlined),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text("$topic topics"),
                  const SizedBox(
                    width: 5,
                  ),
                  const VerticalDivider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundImage: (image != null && image != "null")
                        ? CachedNetworkImageProvider(image)
                        : const AssetImage("assets/images/user.png")
                            as ImageProvider<Object>?,
                    radius: 12,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[700]),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

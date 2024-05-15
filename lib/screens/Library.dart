import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/blocs/folder/FolderBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/dtos/VocabInfo.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderCreate.dart';
import 'package:final_quizlet_english/screens/FolderDetail.dart';
import 'package:final_quizlet_english/screens/Profile.dart';
import 'package:final_quizlet_english/screens/TopicCreate.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  bool isSearchExpanded = false;
  FocusNode focusNode = FocusNode();
  String dropdownvalue = 'All';
  int percentage = 40;

  final ScrollController _scrollController = ScrollController();

  Widget _buildCarousel() {
    return AppBar(
      title: isSearchExpanded
          ? null
          : const Text(
              'Library',
            ),
      automaticallyImplyLeading: false,
      actions: [
        AnimatedContainer(
          width:
              isSearchExpanded ? MediaQuery.of(context).size.width - 22 : 170,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: isSearchExpanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleSearch,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          onChanged: (value) {},
                          onTap: _toggleSearch,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _toggleSearch();
                        },
                        icon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
    );
  }

  var items = [
    'All',
    'Created',
    'Studied',
    'Liked',
  ];

  @override
  bool get wantKeepAlive => true;

  UserModel? _user;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    AuthService().getCurrentUser().then((user) {
      print(user?.id);
      setState(() {
        _user = user!;
      });

      context.read<TopicBloc>().add(LoadTopics(_user!.id!));

      context.read<FolderBloc>().add(LoadFolders(_user!.id!));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    focusNode.dispose();
  }

  void _toggleSearch() {
    setState(() {
      if (isSearchExpanded) {
        focusNode.unfocus();
      } else {
        focusNode.requestFocus();
      }
      isSearchExpanded = !isSearchExpanded;
    });
  }
  List<List<dynamic>> csvData = [];
  
  Future<void> _importCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String csvString = await file.readAsString();

      List<List<dynamic>> parsedCSV = const CsvToListConverter().convert(csvString);
      
      Navigator.push(context, MaterialPageRoute(builder: (context) => TCreatePage(importData: parsedCSV,)));
      print(parsedCSV);

    } else {
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (_user == null)
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen[700],
                ),
              )
            : NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(child: _buildCarousel()),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(
                            25.0,
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          splashBorderRadius: BorderRadius.circular(25.0),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Colors.lightGreen,
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: const [
                            Tab(
                              text: 'Topics',
                            ),
                            Tab(
                              text: 'Collections',
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: Container(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              height: 40,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 0.80),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  elevation: 0,
                                  value: dropdownvalue,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items.map((String items) {
                                    return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                        onTap: () {
                                          print(items);
                                          if (items.compareTo("Created") == 0) {
                                            print("created load");
                                            context.read<TopicBloc>().add(
                                                LoadTopicsByCreatedDay(
                                                    _user!.id!));
                                          }
                                        });
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: const Icon(
                                              Icons.create_new_folder),
                                          title: const Text('Create Topic'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TCreatePage()),
                                            );
                                          },
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.file_present),
                                          title: const Text('Upload file CSV'),
                                          onTap: () {
                                            _importCSV();
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: Colors.lightGreen,
                                  ),
                                  Text(
                                    ' Creation new',
                                    style: TextStyle(color: Colors.lightGreen),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: BlocBuilder<TopicBloc, TopicState>(
                                  builder: (context, state) {
                                    print(state);
                                    if (state is TopicLoading) {
                                      // return const Center(
                                      //   child: CircularProgressIndicator(
                                      //     color: Colors.lightGreen,
                                      //   ),
                                      // );
                                      return Skeletonizer(
                                        enabled: true,
                                        child: ListView.builder(
                                          itemCount: 7,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return const TopicInfo(
                                              topicId: "",
                                              title: "",
                                              termNumbers: 0,
                                              authorName: "",
                                              playersCount: 0,
                                              userAvatar: null,
                                              userId: "",
                                              vocabs: [],
                                            );
                                          },
                                        ),
                                      );
                                    } else if (state is TopicLoaded) {
                                      List<TopicInfoDTO> data = state.topics;
                                      print(data);
                                      DateTime today = DateTime.now();
                                      DateTime yesterday =
                                          today.subtract(Duration(days: 1));
                                      // currentTopics = topics["data"];
                                      List<TopicInfoDTO> todayTopics = [];
                                      List<TopicInfoDTO> yesterdayTopics = [];
                                      List<TopicInfoDTO> thisWeekTopics = [];
                                      List<TopicInfoDTO> olderTopics = [];
                                      for (var topicDTO in data) {
                                        print(topicDTO.vocabs!.length);
                                        if (DateFormat('yyyy-MM-dd').format(
                                                topicDTO.topic.lastAccessed) ==
                                            DateFormat('yyyy-MM-dd')
                                                .format(today)) {
                                          todayTopics.add(topicDTO);
                                        }
                                        if (DateFormat('yyyy-MM-dd').format(
                                                topicDTO.topic.lastAccessed) ==
                                            DateFormat('yyyy-MM-dd')
                                                .format(yesterday)) {
                                          yesterdayTopics.add(topicDTO);
                                        }
                                        if (DateFormat('yyyy-MM-dd')
                                                    .format(topicDTO
                                                        .topic.lastAccessed)
                                                    .compareTo(DateFormat('yyyy-MM-dd')
                                                        .format(today.subtract(
                                                            Duration(
                                                                days: 7)))) >=
                                                0 &&
                                            DateFormat('yyyy-MM-dd')
                                                    .format(topicDTO
                                                        .topic.lastAccessed)
                                                    .compareTo(
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(today.subtract(Duration(days: 2)))) <=
                                                0) {
                                          thisWeekTopics.add(topicDTO);
                                        }
                                        if (DateFormat('yyyy-MM-dd')
                                                .format(
                                                    topicDTO.topic.lastAccessed)
                                                .compareTo(DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(today.subtract(
                                                        Duration(days: 7)))) <
                                            0) {
                                          olderTopics.add(topicDTO);
                                        }
                                      }
                                      if (data.isEmpty) {
                                        return const Center(
                                          child: Text(
                                              "Chưa có topic nào được thêm"),
                                        );
                                      } else {
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              (todayTopics.isNotEmpty)
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                        "Today",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    )
                                                  : Container(),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: todayTopics.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return TopicInfo(
                                                    topicId: todayTopics[index]
                                                        .topic
                                                        .id!,
                                                    title: todayTopics[index]
                                                        .topic
                                                        .name,
                                                    termNumbers:
                                                        todayTopics[index]
                                                            .termNumbers,
                                                    authorName:
                                                        todayTopics[index]
                                                            .authorName,
                                                    playersCount:
                                                        todayTopics[index]
                                                            .playersCount,
                                                    userAvatar:
                                                        todayTopics[index]
                                                            .userAvatar,
                                                    userId: _user!.id!,
                                                    vocabs: todayTopics[index].vocabs!,
                                                  );
                                                },
                                              ),
                                              (yesterdayTopics.isNotEmpty)
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 20),
                                                      child: Text(
                                                        "Yesterday",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    )
                                                  : Container(),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    yesterdayTopics.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return TopicInfo(
                                                    topicId:
                                                        yesterdayTopics[index]
                                                            .topic
                                                            .id!,
                                                    title:
                                                        yesterdayTopics[index]
                                                            .topic
                                                            .name,
                                                    termNumbers:
                                                        yesterdayTopics[index]
                                                            .termNumbers,
                                                    authorName:
                                                        yesterdayTopics[index]
                                                            .authorName,
                                                    playersCount:
                                                        yesterdayTopics[index]
                                                            .playersCount,
                                                    userAvatar:
                                                        yesterdayTopics[index]
                                                            .userAvatar,
                                                    userId: _user!.id!,
                                                    vocabs: yesterdayTopics[index].vocabs!,
                                                  );
                                                },
                                              ),
                                              (thisWeekTopics.isNotEmpty)
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 20),
                                                      child: Text(
                                                        "This week",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    )
                                                  : Container(),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    thisWeekTopics.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return TopicInfo(
                                                    topicId:
                                                        thisWeekTopics[index]
                                                            .topic
                                                            .id!,
                                                    title: thisWeekTopics[index]
                                                        .topic
                                                        .name,
                                                    termNumbers:
                                                        thisWeekTopics[index]
                                                            .termNumbers,
                                                    authorName:
                                                        thisWeekTopics[index]
                                                            .authorName,
                                                    playersCount:
                                                        thisWeekTopics[index]
                                                            .playersCount,
                                                    userAvatar:
                                                        thisWeekTopics[index]
                                                            .userAvatar,
                                                    userId: _user!.id!,
                                                    vocabs: thisWeekTopics[index].vocabs!,
                                                  );
                                                },
                                              ),
                                              (olderTopics.isNotEmpty)
                                                  ? Container(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      margin: EdgeInsets.only(
                                                          left: 10, top: 20),
                                                      child: Text(
                                                        "Older",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[700]),
                                                      ),
                                                    )
                                                  : Container(),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: olderTopics.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return TopicInfo(
                                                    topicId: olderTopics[index]
                                                        .topic
                                                        .id!,
                                                    title: olderTopics[index]
                                                        .topic
                                                        .name,
                                                    termNumbers:
                                                        olderTopics[index]
                                                            .termNumbers,
                                                    authorName:
                                                        olderTopics[index]
                                                            .authorName,
                                                    playersCount:
                                                        olderTopics[index]
                                                            .playersCount,
                                                    userAvatar:
                                                        olderTopics[index]
                                                            .userAvatar,
                                                    userId: _user!.id!,
                                                    vocabs: todayTopics[index].vocabs!,
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
                                          ),
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
                              ),
                            ),
                          ]),
                      //FOLDER FRAGMENT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 40,
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                elevation: 0,
                                value: dropdownvalue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                      onTap: () {
                                        print(items);
                                        if (items.compareTo("Created") == 0) {
                                          print("created load");
                                          context.read<TopicBloc>().add(
                                              LoadTopicsByCreatedDay(
                                                  _user!.id!));
                                        }
                                      });
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading:
                                            const Icon(Icons.create_new_folder),
                                        title: const Text('Create Folder'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FolderCreatePage()));
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.file_present),
                                        title: const Text('Upload file CSV'),
                                        onTap: () {
                                          
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  color: Colors.lightGreen,
                                ),
                                Text(
                                  ' Creation new',
                                  style: TextStyle(color: Colors.lightGreen),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Today",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: BlocBuilder<FolderBloc, FolderState>(
                                builder: (context, state) {
                                  print(state);
                                  if (state is FolderLoading) {
                                    // return const Center(
                                    //   child: CircularProgressIndicator(
                                    //     color: Colors.lightGreen,
                                    //   ),
                                    // );
                                    return Skeletonizer(
                                      enabled: true,
                                      child: ListView.builder(
                                        itemCount: 7,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return FolderInfo(
                                              folder: FolderModel(
                                                  name: "", userId: ""),
                                              userName: "123",
                                              userAvatar: null);
                                        },
                                      ),
                                    );
                                  } else if (state is FolderLoaded) {
                                    List<FolderModel> data = state.folders;
                                    if (data.isEmpty) {
                                      return const Center(
                                        child: Text(
                                            "Chưa có folder nào được thêm"),
                                      );
                                    } else {
                                      return ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return FolderInfo(
                                              folder: data[index],
                                              userName: _user!.displayName,
                                              userAvatar: _user!.photoURL);
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
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}

class FolderInfo extends StatelessWidget {
  const FolderInfo(
      {super.key,
      required this.folder,
      this.userAvatar,
      required this.userName});
  final FolderModel folder;

  final String? userAvatar;

  final String userName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FolderDetail(folderId: folder.id!)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.folder_open_outlined),
                  const SizedBox(
                    width: 40,
                  ),
                  Text(folder.name)
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 20,
                child: Row(
                  children: [
                    (folder.topicIds != null)
                        ? Text("${folder.topicIds!.length} topics")
                        : const Text("0 topics"),
                    VerticalDivider(
                      thickness: 1,
                    ),
                    CircleAvatar(
                      backgroundImage: (userAvatar) != null
                          ? CachedNetworkImageProvider(userAvatar!)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider<Object>,
                      radius: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      userName,
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopicInfo extends StatelessWidget {
  const TopicInfo({
    super.key,
    required this.topicId,
    required this.title,
    required this.termNumbers,
    required this.authorName,
    required this.playersCount,
    required this.userId,
    required this.vocabs,
    this.userAvatar,
  });

  final List<VocabInfoDTO> vocabs;
  final String topicId;
  final String title;
  final int termNumbers;
  final String authorName;
  final int playersCount;
  final String userId;
  final String? userAvatar;

  @override
  Widget build(BuildContext context) {
    int learnedVocabs = 0;
    for (var vocab in vocabs) {
      print(vocab);
      //2: knew, 3: mastered
      if(vocab.vocabStatus.status == 2 || vocab.vocabStatus.status == 3){
        learnedVocabs ++;
      }
    }
    double percentage = learnedVocabs/vocabs.length*100;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TDetailPage(topicId: topicId, userId: userId)),
        );
      },
      child: Card(
        color: Colors.orange[50],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Skeleton.ignore(
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: SfRadialGauge(
                    axes: <RadialAxis>[
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        showLabels: false,
                        showTicks: false,
                        startAngle: 270,
                        endAngle: 270,
                        axisLineStyle: const AxisLineStyle(
                          thickness: 0.2,
                          cornerStyle: CornerStyle.bothCurve,
                          color: Color.fromARGB(30, 0, 169, 181),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: percentage,
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.2,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Colors.lightGreen,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                            positionFactor: 0.1,
                            angle: 90,
                            widget: Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.orange),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              title: Text(title), //tên Topics
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text('$termNumbers terms'), // size topics
                      const Icon(Icons.play_arrow_outlined),
                      Text('$playersCount players'), // size players],)
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: (userAvatar) != null
                            ? CachedNetworkImageProvider(userAvatar!)
                            : const AssetImage('assets/images/user.png')
                                as ImageProvider<Object>,
                        radius: 10,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        authorName,
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderDetail.dart';
import 'package:final_quizlet_english/screens/Profile.dart';
import 'package:final_quizlet_english/screens/TopicCreate.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSearchExpanded = false;
  FocusNode focusNode = FocusNode();
  String dropdownvalue = 'All';
  int percentage = 40;

  var items = [
    'All',
    'Created',
    'Studied',
    'Liked',
  ];

  late UserModel _user;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    AuthService().getCurrentUser().then((user) {
      print(user?.id);
      _user = user!;

      context.read<TopicBloc>().add(LoadTopics(_user.id!));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchExpanded
            ? null
            : const Text(
                'Library',
              ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              icon: Icon(Icons.person)),
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
      ),
      body: GestureDetector(
        onTap: () {
          if (isSearchExpanded) {
            _toggleSearch();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
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
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                                            LoadTopicsByCreatedDay(_user.id!));
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
                        const SizedBox(
                          height: 10,
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
                                      title: const Text('Create Topic'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TCreatePage()),
                                        );
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
                          height: 20,
                        ),
                        Text(
                          "Today",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                        Expanded(
                          child: BlocBuilder<TopicBloc, TopicState>(
                            builder: (context, state) {
                              print(state);
                              if (state is TopicLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.lightGreen,
                                  ),
                                );
                              } else if (state is TopicLoaded) {
                                List<TopicInfoDTO> data = state.topics;
                                if (data.isEmpty) {
                                  return const Center(
                                    child: Text("Chưa có topic nào được thêm"),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return TopicInfo(
                                        topicId: data[index].topic.id!,
                                        title: data[index].topic.name,
                                        termNumbers: data[index].termNumbers,
                                        authorName: data[index].authorName,
                                        playersCount: data[index].playersCount,
                                        userAvatar: data[index].userAvatar,
                                        userId: _user.id!,
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
                        )
                      ],
                    ),
                    //folder
                    // const Center(
                    //   child: Text(
                    //     'Để làm sauuuuu',
                    //     style: TextStyle(
                    //       fontSize: 25,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                    SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
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
                                            LoadTopicsByCreatedDay(_user.id!));
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
                        const SizedBox(
                          height: 10,
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
                          height: 20,
                        ),
                        Text(
                          "Today",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                        Column(
                          children: [
                            FolderInfo(),
                            FolderInfo(),
                            FolderInfo(),
                            FolderInfo()
                          ],
                        ),
                      ],
                    )),
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

class FolderInfo extends StatelessWidget {
  const FolderInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FolderDetail()));
      },
      child: const Card(
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.folder_open_outlined),
                  SizedBox(
                    width: 40,
                  ),
                  Text("Thức ăn và nước uống")
                ],
              ),
              SizedBox(
                width: 10,
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
                      backgroundImage:
                          const AssetImage('assets/images/user.png')
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
    this.userAvatar,
  });

  final String topicId;
  final String title;
  final int termNumbers;
  final String authorName;
  final int playersCount;
  final String userId;
  final String? userAvatar;

  @override
  Widget build(BuildContext context) {
    int percentage = 40;
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
              leading: SizedBox(
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
                      pointers: const <GaugePointer>[
                        RangePointer(
                          value: 40,
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
                            percentage.toStringAsFixed(0) + '%',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.orange),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              title: Text(title), //tên Topics
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Text('$termNumbers terms'), // size topics
                      Icon(Icons.play_arrow_outlined),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/HistorySearch.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';
import 'package:final_quizlet_english/services/HistorySearchDao.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _topics = [
    // {
    //   'title': 'Color',
    //   'subtitle': 'Pham',
    //   'image': 'assets/images/user.png',
    //   'term': '3',
    // },
    // {
    //   'title': 'Food',
    //   'subtitle': 'Nhat',
    //   'image': 'assets/images/user.png',
    //   'term': '5',
    // },
    // {
    //   'title': 'Items',
    //   'subtitle': 'Quynh',
    //   'image': 'assets/images/user.png',
    //   'term': '5',
    // }
  ];
  List<Map<String, dynamic>> _users = [
    {
      'title': 'Pham',
      'image': 'assets/images/user.png',
      'topic': '3',
    },
    {
      'title': 'Nhat',
      'image': 'assets/images/user.png',
      'topic': '5',
    },
    {
      'title': 'Quynh',
      'image': 'assets/images/user.png',
      'topic': '5',
    },
  ];
  bool isLoaded = false;
  bool isSearching = false;
  List<Map<String, dynamic>> _filteredUsers = [];
  List<Map<String, dynamic>> _filteredTopics = [];

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredUsers = _users;
    _filteredTopics = _topics;

    AuthService().getCurrentUser().then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  void _filterUsers(String query) {
    setState(() {
      query = query.toLowerCase();
      _filteredUsers = _users
          .where((user) => user['title'].toLowerCase().contains(query))
          .toList();
    });
  }

  getData(String value) async{
    setState(() {
      isSearching = true;
    });
    List<Map<String, dynamic>> _topicsDTO = [];
    // await Future.delayed(Duration(seconds: 2)); query data
    var res = await TopicDao().getPublicTopicInfoDTOsByTopicName(value);
    print(res);
    if(res["status"]){
      List<TopicInfoDTO> topicDTOs = res["data"];
      for (var topicDTO in topicDTOs) {
        Map<String, dynamic> map = {
          'title': topicDTO.topic.name,
          'subtitle': topicDTO.authorName,
          'image': topicDTO.userAvatar,
          'term': topicDTO.termNumbers,
          'userId': topicDTO.topic.userId,
          'topicId': topicDTO.topic.id
        };  
        _topicsDTO.add(map);
      }
      if(_topicsDTO.isNotEmpty){
        setState(() {
          _topics = _topicsDTO;
        });
      }
    }
    setState(() {
      isSearching = false;
      isLoaded = true;
    });
  }

  // void _filterTopics(String query) {
  //   setState(() {
  //     query = query.toLowerCase();
  //     _filteredTopics = _topics
  //         .where((topic) =>
  //             topic['title'].toLowerCase().contains(query) ||
  //             topic['subtitle'].toLowerCase().contains(query))
  //         .toList();
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context, "false");
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: _searchController,
            // onChanged: (query) {
            //   _filterTopics(query);
            //   _filterUsers(query);
            // },
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: "Search topic, creator,...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    isLoaded = false;
                    isSearching = false;
                  });
                  // _filterTopics('');
                  // _filterUsers('');
                },
              ),
            ),
            onSubmitted: (value)async{
              //save
              HistorySearch history = HistorySearch(userId: _user!.id!, searchContent: value);
              print(await HistorySearchDao().addHistorySearch(history));
              
              //query data
              await getData(value);
            },
          ),
        ),
        bottom: (isLoaded)
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.lightGreen,
                indicatorColor: Colors.lightGreen,
                tabs: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Tab(text: 'Topics'),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Tab(text: 'Users'),
                  ),
                ],
              )
            : null,
      ),
      body: (_user != null)
      ?(!isSearching)
          ? (isLoaded)
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    (_topics.isNotEmpty) ?
                    ListView.builder(
                      itemCount: _topics.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: double.infinity,
                          child: topicOption(
                            color: Colors.orange[50]!,
                            title: _topics[index]['title'],
                            subtitle: _topics[index]['subtitle'],
                            image: _topics[index]['image'],
                            term: _topics[index]['term'].toString(),
                            userId: _topics[index]['userId'].toString(),
                            topicId: _topics[index]['topicId'].toString(),
                          ),
                        );
                      },
                    ): const Center(child: Text("Cant found any topic"),),
                    ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: double.infinity,
                          child: userOption(
                            color: Colors.orange[50]!,
                            title: _filteredUsers[index]['title'],
                            image: _filteredUsers[index]['image'],
                            topic: _filteredUsers[index]['topic'],
                          ),
                        );
                      },
                    ),
                  ],
                )
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.history),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "History",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      FutureBuilder(
                          future: HistorySearchDao()
                              .getHistorySearchsByUserId(_user!.id!),
                          builder: (context, snapshot) {
                            print(snapshot);
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                var res = snapshot.data as Map<String, dynamic>;
                                if (res["status"]) {
                                  List<HistorySearch> searchs = [];
                                  for (var element in res["data"]) {
                                    searchs.add(HistorySearch.fromJson(element));
                                  }
                                  searchs.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
                                  if (searchs.isNotEmpty) {
                                    return Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: searchs.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            contentPadding: EdgeInsets.symmetric(vertical: -2),
                                            title: Text(
                                                searchs[index].searchContent, style: TextStyle(fontSize: 17),),
                                            onTap: () async {
                                              _searchController.text =
                                                  searchs[index].searchContent;

                                              await getData(_searchController.text);
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Not searching yet"),
                                      ],
                                    );
                                  }
                                }
                              }
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.lightGreen,
                              ),
                            );
                          })
                    ],
                  ),
                )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.lightGreen,
              ),
            ) : const Center(
              child: CircularProgressIndicator(
                color: Colors.lightGreen,
              ),
            ),
    );
  }

  Widget topicOption({
    required String userId,
    required String topicId,
    required Color color,
    required String title,
    required String subtitle,
    required String image,
    required String term,
  }) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TDetailPage(userId: userId, topicId: topicId)));
      },
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.only(left: 20),
            height: 120,
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
                      backgroundImage: (image != null &&
                                            image != "null")
                                        ? CachedNetworkImageProvider(
                                            image)
                                        : const AssetImage(
                                                "assets/images/user.png")
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userOption({
    required Color color,
    required String title,
    required String image,
    required String topic,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          padding: const EdgeInsets.only(left: 20),
          height: 120,
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
                  CircleAvatar(
                    backgroundImage: AssetImage(image),
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.my_library_books_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '$topic Topics',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

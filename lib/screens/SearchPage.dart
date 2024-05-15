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
    {
      'title': 'Color',
      'subtitle': 'Pham',
      'image': 'assets/images/user.png',
      'term': '3',
    },
    {
      'title': 'Food',
      'subtitle': 'Nhat',
      'image': 'assets/images/user.png',
      'term': '5',
    },
    {
      'title': 'Items',
      'subtitle': 'Quynh',
      'image': 'assets/images/user.png',
      'term': '5',
    },
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
  List<Map<String, dynamic>> _filteredUsers = [];
  List<Map<String, dynamic>> _filteredTopics = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredUsers = _users;
    _filteredTopics = _topics;
  }

  void _filterUsers(String query) {
    setState(() {
      query = query.toLowerCase();
      _filteredUsers = _users
          .where((user) => user['title'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _filterTopics(String query) {
    setState(() {
      query = query.toLowerCase();
      _filteredTopics = _topics
          .where((topic) =>
              topic['title'].toLowerCase().contains(query) ||
              topic['subtitle'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 25.0,
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
            onChanged: (query) {
              _filterTopics(query);
              _filterUsers(query);
            },
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: "Search topic, creator,...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterTopics('');
                  _filterUsers('');
                },
              ),
            ),
          ),
        ),
        bottom: TabBar(
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
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: _filteredTopics.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: double.infinity,
                child: topicOption(
                  color: Colors.orange[50]!,
                  title: _filteredTopics[index]['title'],
                  subtitle: _filteredTopics[index]['subtitle'],
                  image: _filteredTopics[index]['image'],
                  term: _filteredTopics[index]['term'],
                ),
              );
            },
          ),
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
      ),
    );
  }

  Widget topicOption({
    required Color color,
    required String title,
    required String subtitle,
    required String image,
    required String term,
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
                    backgroundImage: AssetImage(image),
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

import 'package:final_quizlet_english/screens/TopicCreate.dart';
import 'package:final_quizlet_english/screens/TopicDetail.dart';

import 'package:flutter/material.dart';

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
  var items = [
    'All',
    'Created',
    'Studied',
    'Liked',
  ];
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
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
      ),
      body: GestureDetector(
        onTap: () {
          if (isSearchExpanded) {
            _toggleSearch();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                      text: 'Colections',
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
                                    value: items, child: Text(items));
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
                                      title: const Text('Create Topic'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TCreatePage()),
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
                        GestureDetector(
                          onTap: () {
                            //chuyển trang học tập mà mệt quá chưa làm tới
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TDetailPage()),
                            );
                          },
                          child: Card(
                            color: Colors.orange[50],
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Image(
                                    image: AssetImage(
                                        'assets/images/QLogo.png'), //để nào design logo theo filter
                                  ),
                                  title: Text('Color'), //tên Topics
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('3 terms'), // size topics
                                          Icon(Icons.play_arrow_outlined),
                                          Text('2 players'), // size players],)
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/user.png'), //để nào design logo theo filter
                                            radius: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Phạm Nhật Quỳnh",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // size topic á //có mấy người học này
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //chuyển trang học tập mà mệt quá chưa làm tới
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TDetailPage()),
                            );
                          },
                          child: Card(
                            color: Colors.orange[50],
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Image(
                                    image: AssetImage(
                                        'assets/images/QLogo.png'), //để nào design logo theo filter
                                  ),
                                  title: Text('Color'), //tên Topics
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('3 terms'), // size topics
                                          Icon(Icons.play_arrow_outlined),
                                          Text('2 players'), // size players],)
                                        ],
                                      ),
                                      Divider(),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/user.png'), //để nào design logo theo filter
                                            radius: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Phạm Nhật Quỳnh",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ), // size topic á //có mấy người học này
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

//folder
                    const Center(
                      child: Text(
                        'Để làm sauuuuu',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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

import 'package:flutter/material.dart';
import 'ReportStaticPage.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isSearchExpanded = false;
  FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
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
        title: Text('Reports'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: AnimatedContainer(
              width: isSearchExpanded
                  ? MediaQuery.of(context).size.width - 22
                  : 170,
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
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TopicStatisticsPage()),
                    );
                  },
                  child: Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Icon(Icons.toc_outlined, size: 20),
                          ),
                          const SizedBox(width: 25),
                          const Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Topic Name'),
                                SizedBox(height: 5),
                                Text('Completed days ago'),
                                SizedBox(height: 5),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.people_alt_outlined, size: 20),
                                    SizedBox(width: 5),
                                    Text('5 participants'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text('50%',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

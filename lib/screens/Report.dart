import 'package:final_quizlet_english/blocs/community/TopicRanking.dart';
import 'package:final_quizlet_english/blocs/community/TopicRankingBloc.dart';
import 'package:final_quizlet_english/dtos/TopicRankingInfo.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/UserDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'ReportStaticPage.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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

  UserModel? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthService().getCurrentUser().then((value) {
      setState(() {
        user = value;
      });

      context.read<TopicRankingBloc>().add(LoadTopicRankings(user!.id!));
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
      body: (user == null)
          ? const Center(
              child: CircularProgressIndicator(color: Colors.lightGreen),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: BlocBuilder<TopicRankingBloc, TopicRankingState>(
                  builder: (context, state) {
                  print(state);
                  if (state is TopicRankingLoaded) {
                    List<TopicRankingInfoDTO> topics = state.topics;
                    if (topics.isEmpty) {
                      return const Align(
                        alignment: Alignment(0, -0.5),
                        child: Padding(
                          padding: EdgeInsets.only(top: 200.0),
                          child: Text(
                              "You have not participated on any public topic yet"),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: topics.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TopicStatisticsPage(
                                              topicId: topics[index].topicId,
                                              userId: user!.id!,
                                            )),
                                  );
                                },
                                child: Card(
                                  color: Colors.orange[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const Icon(Icons.toc_outlined,
                                              size: 20),
                                        ),
                                        const SizedBox(width: 25),
                                        Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                topics[index].topicName,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 5),
                                              Text((DateFormat('yyyy-MM-dd')
                                                          .format(topics[index]
                                                              .lastPlayed) ==
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              DateTime.now()))
                                                  ? 'Completed on today'
                                                  : (DateFormat('yyyy-MM-dd')
                                                              .format(topics[index]
                                                                  .lastPlayed) ==
                                                          DateFormat('yyyy-MM-dd')
                                                              .format(DateTime.now()
                                                                  .subtract(
                                                                      const Duration(days: 1))))
                                                      ? 'Completed on yesterday'
                                                      : topics[index].lastPlayed.toString()),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: <Widget>[
                                                  const Icon(
                                                      Icons.people_alt_outlined,
                                                      size: 20),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      '${topics[index].participants} participants'),
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  "${topics[index].accuracy.toStringAsFixed(0)}%",
                                                  style: const TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TopicStatisticsPage(
                                                topicId: "", userId: "")),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Icon(Icons.toc_outlined,
                                              size: 20),
                                        ),
                                        const SizedBox(width: 25),
                                        const Expanded(
                                          flex: 8,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Topic Name'),
                                              SizedBox(height: 5),
                                              Text('Completed days ago'),
                                              SizedBox(height: 5),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                      Icons.people_alt_outlined,
                                                      size: 20),
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Text('50%',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ));
                  }
                }),
              ),
            ),
    );
  }
}

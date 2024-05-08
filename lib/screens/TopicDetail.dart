import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/blocs/topic/TopidDetailBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/models/VocabFavourite.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/screens/FolderList.dart';
import 'package:final_quizlet_english/screens/TopicUpdate.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:final_quizlet_english/screens/TopicFlashcard.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TDetailPage extends StatefulWidget {
  TDetailPage({super.key, required this.topicId, required this.userId});

  final String topicId;
  final String userId;

  @override
  State<TDetailPage> createState() => _TDetailPageState();
}

class _TDetailPageState extends State<TDetailPage>
    with SingleTickerProviderStateMixin {
  bool showContent = false;
  int? selectedCardIndex;

  late Stream<Map<String, dynamic>> topicData;

  late TopicInfoDTO _topicInfoDTO;

  late List<VocabularyModel> _vocabsFav;

  late TabController _tabController;

  FlutterTts flutterTts = FlutterTts();

  void textToSpeechEn(String text) async {
    // await flutterTts.setLanguage("en-US");
    // await flutterTts.setLanguage("en-US-x-smttsfemale");
    // await flutterTts.setVolume(0.5);
    // await flutterTts.setSpeechRate(0.5);
    // await flutterTts.setPitch(1);
    // await flutterTts.speak(text);
    List<dynamic> languages = await flutterTts.getLanguages;
    print(languages);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void textToSpeechVi(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  // late UserModel _user;
  @override
  void initState() {
    // topicData = TopicDao().getTopicInfoDTOByTopicIdRealtime(widget.topicId);
    super.initState();

    // AuthService().getCurrentUser().then((user) {
    //   print(user?.id);
    //   _user = user!;

    // });
    context
        .read<TopicDetailBloc>()
        .add(LoadTopic(widget.topicId, widget.userId));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.grey,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Topic'),
                          onTap: () {
                            Navigator.pop(context);
                            //edit topic
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TUpdatePage(
                                        topicInfoDTO: _topicInfoDTO,
                                      )),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete Topic'),
                          onTap: () {
                            //delete r về lại trang library

                            showDialogMessage(
                                context, "Are you sure you want to continue?",
                                () {
                              context
                                  .read<TopicBloc>()
                                  .add(RemoveTopic(widget.topicId));
                              Navigator.pop(context);
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
                          title: const Text('Add to Colection'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FolderListAdd(topicId: widget.topicId)));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.import_export),
                          title: const Text('Export to csv'),
                          onTap: () {},
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocBuilder<TopicDetailBloc, TopicState>(
              builder: (context, state) {
                if (state is TopicDetailLoaded) {
                  _topicInfoDTO = state.topic;
                  _vocabsFav = state.vocabsFav;
                  print(_topicInfoDTO.topic.private);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/images/QLogo.png',
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _topicInfoDTO.topic.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${_topicInfoDTO.termNumbers}  terms'),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.red[100],
                                            ),
                                            //Privacy
                                            child: Text(
                                              (_topicInfoDTO.topic.private!)
                                                  ? "Private"
                                                  : "Public",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            backgroundImage:
                                (_topicInfoDTO.userAvatar != null &&
                                        _topicInfoDTO.userAvatar != "null")
                                    ? CachedNetworkImageProvider(
                                        _topicInfoDTO.userAvatar!)
                                    : const AssetImage("assets/images/user.png")
                                        as ImageProvider<Object>?,
                            radius: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            _topicInfoDTO.authorName,
                            style: TextStyle(color: Colors.grey),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.people),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    'Played by ${_topicInfoDTO.playersCount} users'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Flashcard
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TFlashcardPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[50],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.my_library_books,
                                color: Colors.lightGreen,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Flashcard',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Điền từ
                      ElevatedButton(
                        onPressed: () {
                          //
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[50],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.quiz,
                                color: Colors.lightGreen,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Quiz',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //Làm trắc nghiệm
                      ElevatedButton(
                        onPressed: () {
                          //
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[50],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                color: Colors.lightGreen,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (_vocabsFav.length > 0)
                          ? Container(
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                splashBorderRadius: BorderRadius.circular(
                                  15.0,
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                  color: Colors.lightGreen,
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  const Tab(
                                    text: 'All Vocabs',
                                  ),
                                  Tab(
                                    text:
                                        'Only Favorites (${_vocabsFav.length})',
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Terms",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      (_vocabsFav.length > 0)
                          ? Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _topicInfoDTO.vocabs!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var vocab = _topicInfoDTO.vocabs![index];
                                      var isFav = _vocabsFav.contains(vocab);
                                      return buildCard(
                                          index + 1,
                                          vocab.term,
                                          vocab.definition,
                                          widget.userId,
                                          vocab.id!,
                                          isFav,
                                          _topicInfoDTO.topic.termLanguage,
                                          _topicInfoDTO
                                              .topic.definitionLanguage);
                                    },
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _vocabsFav.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var vocab = _vocabsFav[index];
                                      return buildCard(
                                          index + 1,
                                          vocab.term,
                                          vocab.definition,
                                          widget.userId,
                                          vocab.id!,
                                          true,
                                          _topicInfoDTO.topic.termLanguage,
                                          _topicInfoDTO
                                              .topic.definitionLanguage);
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _topicInfoDTO.vocabs!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var vocab = _topicInfoDTO.vocabs![index];
                                  var isFav = _vocabsFav.contains(vocab);
                                  return buildCard(
                                      index + 1,
                                      vocab.term,
                                      vocab.definition,
                                      widget.userId,
                                      vocab.id!,
                                      isFav,
                                      _topicInfoDTO.topic.termLanguage,
                                      _topicInfoDTO.topic.definitionLanguage);
                                },
                              ),
                            ),
                    ],
                  );
                  //KHONG CHINH SUA CODE TRONG NAY
                  //HIEN THI SKELETON TRONG LUC LOAD DATA
                } else {
                  return Skeletonizer(
                    enabled: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.asset(
                                'assets/images/QLogo.png',
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "123",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text('123'),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.red[100],
                                              ),
                                              //Privacy
                                              child: const Text(
                                                "123",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundImage: null,
                              radius: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.people),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(""),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Flashcard
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TFlashcardPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.my_library_books,
                                  color: Colors.lightGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Flashcard',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //Điền từ
                        ElevatedButton(
                          onPressed: () {
                            //
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.quiz,
                                  color: Colors.lightGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Quiz',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //Làm trắc nghiệm
                        ElevatedButton(
                          onPressed: () {
                            //
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[50],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  color: Colors.lightGreen,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Terms",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return buildCard(
                                  index + 1, "", "", "", "", false, "", "");
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            )));
  }

  Widget buildCard(
      int cardIndex,
      String term,
      String definition,
      String userId,
      String vocabId,
      bool isFav,
      String termLanguage,
      String definitionLanguage) {
    bool isOpen = selectedCardIndex == cardIndex;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        cardIndex.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    term,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (termLanguage == "English") {
                    textToSpeechEn(term);
                  } else {
                    textToSpeechVi(term);
                  }
                },
                icon: const Icon(Icons.volume_up),
              ),
              IconButton(
                onPressed: () {
                  //Thêm vào danh sách fav
                  if (isFav) {
                    context
                        .read<TopicDetailBloc>()
                        .add(RemoveVocabFav(vocabId, userId));
                  } else {
                    VocabFavouriteModel fav = VocabFavouriteModel(
                        topicId: widget.topicId,
                        userId: userId,
                        vocabularyId: vocabId);
                    context.read<TopicDetailBloc>().add(AddVocabFav(fav));
                  }
                  setState(() {
                    isFav = !isFav;
                  });
                },
                icon: (isFav == false)
                    ? const Icon(Icons.star_border_outlined)
                    : const Icon(Icons.star),
              ),
            ],
          ),
          if (isOpen)
            Column(
              children: [
                const Divider(
                  color: Colors.grey,
                  indent: 10,
                  endIndent: 10,
                ),
                // Definition
                Text(
                  definition,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          const Divider(
            color: Colors.grey,
            indent: 10,
            endIndent: 10,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedCardIndex = (isOpen ? null : cardIndex) as int?;
              });
            },
            child: Row(
              children: [
                Text(
                  isOpen ? 'Hide definition' : 'Show definition',
                  style: const TextStyle(color: Colors.lightGreen),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.lightGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

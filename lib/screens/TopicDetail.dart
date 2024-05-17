import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/blocs/topic/TopicDetailBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/dtos/VocabInfo.dart';
import 'package:final_quizlet_english/models/FlashCardSettings.dart';
import 'package:final_quizlet_english/models/QuizSettings.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/TopicPlayedNumber.dart';
import 'package:final_quizlet_english/models/TopicRecentlyAccessed.dart';
import 'package:final_quizlet_english/models/TopicTypeSetting.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/models/VocabFavourite.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/screens/FolderList.dart';
import 'package:final_quizlet_english/screens/TopicQuiz.dart';
import 'package:final_quizlet_english/screens/TopicType.dart';
import 'package:final_quizlet_english/screens/TopicUpdate.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/FlashCardSettingsDao.dart';
import 'package:final_quizlet_english/services/QuizSettingsDao.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/TopicPlayedNumberDao.dart';
import 'package:final_quizlet_english/services/TopicRecentlyAccessedDao.dart';
import 'package:final_quizlet_english/services/TypeSettingsDao.dart';
import 'package:final_quizlet_english/widgets/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:final_quizlet_english/screens/TopicFlashcard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:csv/csv.dart';

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

  List<Map<String, String>> data = [];

  bool isFavChosed = false;

  // List<Map<String, String>> notLearned = [];

  // List<Map<String, String>> studying = [];

  // List<Map<String, String>> mastered = [];

  void textToSpeechEn(String text) async {
    // await flutterTts.setLanguage("en-US");
    // await flutterTts.setLanguage("en-US-x-smttsfemale");
    // await flutterTts.setVolume(0.5);
    // await flutterTts.setSpeechRate(0.5);
    // await flutterTts.setPitch(1);
    // await flutterTts.speak(text);
    // List<dynamic> languages = await flutterTts.getLanguages;
    // print(languages);
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
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
  UserModel? _user;
  @override
  void initState() {
    // topicData = TopicDao().getTopicInfoDTOByTopicIdRealtime(widget.topicId);
    super.initState();

    AuthService().getCurrentUser().then((user) {
      print(user?.id);
      setState(() {
        _user = user!;

        context
            .read<TopicDetailBloc>()
            .add(LoadTopic(widget.topicId, _user!.id!));
        //Cap nhat last accessed
        TopicRecentlyAccessedDao().getTopicRecentlyAccessedByUserId(_user!.id!).then((value) {
          print(value);
          if(value["status"]){
            TopicRecentlyAccessed topicAcccessed = value["data"];
            for (var element in topicAcccessed.topicIds) {
              if(widget.topicId == element){
                topicAcccessed.topicIds.remove(element);
                break;
              }
            }
            topicAcccessed.topicIds.add(widget.topicId);
            TopicRecentlyAccessedDao().updatetopicAccessed(topicAcccessed).then((value){
              print(value);
            });
          }else{
            List<String> topicIds = [];
            topicIds.add(widget.topicId);
            TopicRecentlyAccessed topicRecentlyAccessed = TopicRecentlyAccessed(userId: _user!.id!, topicIds: topicIds);
            TopicRecentlyAccessedDao().addTopicRecentlyAccessed(topicRecentlyAccessed).then((value) {
              print(value);
            });
          }
        });
      });
    });
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> checkPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
    ].request();

    print(statuses);
    if (statuses[Permission.manageExternalStorage] !=
        PermissionStatus.granted) {
      print("Permission denied.");
      return false;
    }

    return true;
  }

  Future<void> _generateCsvFile(List<Map<String, String>> data) async {
    var isGranted = false;
    if (Platform.isAndroid) {}
    // if(!isGranted){
    //   return;
    // }
    List<List<String>> rows = [
      ["English", "Vietnamese"]
    ];

    for (var associate in data) {
      rows.add([
        associate["English"]!,
        associate["Vietnamese"]!,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    File file = File("");

    Directory? directory;
    if (Platform.isAndroid) {
      if (await checkPermission()) {
        // directory = Directory('/storage/emulated/0/Download');
        directory = await getExternalStorageDirectory();
        // String newPath = "";
        // List<String> folders = directory!.path.split("/");
        // for (var i = 1; i < folders.length; i++) {
        //   String folder = folders[i];
        //   if (folder != "Android") {
        //     newPath += "/" + folder;
        //   } else {
        //     break;
        //   }
        // }
        // newPath = newPath + "/FinalQuizzUP";
        // directory = Directory(newPath);
        print(directory!.path);
        file = File('${directory.path}/topic_${DateTime.now().toString()}.csv');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Permissions are not granted!")));
        return;
      }
    } else if (Platform.isWindows) {
      directory = await getDownloadsDirectory();

      file = File('$directory\topic_${DateTime.now().toString()}.csv');
    }
    if(!await directory!.exists()){
      await directory.create(recursive: true);
    }

    if (directory == null) {
      print("Failed to access storage directory.");
      return;
    }
    print(directory.path);
    if(await directory.exists()){
      try {
      await file.writeAsString(csv);
      print("File exported successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("File exported successfully!: " + directory.path)));
    } catch (e) {
      print("Failed to export file: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to export file: $e")));
    }
    }
    else{
      print("Cant create directory");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to export: cant create directory")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_user != null)
        ? Scaffold(
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
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              (widget.userId == _user!.id!)
                                  ? ListTile(
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
                                    )
                                  : Container(),
                              (widget.userId == _user!.id!)
                                  ? ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete Topic'),
                                      onTap: () {
                                        //delete r về lại trang library

                                        showDialogMessage(context,
                                            "Are you sure you want to continue?",
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
                                    )
                                  : Container(),
                              ListTile(
                                leading: const Icon(Icons.folder_open),
                                title: const Text('Add to folder'),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FolderListAdd(
                                              topicId: widget.topicId)));
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.import_export),
                                title: const Text('Export to csv'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  if (await checkPermission()) {
                                    await _generateCsvFile(data);
                                  }
                                  //
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ]),
            body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocBuilder<TopicDetailBloc, TopicState>(
                  builder: (context, state) {
                    if (state is TopicDetailLoaded) {
                      _topicInfoDTO = state.topic;
                      List<VocabularyModel> notLearned = [];
                      List<VocabularyModel> studying = [];
                      List<VocabularyModel> knew = [];
                      List<VocabularyModel> mastered = [];
                      for (var element in _topicInfoDTO.vocabs!) {
                        data.add({
                          "English": element.vocab.term,
                          "Vietnamese": element.vocab.definition
                        });
                        if (element.vocabStatus.status == 0) {
                          notLearned.add(element.vocab);
                        } else if (element.vocabStatus.status == 1) {
                          studying.add(element.vocab);
                        } else if (element.vocabStatus.status == 2) {
                          knew.add(element.vocab);
                        } else {
                          mastered.add(element.vocab);
                        }
                      }
                      if (widget.userId == _user!.id!) {
                        TopicModel topicLastAccessed = state.topic.topic;
                        topicLastAccessed.lastAccessed = DateTime.now();
                        TopicDao().updateTopic(topicLastAccessed);
                        context
                            .read<TopicBloc>()
                            .add(LoadTopics(widget.userId));
                      }
                      List<VocabInfoDTO> favoriteVocabs = [];
                      List<VocabInfoDTO> vocabsTemp = [];
                      _vocabsFav = state.vocabsFav;
                      if(_topicInfoDTO.vocabs!=null){
                        for (var vocabDTO in _topicInfoDTO.vocabs!) {
                          vocabsTemp.add(vocabDTO);
                          if(_vocabsFav.indexWhere((element) => element.id! == vocabDTO.vocab.id!)!=-1){
                            favoriteVocabs.add(vocabDTO);
                          }
                        }
                      }
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            '${_topicInfoDTO.termNumbers}  terms'),
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
                                                child: Text(
                                                  (_topicInfoDTO.topic.private!)
                                                      ? "Private"
                                                      : "Public",
                                                  style: const TextStyle(
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
                              const SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundImage: (_topicInfoDTO.userAvatar !=
                                            null &&
                                        _topicInfoDTO.userAvatar != "null")
                                    ? CachedNetworkImageProvider(
                                        _topicInfoDTO.userAvatar!)
                                    : const AssetImage("assets/images/user.png")
                                        as ImageProvider<Object>?,
                                radius: 10,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _topicInfoDTO.authorName,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.people),
                                    const SizedBox(
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
                            onPressed: () async {
                              //
                              int index = _tabController.index;
                              if(index == 1){//favorite mode
                                if(_vocabsFav.length != _topicInfoDTO.termNumbers){
                                  _topicInfoDTO.vocabs = favoriteVocabs;
                                }
                              }
                              else{
                                _topicInfoDTO.vocabs = vocabsTemp;
                              }
                              //tạo topicplaycount nếu chưa tồn tại
                              //
                              var topicPlayCount = await TopicPlayedNumberDao()
                                  .getTopicPlayedNumberByUserIdAndTopicId(
                                      _user!.id!, _topicInfoDTO.topic.id!);
                              if (topicPlayCount["status"]) {
                                //nếu tồn tại + 1 lần chơi
                                TopicPlayedNumber topicPlay =
                                    topicPlayCount["data"];
                                topicPlay.times = topicPlay.times + 1; //ngao'
                                print(topicPlay.times);
                                var res = await TopicPlayedNumberDao()
                                    .updateTopicPlayedNumber(topicPlay);
                                print(res);
                              } else {
                                //tạo mới
                                TopicPlayedNumber topicPlayedNumber =
                                    TopicPlayedNumber(
                                        topicId: _topicInfoDTO.topic.id!,
                                        userId: _user!.id!,
                                        times: 1);
                                var res = await TopicPlayedNumberDao()
                                    .addTopicPlayedNumber(topicPlayedNumber);
                                print(res);
                              }
                              var result = await FlashCardSettingsDao()
                                  .getFlashCardSettingsByUserId(_user!.id!);
                              print(result);
                              if (result["status"]) {
                                FlashCardSettings fSettings =
                                    FlashCardSettings.fromJson(result["data"]);
                                     // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TFlashcardPage(
                                            topic: _topicInfoDTO,
                                            settings: fSettings,
                                            userId: _user!.id!,
                                          )),
                                );
                              } else {
                                 // ignore: use_build_context_synchronously
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TFlashcardPage(
                                            topic: _topicInfoDTO,
                                            userId: _user!.id!)));
                              }
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
                            onPressed: () async {
                              int index = _tabController.index;
                              if(index == 1){//favorite mode
                                if(_vocabsFav.length != _topicInfoDTO.termNumbers){
                                  _topicInfoDTO.vocabs = favoriteVocabs;
                                }
                              }
                              else{
                                _topicInfoDTO.vocabs = vocabsTemp;
                              }
                              if(_topicInfoDTO.vocabs!.length>=4){
                                //tạo topicplaycount nếu chưa tồn tại
                              //
                                var topicPlayCount = await TopicPlayedNumberDao()
                                    .getTopicPlayedNumberByUserIdAndTopicId(
                                        _user!.id!, _topicInfoDTO.topic.id!);
                                if (topicPlayCount["status"]) {
                                  //nếu tồn tại + 1 lần chơi
                                  TopicPlayedNumber topicPlay =
                                      topicPlayCount["data"];
                                  var timesAdd = topicPlay.times + 1;
                                  topicPlay.times = timesAdd;

                                  var res = await TopicPlayedNumberDao()
                                      .updateTopicPlayedNumber(topicPlay);
                                  print(res);
                                } else {
                                  //tạo mới
                                  TopicPlayedNumber topicPlayedNumber =
                                      TopicPlayedNumber(
                                          topicId: _topicInfoDTO.topic.id!,
                                          userId: _user!.id!,
                                          times: 1);
                                  var res = await TopicPlayedNumberDao()
                                      .addTopicPlayedNumber(topicPlayedNumber);
                                  print(res);
                                }
                                var result = await QuizSettingsDao()
                                    .getQuizSettingsByUserId(_user!.id!);
                                print(result);
                                if (result["status"]) {
                                  QuizSettings qSettings =
                                      QuizSettings.fromJson(result["data"]);
                                       // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TQuizPage(
                                                  topicDTO: _topicInfoDTO,
                                                  userId: _user!.id!,
                                                  qSettings: qSettings,
                                                )),
                                      );
                                }
                                else{
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TQuizPage(
                                                  topicDTO: _topicInfoDTO,
                                                  userId: _user!.id!,
                                                )),
                                      );
                                }
                              }
                              else{
                                showScaffoldMessage(context, "Quiz requires at least 4 terms to play.");
                              }
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
                            onPressed: () async {
                              int index = _tabController.index;
                              if(index == 1){//favorite mode
                                if(_vocabsFav.length != _topicInfoDTO.termNumbers){
                                  _topicInfoDTO.vocabs = favoriteVocabs;
                                }
                              }
                              else{
                                _topicInfoDTO.vocabs = vocabsTemp;
                              }
                              //tạo topicplaycount nếu chưa tồn tại
                              //
                              var topicPlayCount = await TopicPlayedNumberDao()
                                  .getTopicPlayedNumberByUserIdAndTopicId(
                                      _user!.id!, _topicInfoDTO.topic.id!);
                              if (topicPlayCount["status"]) {
                                //nếu tồn tại + 1 lần chơi
                                TopicPlayedNumber topicPlay =
                                    topicPlayCount["data"];
                                topicPlay.times = topicPlay.times + 1;
                                print(topicPlay.times);
                                var res = await TopicPlayedNumberDao()
                                    .updateTopicPlayedNumber(topicPlay);
                                print(res);
                              } else {
                                //tạo mới
                                TopicPlayedNumber topicPlayedNumber =
                                    TopicPlayedNumber(
                                        topicId: _topicInfoDTO.topic.id!,
                                        userId: _user!.id!,
                                        times: 1);
                                var res = await TopicPlayedNumberDao()
                                    .addTopicPlayedNumber(topicPlayedNumber);
                                print(res);
                              }
                              var result = await TypeSettingsDao()
                                  .getTypeSettingsByUserId(
                                      _topicInfoDTO.topic.userId);
                              if (result["status"]) {
                                TopicTypeSettings tSettings =
                                    TopicTypeSettings.fromJson(result["data"]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TypingPractice(
                                            topic: _topicInfoDTO,
                                            tSettings: tSettings)));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TypingPractice(
                                            topic: _topicInfoDTO)));
                              }
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
                          (_vocabsFav.isNotEmpty)
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
                          (_vocabsFav.isNotEmpty)
                              ? Expanded(
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            (notLearned.isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Not learned",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            notLearned.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var vocab =
                                                              notLearned[index];
                                                          var isFav = _vocabsFav
                                                              .contains(vocab);
                                                          return buildCard(
                                                              index + 1,
                                                              vocab.term,
                                                              vocab.definition,
                                                              _user!.id!,
                                                              vocab.id!,
                                                              isFav,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .termLanguage,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .definitionLanguage);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            (studying.isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Learning",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            studying.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var vocab =
                                                              studying[index];
                                                          var isFav = _vocabsFav
                                                              .contains(vocab);
                                                          return buildCard(
                                                              index + 1,
                                                              vocab.term,
                                                              vocab.definition,
                                                              _user!.id!,
                                                              vocab.id!,
                                                              isFav,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .termLanguage,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .definitionLanguage);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            (knew.isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Learned",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount: knew.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var vocab =
                                                              knew[index];
                                                          var isFav = _vocabsFav
                                                              .contains(vocab);
                                                          return buildCard(
                                                              index + 1,
                                                              vocab.term,
                                                              vocab.definition,
                                                              _user!.id!,
                                                              vocab.id!,
                                                              isFav,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .termLanguage,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .definitionLanguage);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                            (mastered.isNotEmpty)
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Mastered",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      ListView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            mastered.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          var vocab =
                                                              mastered[index];
                                                          var isFav = _vocabsFav
                                                              .contains(vocab);
                                                          return buildCard(
                                                              index + 1,
                                                              vocab.term,
                                                              vocab.definition,
                                                              _user!.id!,
                                                              vocab.id!,
                                                              isFav,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .termLanguage,
                                                              _topicInfoDTO
                                                                  .topic
                                                                  .definitionLanguage);
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  ),
                                          ],
                                        ),
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
                                              _user!.id!,
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
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        (notLearned.isNotEmpty)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Not learned",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        notLearned.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var vocab =
                                                          notLearned[index];
                                                      var isFav = _vocabsFav
                                                          .contains(vocab);
                                                      return buildCard(
                                                          index + 1,
                                                          vocab.term,
                                                          vocab.definition,
                                                          _user!.id!,
                                                          vocab.id!,
                                                          isFav,
                                                          _topicInfoDTO.topic
                                                              .termLanguage,
                                                          _topicInfoDTO.topic
                                                              .definitionLanguage);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                        (studying.isNotEmpty)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Learning",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: studying.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var vocab =
                                                          studying[index];
                                                      var isFav = _vocabsFav
                                                          .contains(vocab);
                                                      return buildCard(
                                                          index + 1,
                                                          vocab.term,
                                                          vocab.definition,
                                                          _user!.id!,
                                                          vocab.id!,
                                                          isFav,
                                                          _topicInfoDTO.topic
                                                              .termLanguage,
                                                          _topicInfoDTO.topic
                                                              .definitionLanguage);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                        (knew.isNotEmpty)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Knew",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: knew.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var vocab = knew[index];
                                                      var isFav = _vocabsFav
                                                          .contains(vocab);
                                                      return buildCard(
                                                          index + 1,
                                                          vocab.term,
                                                          vocab.definition,
                                                          _user!.id!,
                                                          vocab.id!,
                                                          isFav,
                                                          _topicInfoDTO.topic
                                                              .termLanguage,
                                                          _topicInfoDTO.topic
                                                              .definitionLanguage);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                        (mastered.isNotEmpty)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Mastered",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: mastered.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var vocab =
                                                          mastered[index];
                                                      var isFav = _vocabsFav
                                                          .contains(vocab);
                                                      return buildCard(
                                                          index + 1,
                                                          vocab.term,
                                                          vocab.definition,
                                                          _user!.id!,
                                                          vocab.id!,
                                                          isFav,
                                                          _topicInfoDTO.topic
                                                              .termLanguage,
                                                          _topicInfoDTO.topic
                                                              .definitionLanguage);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                      ],
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
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
                                  "123",
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
                                      Text("123"),
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
                              onPressed: () {},
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
                              onPressed: () {},
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
                )),
          )
        : const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: Colors.lightGreen,
            )),
          );
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

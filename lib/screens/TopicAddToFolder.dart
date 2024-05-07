import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/blocs/folder/FolderBloc.dart';
import 'package:final_quizlet_english/blocs/folder/FolderDetailBloc.dart';
import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/FolderDetail.dart';
import 'package:final_quizlet_english/screens/Library.dart';
import 'package:final_quizlet_english/services/Auth.dart';
import 'package:final_quizlet_english/services/FolderDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AddTopicToFolder extends StatefulWidget {
  const AddTopicToFolder({super.key, required this.folderId});

  final String folderId;

  @override
  State<AddTopicToFolder> createState() => _AddTopicToFolderState();
}

class _AddTopicToFolderState extends State<AddTopicToFolder>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late UserModel _user;

  late FolderModel folder;

  List<String> topicsClicked = [];

  @override
  void initState() {
    super.initState();

    AuthService().getCurrentUser().then((user) {
      print(user?.id);
      _user = user!;

      context.read<TopicBloc>().add(LoadTopics(_user.id!));
    });

    FolderDao().getFolderById(widget.folderId).then((result) {
      if(result["status"]){
        folder = FolderModel.fromJson(result["data"]);
        if(folder.topicId != null){
          topicsClicked = folder.topicId!;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Topic"), centerTitle: true, actions: [
          TextButton(
            child: const Text("Done"),
            onPressed: () async {
              if(topicsClicked.isNotEmpty){
                folder.topicId = topicsClicked;
                  Navigator.pop(context);
                  UpdateFolder updateFolder = UpdateFolder(folder);
                  context.read<FolderBloc>().add(updateFolder);
                  context.read<FolderBloc>().add(LoadFolders(_user.id!));
                  context.read<FolderDetailBloc>().add(LoadFolder(folder.id!));
              }
            },
          )
        ]),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                BlocBuilder<TopicBloc, TopicState>(
                  builder: (context, state) {
                    print(state);
                    if (state is TopicLoading) {
                      return Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (BuildContext context, int index) {
                            return const TopicInfo(
                              topicId: "",
                              title: "",
                              termNumbers: 0,
                              authorName: "",
                              playersCount: 0,
                              userAvatar: null,
                              userId: "",
                            );
                          },
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
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                String topicId = data[index].topic.id!;

                                setState(() {
                                  if (!topicsClicked.contains(topicId)) {
                                    topicsClicked.add(topicId);
                                  } else {
                                    topicsClicked.removeWhere((item) => item == topicId);
                                  }
                                });

                                print(topicsClicked);
                              },
                              child: Card(
                                shape: (topicsClicked.contains(data[index].topic.id!)) ? 
                                const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        side: BorderSide(
                                            color: Colors.lightGreen))
                                    : null,
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
                                                axisLineStyle:
                                                    const AxisLineStyle(
                                                  thickness: 0.2,
                                                  cornerStyle:
                                                      CornerStyle.bothCurve,
                                                  color: Color.fromARGB(
                                                      30, 0, 169, 181),
                                                  thicknessUnit:
                                                      GaugeSizeUnit.factor,
                                                ),
                                                pointers: <GaugePointer>[
                                                  RangePointer(
                                                    value: 0,
                                                    cornerStyle:
                                                        CornerStyle.bothCurve,
                                                    width: 0.2,
                                                    sizeUnit:
                                                        GaugeSizeUnit.factor,
                                                    color: Colors.lightGreen,
                                                  )
                                                ],
                                                annotations: <GaugeAnnotation>[
                                                  GaugeAnnotation(
                                                    positionFactor: 0.1,
                                                    angle: 90,
                                                    widget: Text(
                                                      '${0.toStringAsFixed(0)}%',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.orange),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                          data[index].topic.name), //tên Topics
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                  '${data[index].termNumbers} terms'), // size topics
                                              const Icon(
                                                  Icons.play_arrow_outlined),
                                              Text(
                                                  '${data[index].playersCount} players'), // size players],)
                                            ],
                                          ),
                                          Divider(),
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: (data[index]
                                                            .userAvatar) !=
                                                        null
                                                    ? CachedNetworkImageProvider(
                                                        data[index].userAvatar!)
                                                    : const AssetImage(
                                                            'assets/images/user.png')
                                                        as ImageProvider<
                                                            Object>,
                                                radius: 10,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                data[index].authorName,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10),
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
              ],
            ),
          ),
        ));
  }
}

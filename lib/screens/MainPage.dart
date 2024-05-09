import 'package:flutter/material.dart';
import 'HomePage.dart' as _homeTab;
import 'Report.dart' as _reportTab;
import 'Library.dart' as _libraryTab;
import 'Profile.dart' as _profileTab;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Color> _iconColors = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  //Page controller
  PageController navPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: navPage,
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            _homeTab.HomePage(),
            _reportTab.ReportPage(),
            _libraryTab.LibraryPage(),
            _profileTab.ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        color: Colors.lightGreen,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () {
                navPage.jumpToPage(0);
                _updateIconColor(0);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _iconColors[0] == Colors.orange.shade300
                          ? Colors.orange.shade100
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.home_outlined,
                      size: 20,
                      color: _iconColors[0],
                    ),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                        color: _iconColors[0],
                        fontWeight: _iconColors[0] == Colors.orange.shade300
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: GestureDetector(
                onTap: () {
                  navPage.jumpToPage(1);
                  _updateIconColor(1);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _iconColors[1] == Colors.orange.shade300
                            ? Colors.orange.shade100
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.analytics_outlined,
                        size: 20,
                        color: _iconColors[1],
                      ),
                    ),
                    Text(
                      "Reports",
                      style: TextStyle(
                          color: _iconColors[1],
                          fontWeight: _iconColors[1] == Colors.orange.shade300
                              ? FontWeight.bold
                              : FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: GestureDetector(
                onTap: () {
                  navPage.jumpToPage(2);
                  _updateIconColor(2);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _iconColors[2] == Colors.orange.shade300
                            ? Colors.orange.shade100
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.quiz_outlined,
                        size: 20,
                        color: _iconColors[2],
                      ),
                    ),
                    Text(
                      "Library",
                      style: TextStyle(
                          color: _iconColors[2],
                          fontWeight: _iconColors[2] == Colors.orange.shade300
                              ? FontWeight.bold
                              : FontWeight.normal),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                navPage.jumpToPage(3);
                _updateIconColor(3);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _iconColors[3] == Colors.orange.shade300
                          ? Colors.orange.shade100
                          : Colors.transparent,
                    ),
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.settings_outlined,
                      size: 22,
                      color: _iconColors[3],
                    ),
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                        color: _iconColors[3],
                        fontWeight: _iconColors[3] == Colors.orange.shade300
                            ? FontWeight.bold
                            : FontWeight.normal),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
        //mini: true,
      ),
    );
  }

  void _updateIconColor(int index) {
    setState(() {
      for (int i = 0; i < _iconColors.length; i++) {
        _iconColors[i] = Colors.white;
      }
      _iconColors[index] = Colors.orange.shade300;
    });
  }
}

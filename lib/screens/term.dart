import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stack Demo',
      home: new StackDemo(),
    );
  }
}

class StackDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile"),
      //   backgroundColor: Colors.orange[200],
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout))],
      // ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: 300.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.orange.shade800,
                      Colors.orange.shade600,
                      Colors.orange.shade300
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 55),
                      ListTile(
                        title: Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'haizzzzz@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Phone number',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '0123456789',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("************"),
                            TextButton(
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            top: 70.0,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.png"),
              radius: 60,
            ),
          ),
          Positioned(
            top: 70.0,
            right: MediaQuery.of(context).size.width / 2 - 80,
            child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    shape: CircleBorder(), backgroundColor: Colors.white),
                child: const Icon(
                  Icons.edit,
                  color: Colors.lightGreen,
                )),
          ),
          const Positioned(
            top: 200.0,
            child: Text(
              "Phạm Nhật Quỳnh",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Positioned(
            top: 255.0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "TOPICS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700),
                      ),
                      Text(
                        "520",
                        style: TextStyle(
                            fontSize: 20, color: Colors.orange.shade700),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "FOLDERS",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700),
                      ),
                      Text(
                        "520",
                        style: TextStyle(
                            fontSize: 20, color: Colors.orange.shade700),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "ATTEMPT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700),
                      ),
                      Text(
                        "520",
                        style: TextStyle(
                            fontSize: 20, color: Colors.orange.shade700),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

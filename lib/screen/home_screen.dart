// ignore_for_file: deprecated_member_use
import 'package:chat/auth/api.dart';
import 'package:chat/model/chat_user.dart';
import 'package:chat/screen/chat/chat_screen_card.dart';
import 'package:chat/screen/view/profile_screen.dart';
import 'package:chat/widget/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<ChatUser> _list = [];

  List<ChatUser> searchList = [];

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _initUser();

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        APIs().updateActiveStatus(true);
      }
      if (message.toString().contains('pause')) {
        APIs().updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  Future<void> _initUser() async {
    await APIs().getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            isSearching = !isSearching;
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          drawer: CustomDrawer(
            onTapProfile: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: APIs.me),
                ),
              );
            },
          ),
          appBar: AppBar(
            shadowColor: Theme.of(context).colorScheme.secondary,
            elevation: 5,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: isSearching
                ? TextField(
                    autofocus: true,
                    onChanged: (val) {
                      searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase())) {
                          searchList.add(i);
                        }
                        setState(() {
                          searchList;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                  )
                : const Text('C H A T'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: isSearching
                    ? const Icon(Icons.close)
                    : const Icon(
                        Icons.search,
                        size: 35,
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xff0066FF),
            child: const Icon(Icons.add),
          ),
          body: FutureBuilder(
            future: APIs().getSelfInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              } else {
                return StreamBuilder(
                  stream: APIs().getAllUser(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          final data = snapshot.data?.docs;
                          _list = data!
                              .map((e) => ChatUser.fromJson(e.data()))
                              .toList();

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: isSearching
                                  ? searchList.length
                                  : _list.length,
                              itemBuilder: (context, index) {
                                return ChatScreenCard(
                                  user: isSearching
                                      ? searchList[index]
                                      : _list[index],
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                'NO CONNECTION FOUND!',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          }
                        } else {
                          return Center(
                            child: Text(
                              'No data available',
                              style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          );
                        }
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

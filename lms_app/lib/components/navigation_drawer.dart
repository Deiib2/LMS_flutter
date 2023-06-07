import 'package:flutter/material.dart';
import 'package:lms_app/auth_provider.dart';
import 'package:lms_app/create_item_screen.dart';
import 'package:lms_app/create_user_screen.dart';
import 'package:lms_app/extreq_screen.dart';
import 'package:lms_app/lend.dart';
import 'package:lms_app/my_items_screen.dart';
import 'package:provider/provider.dart';

import '../explore_screen.dart';
import '../login_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: buildMenuItems(context, authProvider),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Divider(
                color: Colors.grey[500],
                endIndent: 16,
              ),
              (authProvider.isLoggedIn()
                  ? ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () async {
                        print(authProvider.getUserEmail());
                        print(authProvider.getJwtToken());
                        await authProvider.useLogout();
                        print(authProvider.getUserEmail());
                        print(authProvider.getJwtToken());
                        print('Is logged in: ${authProvider.isLoggedIn()}');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                    )
                  : ListTile(
                      leading: const Icon(Icons.login),
                      title: const Text('Login'),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                      },
                    ))
            ],
          )
        ],
      ),
    ));
  }

  Widget buildMenuItems(BuildContext context, authProvider) =>
      SingleChildScrollView(
          child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Explore'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ExploreScreen(),
              ));
            },
          ),
          (authProvider.isLoggedIn() &&
                  authProvider.getUserType() == 'librarian')
              ? ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Create Item'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const CreateItem(),
                    ));
                  },
                )
              : const SizedBox(
                  height: 0.0,
                ),
          (authProvider.isLoggedIn() &&
                  authProvider.getUserType() == 'librarian')
              ? ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Register User'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const CreateUserScreen(),
                    ));
                  },
                )
              : const SizedBox(
                  height: 0.0,
                ),
          (authProvider.isLoggedIn() &&
                  authProvider.getUserType() == 'librarian')
              ? ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('Lend'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LendScreen(),
                    ));
                  },
                )
              : const SizedBox(
                  height: 0.0,
                ),
          (authProvider.isLoggedIn() &&
                  authProvider.getUserType() == 'librarian')
              ? ListTile(
                  leading: const Icon(Icons.request_page),
                  title: const Text('Extension Requests'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const ExtReqScreen(),
                    ));
                  },
                )
              : const SizedBox(
                  height: 0.0,
                ),
          (authProvider.isLoggedIn() && authProvider.getUserType() == 'reader')
              ? ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: const Text('My Items'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MyItemsScreen(),
                    ));
                  },
                )
              : const SizedBox(
                  height: 0.0,
                ),
        ],
      ));
}

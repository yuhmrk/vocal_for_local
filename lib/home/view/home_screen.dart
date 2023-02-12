import 'package:flutter/material.dart';

import 'banner_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome", style: Theme.of(context).textTheme.headline2),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.250,
              // color: Colors.red,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        "assets/images/profile_pic.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "John",
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                  ),
                  Text(
                    "John@gmaill.com",
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                ListTile(
                  leading: Icon(Icons.gavel),
                  title: Text("Terms & conditions"),
                ),
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text("Privacy policy"),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About us"),
                )
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: const [
          BannerCrousel(),
        ],
      ),
    );
  }
}

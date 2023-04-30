import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal_for_local/terms_and_conditions/view/terms_and_conditions.dart';
import 'package:vocal_for_local/videos/view/videos_list_screen.dart';

Drawer customDrawer(BuildContext context) {
  return Drawer(
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
                  child: CachedNetworkImage(
                    imageUrl: FirebaseAuth.instance.currentUser?.photoURL ?? "",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      FirebaseAuth.instance.currentUser?.email ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2?.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const VideosListScreen(),
                ));
              },
              leading: const Icon(Icons.video_collection),
              title: const Text("Videos"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TermsAndCondition(),
                ));
              },
              leading: const Icon(Icons.gavel),
              title: const Text("Terms & conditions"),
            ),
            const ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text("Privacy policy"),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text("About us"),
            )
          ],
        )
      ],
    ),
  );
}

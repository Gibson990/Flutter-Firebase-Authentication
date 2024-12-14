import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_on_flutter/guest_book.dart';

import 'package:provider/provider.dart';

import 'app_state.dart';
import 'authentication.dart';
import 'widget.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(style: TextStyle(color: Colors.white), 'our wedding'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'wedding.png',
            height: 400,
            width: 400,
          ),
          const SizedBox(
            height: 10,
          ),
          const IconText(icon: Icons.calendar_today, text: 'Jan 1'),
          const SizedBox(
            height: 10,
          ),
          const IconText(
              icon: Icons.location_city_outlined, text: 'san francisco'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                  // FirebaseApp.instance.appState.signOut();
                }),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text('we are getting married join Us!'),

// constumer widget for guest book
          Consumer<ApplicationState>(
            builder: (context, appState, _) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (appState.loggedIn) ...[
                const Text('Message'),
                GuestBook(
                  addMessage: (message) =>
                      appState.addMessageToGuestBook(message),
                ),
              ]
            ]),
          )
        ]),
      ),
    );
  }
}

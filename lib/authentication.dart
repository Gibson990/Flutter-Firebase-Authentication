import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({super.key, required this.loggedIn, required this.signOut});

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.indigo),
              ),
              onPressed: () {
                !loggedIn ? context.go('/sign-in') : signOut();
              },
              //change the text of the btn deppend on if they are loing in or not
              child: !loggedIn
                  ? const Text(style: TextStyle(color: Colors.white), 'RSVP')
                  : const Text(style: TextStyle(color: Colors.white), 'logOut'),
            ),
          ),
          Visibility(
            visible: loggedIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.indigo),
                  ),
                  onPressed: () {
                    context.go('/profile');
                  },
                  child: const Text(
                      style: TextStyle(color: Colors.white), 'Profile')),
            ),
          )
        ],
      ),
    );
  }
}

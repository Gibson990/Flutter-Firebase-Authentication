import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

import 'package:firebase_on_flutter/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: ((context, child) => const MyApp()),
    ),
  );
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction((context, email) {
                  Navigator.of(context).pushNamed(
                    '/forgot-password',
                    arguments: {'email': email},
                  );
                }),
                AuthStateChangeAction<SignedIn>((context, state) async {
                  final user = state.user;
                  if (user != null) {
                    if (user.emailVerified) {
                      context.go('/profile');
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Please verify your email before continuing'),
                            action: SnackBarAction(
                              label: 'Resend',
                              onPressed: () async {
                                try {
                                  await user.sendEmailVerification();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Verification email sent')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Error sending verification email')),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      });
                    }
                  }
                }),
              ],
            );
          },
        ),
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) {
            final arguments = state.extra! as Map;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent,
        hintColor: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

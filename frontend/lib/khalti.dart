import 'package:flutter/material.dart';
// import 'package:khalti_example/homepage.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import 'khalti2.dart';

class Khalti extends StatelessWidget {
  const Khalti({super.key});

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_19908edd96ba473297852ed745f2f615",
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          title: 'Khalti Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Khalti2(),
          navigatorKey: navKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    );
  }
}

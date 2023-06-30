import 'package:flutter/material.dart';
import 'package:hotel_booking/khalti/khaltiPage.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class Khalti extends StatefulWidget {
  const Khalti({super.key});

  @override
  State<Khalti> createState() => _KhaltiState();
}

class _KhaltiState extends State<Khalti> {
  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_081bd10255fa4631bd66953ed659a9c9",
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          title: 'Khalti Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: KhaltiPage(),
          navigatorKey: navKey,
          localizationsDelegates: [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    );
  }
}

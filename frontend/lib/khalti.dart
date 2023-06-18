import 'package:flutter/material.dart';
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
          navigatorKey: navKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Khalti Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 39, 92, 216),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              title: const Text(
                "Khalti Payment",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: KhaltiPage(),
          ),
        );
      },
    );
  }
}

class KhaltiPage extends StatefulWidget {
  const KhaltiPage({super.key});

  @override
  State<KhaltiPage> createState() => _KhaltiPageState();
}

class _KhaltiPageState extends State<KhaltiPage> {
  String referenceId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Confirm! you want to pay?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 23,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                backgroundColor: Color.fromARGB(255, 87, 44, 138),
              ),
              onPressed: () {
                payWithKhaltiInApp();
              },
              child: const Text(
                "Pay with Khalti",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(referenceId)
          ],
        ),
      ),
    );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 100000, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
        PaymentPreference.eBanking,
        PaymentPreference.mobileBanking,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          actions: [
            SimpleDialogOption(
              child: const Text('OK'),
              onPressed: () {
                setState(
                  () {
                    referenceId = success.idx;
                  },
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
  }
}

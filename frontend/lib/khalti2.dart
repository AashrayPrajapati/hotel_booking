import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class Khalti2 extends StatefulWidget {
  const Khalti2({super.key});

  @override
  State<Khalti2> createState() => _Khalti2State();
}

class _Khalti2State extends State<Khalti2> {
  String referenceId = "";
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
          home: Scaffold(
            appBar: AppBar(
              elevation: 3,
              backgroundColor: Color.fromARGB(255, 39, 92, 216),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
                //replace with our own icon data.
              ),
              title: Text(
                'Khalti Payment',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [payWithKhaltiInApp()],
              ),
            ),
          ),
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

    // print(
    //     '99999999999999999999999999999999999999999999999999999999999999999999999999999999999');

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text("Khalti Payment"),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [payWithKhaltiInApp()],
    //     ),
    //   ),
    // );
  }

  payWithKhaltiInApp() {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000, //in paisa
        productIdentity: 'Product Id',
        productName: 'Product Name',
        mobileReadOnly: false,
      ),
      preferences: [
        PaymentPreference.khalti,
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
                  setState(() {
                    referenceId = success.idx;
                  });

                  Navigator.pop(context);
                })
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

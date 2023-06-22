import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/config.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class KhaltiPage extends StatefulWidget {
  const KhaltiPage({super.key});

  @override
  State<KhaltiPage> createState() => _KhaltiPageState();
}

class Detail {
  final String userId;
  final String hotelId;
  final String roomId;
  final String roomName;
  final String checkInDate;
  final String checkOutDate;
  final String noOfGuests;
  final int totalPrice;
  final String paymentStatus;

  Detail(
    this.userId,
    this.hotelId,
    this.roomId,
    this.roomName,
    this.checkInDate,
    this.checkOutDate,
    this.noOfGuests,
    this.totalPrice,
    this.paymentStatus,
  );
}

Future<Detail> getDetails(
  String userId,
  String hotelId,
  String roomId,
  String roomName,
  String checkInDate,
  String checkOutDate,
  String noOfGuests,
  int totalPrice,
) async {
  try {
    print(userId);
    print(hotelId);
    print(roomId);
    print(roomName);
    print(checkInDate);
    print(checkOutDate);
    print(noOfGuests);
    print(totalPrice);

    final Dio _dio = Dio();

    var regBody = {
      "user": userId,
      "hotel": hotelId,
      "room": roomId,
      "checkInDate": checkInDate,
      "checkOutDate": checkOutDate,
      "guests": int.parse(noOfGuests),
      "totalPrice": totalPrice,
      "paymentStatus": "Paid"
    };
    print(regBody);

    final response = await _dio.post(
      '$apiUrl/bookRoom/book',
      options: Options(headers: {"Content-Type": "application/json"}),
      data: regBody,
    );

    if (response.statusCode == 200) {
      print('Booking Successful');
    } else {
      print('Booking Failed');
    }

    return Detail(
      userId,
      hotelId,
      roomId,
      roomName,
      checkInDate,
      checkOutDate,
      noOfGuests,
      totalPrice,
      "Paid",
    );
  } on DioError catch (e) {
    print(e);

    throw Exception("Error retrieving posts: ${e}");
  }
}

class _KhaltiPageState extends State<KhaltiPage> {
  String referenceId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 9, right: 9),
                  child: Text(
                    'Are you sure you want to pay with khalti?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      minimumSize: const Size(200, 50),
                      backgroundColor: Color.fromARGB(255, 87, 43, 138),
                    ),
                    onPressed: () {
                      payWithKhaltiInApp();
                    },
                    child: const Text("Pay with Khalti",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white))),
                SizedBox(height: 10),
                Text(referenceId)
              ],
            ),
          ),
        ),
      ),
    );
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
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String? userId = arguments['userId'] as String?;
    final String? hotelId = arguments['hotelId'] as String?;
    final String? roomId = arguments['roomId'] as String?;
    final String? roomName = arguments['roomName'] as String?;
    final String checkInDate = arguments['checkInDate'] as String;
    final String checkOutDate = arguments['checkOutDate'] as String;
    final String noOfGuests = arguments['noOfGuests'] as String;

    final int? totalPrice = arguments['totalPrice'] as int?;
    // final String numberOfNights = arguments['numberOfNights'] as String;
    // final String paymentStatus = arguments['paymentStatus'] as String;

    print('why/??????');
    print(userId);
    print(hotelId);
    print(roomId);
    print(roomName);
    print(checkInDate);
    print(checkOutDate);
    print(noOfGuests);
    print(totalPrice);
    // print(numberOfNights);
    // print(paymentStatus);

    getDetails(
      userId!,
      hotelId!,
      roomId!,
      roomName!,
      // numberOfNights,
      checkInDate,
      checkOutDate,
      noOfGuests,
      totalPrice!,
      // paymentStatus,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
              child: Text(
            'Payment Successful',
            style: TextStyle(fontSize: 20),
          )),
          actions: [
            SimpleDialogOption(
                child: Center(child: Text('OK')),
                onPressed: () {
                  setState(() {
                    referenceId = success.idx;
                  });

                  Navigator.pushNamed(context, 'mainPage');
                })
          ],
        );
      },
    );
    // print('adfsfhkfjlasdwerupyi');
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(
      failure.toString(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
              child: Text(
            'Payment Failed',
            style: TextStyle(fontSize: 20),
          )),
          actions: [
            SimpleDialogOption(
                child: Center(child: Text('OK')),
                onPressed: () {
                  Navigator.pushNamed(context, 'mainPage');
                })
          ],
        );
      },
    );
  }

  void onCancel() {
    debugPrint('Cancelled');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Center(
              child: Text(
            'Payment Cancelled',
            style: TextStyle(fontSize: 20),
          )),
          actions: [
            SimpleDialogOption(
                child: Center(child: Text('OK')),
                onPressed: () {
                  Navigator.pushNamed(context, 'mainPage');
                })
          ],
        );
      },
    );
  }
}

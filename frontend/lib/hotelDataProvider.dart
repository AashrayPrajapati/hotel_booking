import 'package:flutter/foundation.dart';

class HotelDataProvider extends ChangeNotifier {
  late String hotelId;
  late String userId;
  late String roomId;
  late DateTime checkInDate;
  late DateTime checkOutDate;

  void setHotelData(String hotelId, String userId, String roomId) {
    this.hotelId = hotelId;
    this.userId = userId;
    this.roomId = roomId;
    notifyListeners();
  }

  void setCheckInDate(DateTime checkInDate) {
    this.checkInDate = checkInDate;
    notifyListeners();
  }

  void setCheckOutDate(DateTime checkOutDate) {
    this.checkOutDate = checkOutDate;
    notifyListeners();
  }
}

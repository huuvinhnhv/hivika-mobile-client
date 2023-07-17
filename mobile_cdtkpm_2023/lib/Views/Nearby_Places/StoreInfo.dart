import 'package:latlong2/latlong.dart';

class Place {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

List<Place> places = [
  Place(
    id: '1',
    name: 'Phuc Long',
    address: 'Số 1, Đường Nguyễn Trung Trực, Vĩnh Lạc, TP. Rạch Giá,Kiên Giang',
    latitude: 9.994148,
    longitude: 105.094498,//LatLng(9.994148, 105.094498),
  ),
  Place(
    id: '2',
    name: 'HaKaNa',
    address: 'Số 2, Đường Tôn Đức Thắng, Vĩnh lạc, TP. Rạch Giá,Kiên Giang',
    latitude: 9.992553,
    longitude: 105.084934,// LatLng(9.992553, 105.084934
  ),
  Place(
    id: '3',
    name: 'SUN VILLA CAFE & RESTAURANT',
    address: 'Số 3, Đường Chu Văn An, An Hòa, TP. Rạch Giá,Kiên Giang',
    latitude:9.987611,
    longitude: 105.102982,// LatLng(9.987611, 105.102982)
  ),
  Place(
    id: '4',
    name: 'Boulevard Café',
    address: 'Số 4, Chi Lăng, Phường Vĩnh Bảo, Rạch Giá, Kiên Giang',
    latitude: 10.004088,
    longitude: 105.089304,//LatLng(10.004088, 105.089304)
  ),
  Place(
    id: '5',
    name: 'Kichi Kichi Express Rotary Hotpot',
    address: 'Số 5, Nguyễn Trung Trực, Vĩnh Lạc, Rạch Giá, Kiên Giang, Vietnam',
    latitude: 9.987786,
    longitude: 105.099530,// LatLng(9.987786, 105.099530)
  ),
];

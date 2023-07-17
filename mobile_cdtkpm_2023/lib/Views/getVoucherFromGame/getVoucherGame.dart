import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/VoucherController.dart';
import '../MyVoucher/myVoucherPage.dart';

class GetVoucherGame extends StatelessWidget {
  final int? score;
  final int gameId;
  final String gameName;
  final String EventName;
  final int eventId;
  final DateTime endDate;
  const GetVoucherGame({
    Key? key,
    this.score,
    required this.gameId,
    required this.gameName,
    required this.EventName,
    required this.endDate,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final voucherController = Get.put(VoucherController());
    voucherController.reset();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Voucher'),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Obx(() {
                if (voucherController.numRequest.value.isEmpty) {
                  voucherController.fetchNumRequest();
                  return const CircularProgressIndicator();
                } else if (voucherController.numConvert.value == null) {
                  if (!voucherController.isLoading.value) {
                    voucherController.isLoading.value = true;
                    voucherController
                        .fetchNumConvert(
                      voucherController.numRequest.value,
                      gameName,
                      EventName,
                      endDate,
                      gameId,
                      eventId
                    )
                        .then((value) {
                      voucherController.isLoading.value = false;
                    });
                  }

                  return voucherController.isLoading.value
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              'Your discount: ${voucherController.numConvert.value!.mappingNum * 5}%',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    10),
                            MaterialButton(
                              onPressed: () {
                                
                                 Get.delete<VoucherController>();
                              
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListVoucherUser()),
                                );
                              },
                              child: const Text(
                                  'Go to Vouchers List'), // Thay đổi nội dung của nút
                            ),
                          ],
                        );
                } else {
                  return Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Your discount: ${voucherController.numConvert.value!.mappingNum * 5}%',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          height:
                              10), // Thêm khoảng cách giữa nút và thanh tiến trình
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListVoucherUser()),
                          );
                        },
                        child: const Text(
                            'Go to Vouchers List'), // Thay đổi nội dung của nút
                      ),
                    ],
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}




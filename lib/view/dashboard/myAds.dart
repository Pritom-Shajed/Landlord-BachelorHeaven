import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/dashboard/category_controller.dart';
import 'package:bachelor_heaven_landlord/view/dashboard/ad_details.dart';
import 'package:bachelor_heaven_landlord/widgets/shimmerEffect.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAds extends StatelessWidget {
  MyAds({Key? key}) : super(key: key);

  TextEditingController searchTextController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyAdsController>(builder: (controller) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: InkWell(
                  onTap: controller.flatSelected,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: controller.selected == Selected.flat
                            ? blackColor
                            : whiteColor,
                        border: Border.all(color: blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'FLAT',
                      style: poppinsTextStyle(
                          color: controller.selected == Selected.flat
                              ? whiteColor
                              : blackColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: controller.roomSelected,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: controller.selected == Selected.room
                            ? blackColor
                            : whiteColor,
                        border: Border.all(color: blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'ROOM',
                      style: poppinsTextStyle(
                          color: controller.selected == Selected.room
                              ? whiteColor
                              : blackColor),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: controller.seatSelected,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        color: controller.selected == Selected.seat
                            ? blackColor
                            : whiteColor,
                        border: Border.all(color: blackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'SEAT',
                      style: poppinsTextStyle(
                          color: controller.selected == Selected.seat
                              ? whiteColor
                              : blackColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('Ads-Individual')
                  .doc('landlord_${_currentUser!.uid}')
                  .collection(controller.selected == Selected.flat ? 'Flat':controller.selected == Selected.room ?'Room':'Seat')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.8),
                        itemBuilder: (_, index) {
                          Map<String, dynamic> adds =
                          snapshot.data!.docs[index].data();
                          return InkWell(
                            onTap: ()=>Get.to(()=>AdDetails(uid: adds['uid'])),
                            child: CachedNetworkImage(
                              imageUrl: "${adds['pictureUrl']}",
                              imageBuilder: (context, imageProvider) => Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Text(
                                        adds['category'],
                                        style: poppinsTextStyle(size: 10),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Text(
                                        adds['location'],
                                        style: poppinsTextStyle(size: 10),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Text(
                                        adds['price'],
                                        style: poppinsTextStyle(size: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              placeholder: (context, url) => Padding(
                                  padding: EdgeInsets.all(8),
                                  child: ShimmerEffect(height: 240, width: 200)),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error Occured'),
                    );
                  } else {
                    return Center(
                      child: Text('Something went wrong'),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: blackColor,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    });
  }
}

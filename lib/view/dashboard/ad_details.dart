import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/dashboard/post_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/expanstion_tile.dart';
import 'package:bachelor_heaven_landlord/widgets/shimmerEffect.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdDetails extends StatelessWidget {
  AdDetails({Key? key, required this.uid}) : super(key: key);

  PostController _controller = Get.find();
  String uid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: _firestore
                .collection('Ads-All')
                .where('uid', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  Map<String, dynamic> apartment =
                      snapshot.data!.docs[0].data();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: "${apartment['pictureUrl']}",
                        imageBuilder: (context, imageProvider) => Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                        ),
                        placeholder: (context, url) => ShimmerEffect(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.maxFinite,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Posted on: ${apartment['postDate']}',
                                  style: poppinsTextStyle(size: 12),
                                ),
                                Text(
                                  '${apartment['location']}',
                                  style: poppinsTextStyle(size: 18),
                                ),
                                Text(
                                  'Category: ${apartment['category']}',
                                  style: poppinsTextStyle(size: 12),
                                ),
                                Text(
                                  '${apartment['title']}',
                                  style: poppinsTextStyle(
                                      size: 32, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  apartment['category'] == 'Seat'
                                      ? '${apartment['price']}tk per month'
                                      : '${apartment['price']}tk per night',
                                  style: poppinsTextStyle(
                                      size: 18, fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'incl. of all taxes and duties',
                                  style: poppinsTextStyle(
                                      color: greyColor, size: 12),
                                ),
                                Divider(),
                                expansionTile(title: 'Description', children: [
                                  Text('${apartment['description']}'),
                                ]),
                                verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: customButton(
                                            text: 'Edit', onTap: () {})),
                                    horizontalSpace,
                                    Expanded(
                                        flex: 1,
                                        child: customButton(
                                            color: redColor,
                                            text: 'Delete',
                                            onTap: () async {
                                              return alertDialog(
                                                  context: context,
                                                  title:
                                                      'Are you sure to delete?',
                                                  onTapYes: () async {
                                                    await _controller
                                                        .deletePost(
                                                      uid: apartment['uid'],
                                                      categoryName:
                                                          apartment['category'],
                                                    );
                                                    Get.offAllNamed(
                                                        '/dashboard');
                                                  },
                                                  onTapNo: () => Get.back());
                                            })),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
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
                ));
              }
            }),
      ),
    );
  }
}

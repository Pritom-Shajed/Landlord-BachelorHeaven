import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/post/post_controller.dart';
import 'package:bachelor_heaven_landlord/view/dashboard/map_view.dart';
import 'package:bachelor_heaven_landlord/widgets/alert_dialog.dart';
import 'package:bachelor_heaven_landlord/widgets/custom_Button.dart';
import 'package:bachelor_heaven_landlord/widgets/expanstion_tile.dart';
import 'package:bachelor_heaven_landlord/widgets/shimmerEffect.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ApartmentDetails extends StatelessWidget {
  ApartmentDetails({Key? key, required this.uid}) : super(key: key);

  PostController _controller = Get.find();
  String uid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: whiteColor),
            backgroundColor: deepBrown,
            expandedHeight: MediaQuery.of(context).size.height / 2.2,
            floating: true,
            pinned: true,
            flexibleSpace: StreamBuilder(
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
                        children: [
                          Expanded(
                            child: FlexibleSpaceBar(
                              title: Text(
                                apartment['category'],
                                style: poppinsTextStyle(
                                    size: 30, fontWeight: FontWeight.bold),
                              ),
                              background: CachedNetworkImage(
                                imageUrl: "${apartment['pictureUrl']}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      height:
                                      MediaQuery.of(context).size.height * 0.45,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                placeholder: (context, url) => ShimmerEffect(
                                  height:
                                  MediaQuery.of(context).size.height * 0.45,
                                  width: double.maxFinite,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
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
          SliverToBoxAdapter(
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
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    apartment['title'],
                                    style: poppinsTextStyle(
                                        size: 32,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Posted on: ${apartment['postDate']}',
                                    style: poppinsTextStyle(size: 12),
                                  ),
                                  verticalSpaceSmall,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        size: 22,
                                        color: greyColor,
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          '${apartment['location']}',
                                          style: poppinsTextStyle(size: 20),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TextButton(
                                          onPressed: () => Get.to(() =>
                                              ApartmentMapView(
                                                  lat:
                                                  apartment['latitude'],
                                                  lon: apartment[
                                                  'longitude'],
                                                  title:
                                                  apartment['title'])), child: Text('View', style: poppinsTextStyle(color: blueColor),),),
                                      ),
                                    ],
                                  ),
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Text(
                                        '???${apartment['price']}',
                                        style: poppinsTextStyle(
                                            color: blackColor,
                                            size: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        apartment['category'] == 'Seat'
                                            ? ' /month'
                                            : ' /night',
                                        style: poppinsTextStyle(
                                            color: greyColor, size: 18),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'incl. of all taxes and duties',
                                    style: poppinsTextStyle(
                                        color: greyColor, size: 12),
                                  ),
                                  Divider(),
                                  expansionTile(
                                      title: 'Description',
                                      children: [
                                        Text('${apartment['description']}'),
                                      ]),
                                  expansionTile(title: 'Reviews', children: [
                                    Container(
                                      child: FutureBuilder(
                                          future: _firestore
                                              .collection("Ratings")
                                              .where('apartmentUid',
                                              isEqualTo: apartment['uid'])
                                              .get(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              if (snapshot.hasData) {
                                                return ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return Divider(
                                                        color: shadowColor,
                                                      );
                                                    },
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data!.docs.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      Map<String, dynamic>
                                                      reviews = snapshot
                                                          .data!.docs[index]
                                                          .data();
                                                      return Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                reviews[
                                                                'ratedBy'],
                                                                style:
                                                                poppinsTextStyle(
                                                                  color:
                                                                  greyColor,
                                                                ),
                                                              ),
                                                              Text(
                                                                reviews[
                                                                'comments'],
                                                                style: poppinsTextStyle(
                                                                    color:
                                                                    blackColor,
                                                                    size: 14),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                color:
                                                                amberColor,
                                                              ),
                                                              Text(
                                                                  '${reviews['rating']}')
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text('Error Occured'),
                                                );
                                              } else {
                                                return Center(
                                                  child: Text(
                                                      'Something went wrong'),
                                                );
                                              }
                                            } else {
                                              return Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    color: blackColor,
                                                  ));
                                            }
                                          }),
                                    )
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
                                                        currentUserUid: _currentUser!.uid,
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
        ]
      ),
    );
  }
}

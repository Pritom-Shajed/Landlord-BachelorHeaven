import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/controller/dashboard/rating_controller.dart';
import 'package:bachelor_heaven_landlord/widgets/shimmerEffect.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget BookingCard(
    {required String bookingTitle,
    required String bookingLocation,
    required String imgUrl,
    required int rating,
    required VoidCallback onTap}) {
  RatingController _controller = Get.find();
  return Card(
      margin: EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0.0,
      child: InkWell(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: imgUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
            width: 200,
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _controller.ratingTotal(
                    iconSize: 25, textColor: whiteColor, textSize: 20),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingTitle,
                      style: poppinsTextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w600,
                          size: 22),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 19,
                          color: whiteColor,
                        ),
                        Expanded(
                          child: Text(
                            bookingLocation,
                            style: poppinsTextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w600,
                                size: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
          placeholder: (context, url) => ShimmerEffect(width: 200, height: 200),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ));
}

Widget BookingCard2(
    {required BuildContext context,
    required String bookingTitle,
    required String bookingLocation,
    required String price,
    required String pricePerNightOrMonth,
    required String imgUrl,
    required int rating,
    required VoidCallback onTap}) {
  RatingController _controller = Get.find();
  return InkWell(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0.0, 0.0),
              blurRadius: 16,
            )
          ]),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: imgUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              height: 60,
              width: 60,
              padding: EdgeInsets.all(12),
            ),
            placeholder: (context, url) => ShimmerEffect(width: 60, height: 60),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          horizontalSpace,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bookingTitle,
                        style: poppinsTextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.w600,
                            size: 14)),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: '৳${price}',
                        style: poppinsTextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            size: 12),
                      ),
                      TextSpan(
                        text: pricePerNightOrMonth,
                        style: poppinsTextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.w500,
                            size: 12),
                      )
                    ])),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 14,
                          color: greyColor,
                        ),
                        Text(
                          bookingLocation,
                          style: poppinsTextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w600,
                              size: 12),
                        ),
                      ],
                    ),
                    _controller.ratingTotal(
                        iconSize: 15, textColor: blackColor, textSize: 12),
                  ],
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

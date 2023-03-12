import 'package:bachelor_heaven_landlord/constants/constants.dart';
import 'package:bachelor_heaven_landlord/widgets/shimmerEffect.dart';
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget BookingCardCancelled(
    {required BuildContext context,
      required String imageUrl,
      required String apartmentTitle,
      required String personsTotal,
      required String location,
      required String price,
      required String category,
      required Widget buttonOne,
      required Widget buttonTwo,
      VoidCallback? onTap,
      String? bookingStatus,
      String? cancelled}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 160,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              );
            },
            placeholder: (context, url) => ShimmerEffect(width: MediaQuery.of(context).size.width * 0.45, height: 160),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apartmentTitle,
                  style: poppinsTextStyle(size: 24, fontWeight: FontWeight.w600),
                ),
                verticalSpaceSmall,
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 17,
                    ),
                    Expanded(
                        child: Text(
                          location,
                          style:
                          poppinsTextStyle(size: 14, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 17,
                    ),
                    Expanded(
                        child: Text(
                          personsTotal,
                          style:
                          poppinsTextStyle(size: 14, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '৳$price',
                        style: poppinsTextStyle(
                            color: blackColor,
                            size: 14,
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                      text: category == 'Seat' ? ' /month' : ' /night',
                      style: poppinsTextStyle(
                          color: greyColor,
                          size: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ]),
                ),
                verticalSpaceSmall,
                Row(
                  children: [
                    Expanded(child: buttonOne),
                    horizontalSpace,
                    bookingStatus != 'Confirmed' && cancelled == 'No' ? Expanded(child: buttonTwo) : Container(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget BookingCardNormal(
    {required BuildContext context,
      required String imageUrl,
      required String apartmentTitle,
      required String personsTotal,
      required String location,
      required String price,
      required String category,
      required Widget buttonOne,
      required Widget buttonTwo,
      VoidCallback? onTap,
      String? bookingStatus,
      String? cancelled}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) {
              return Container(
                height: 160,
                width: MediaQuery.of(context).size.width * 0.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover)),
              );
            },
            placeholder: (context, url) => ShimmerEffect(width: MediaQuery.of(context).size.width * 0.45, height: 160),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apartmentTitle,
                  style: poppinsTextStyle(size: 24, fontWeight: FontWeight.w600),
                ),
                verticalSpaceSmall,
                Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 17,
                    ),
                    Expanded(
                        child: Text(
                          location,
                          style:
                          poppinsTextStyle(size: 14, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 17,
                    ),
                    Expanded(
                        child: Text(
                          personsTotal,
                          style:
                          poppinsTextStyle(size: 14, fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '৳$price',
                        style: poppinsTextStyle(
                            color: blackColor,
                            size: 14,
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                      text: category == 'Seat' ? ' /month' : ' /night',
                      style: poppinsTextStyle(
                          color: greyColor,
                          size: 14,
                          fontWeight: FontWeight.w500),
                    )
                  ]),
                ),
                verticalSpaceSmall,
                Row(
                  children: [
                    cancelled != 'Requested' ? Expanded(child: buttonOne):Container(),
                    cancelled != 'Requested' ? horizontalSpace:Container(),
                    bookingStatus != 'Confirmed' ?  Expanded(child: buttonTwo):Container(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
import 'package:bachelor_heaven_landlord/widgets/textStyles.dart';
import 'package:flutter/material.dart';

Widget expansionTile({required String title, required List<Widget> children}) {
  return ExpansionTile(
    title: Text(title,
        style: poppinsTextStyle(size: 18, fontWeight: FontWeight.w600)),
    subtitle: Text('Click to view details'),
    children: children,
  );
}

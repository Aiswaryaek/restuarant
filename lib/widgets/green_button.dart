import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/textstyles.dart';

Widget customButton(BuildContext context, String btnText, bool isVisible,
    dynamic icon, Function callbackAction, dynamic color) {
  return SizedBox(
    width: double.infinity,
    height: 60,
    child: TextButton(
      onPressed: () => callbackAction(),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isVisible
                ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      icon,
                      color: whiteColor,
                    ),
                  )
                : Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(4),
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: whiteColor,
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Image.network(
                      icon,
                    ),
                  ),
            SizedBox(width: 70),
            Text(btnText, style: btnTextStyle),
            SizedBox(width: 100),
            Text('  '),
          ],
        ),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        primary: Colors.white,
        backgroundColor: color,
      ),
    ),
  );
}

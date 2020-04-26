import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BannersTop extends StatefulWidget {
  @override
  _BannersTopState createState() => _BannersTopState();
}

class _BannersTopState extends State<BannersTop> {

  List<String> banner = ['ejemplo_bt_zm_1.png', 'ejemplo_bt_zm_2.png'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(
              image: AssetImage(
                'assets/images/banners/${banner[index]}',
              ),
            )
          );
        },
        itemCount: banner.length,
        viewportFraction: 0.9,
        scale: 0.9,
      )
    );
  }
}

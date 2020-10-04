import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BannersTop extends StatefulWidget {
  @override
  _BannersTopState createState() => _BannersTopState();
}

class _BannersTopState extends State<BannersTop> {

  List<String> banner = ['ejemplo_bt_zm_1.jpg', 'ejemplo_bt_zm_2.jpg'];

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.28,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image(
            image: AssetImage('assets/images/banners/${banner[index]}'),
            fit: BoxFit.fitWidth
          );
        },
        itemCount: banner.length,
        viewportFraction: 1,
        scale: 1,
        autoplay: true,
        autoplayDelay: 6000,
      )
    );
  }
}

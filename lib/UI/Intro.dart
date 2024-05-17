import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobilink_v2/UI/login.dart';

class IntroductionScreens extends StatelessWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
          title: 'Kemudahan dalam Rental Mobil',
          body: 'Temukan kemudahan dalam menyewa mobil dengan layanan kami yang cepat dan praktis.',
          image: buildImage("assets/images/image_1.png"),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Nikmati Liburan Anda dengan Mobilink',
          body: 'Liburan Anda lebih menyenangkan dengan Mobilink. Pilihan mobil berkualitas untuk setiap perjalanan.',
          image: buildImage("assets/images/image_2.png"),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Nikmati Kenyamanan dalam Berwisata',
          body: 'Rasakan kenyamanan maksimal dalam setiap perjalanan wisata Anda bersama layanan prima kami.',
          image: buildImage("assets/images/image_3.png"),
          decoration: getPageDecoration(),
        ),

        ],
        onDone: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
        },
        scrollPhysics: const ClampingScrollPhysics(),
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: true,
        skip: const Text("Skip", style: TextStyle(fontWeight: FontWeight.w600)),
        next: const Icon(Icons.forward),
        done: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: getDotsDecorator(),
      ),
    );
  }

  Widget buildImage(String imagePath) {
    return Center(
      child: Image.asset(
        imagePath,
        width: 450,
        height: 200,
      ),
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.indigo,
      color: Colors.grey,
      activeSize: Size(12, 5),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}

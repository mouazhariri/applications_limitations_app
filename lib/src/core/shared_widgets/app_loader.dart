import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:applications_limitations/gen/assets.gen.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Lottie.asset(
      width: 50,
      height: 50,
      Assets.lottie.circleLoader,
      // Assets.lottie.processingCircle,
      repeat: true,

      // fit: BoxFit.cover,
      // frameRate: FrameRate.max,
    ));
  }
}

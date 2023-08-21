import 'package:burnboss/theme/theme_constants.dart';
import 'package:burnboss/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: SpinKitFoldingCube(
          color: COLOR_PRIMARY,
          size: 50.0,
        ),
      ),
    );
  }
}

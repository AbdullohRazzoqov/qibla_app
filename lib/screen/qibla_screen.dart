import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

Animation<double>? animation;
AnimationController? _animationController;
double begin = 0.0;

class _QiblaScreenState extends State<QiblaScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween(begin: 0.0, end: 0.0).animate(_animationController!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Qibla"),
          ),
          body: StreamBuilder(
              stream: FlutterQiblah.qiblahStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                }

                final qiblahDirection = snapshot.data;
                print(
                    '=================================================${qiblahDirection!.direction}');
                animation = Tween(
                        begin: begin,
                        end: (qiblahDirection.qiblah * (pi / 180) * -1))
                    .animate(_animationController!);
                begin = (qiblahDirection.qiblah * (pi / 180) * -1);
                _animationController!.forward(from: 0);

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${qiblahDirection.direction.toInt()}"),
                      AnimatedBuilder(
                          animation: animation!,
                          builder: (context, child) {
                            return SizedBox(
                                width: 300,
                                height: 300,
                                child: Transform.rotate(
                                  angle: animation!.value,
                                  child:
                                      Image.asset('assets/images/download.png'),
                                ));
                          })
                    ],
                  ),
                );
              })),
    );
  }
}

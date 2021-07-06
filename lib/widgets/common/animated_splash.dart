import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../screens/base_screen.dart';

class AnimatedSplash extends StatelessWidget {
  const AnimatedSplash({
    Key? key,
    required this.next,
    required this.imagePath,
    this.animationEffect = 'fade-in',
    this.logoSize,
    this.secondsTimeDelay = 3,
  }) : super(key: key);

  final Function? next;
  final String imagePath;
  final int secondsTimeDelay;
  final String animationEffect;
  final double? logoSize;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _AnimatedSplashChild(
        next: next,
        imagePath: imagePath,
        secondsTimeDelay: secondsTimeDelay,
        animationEffect: animationEffect,
        logoSize: logoSize,
      ),
    );
  }
}

class _AnimatedSplashChild extends StatefulWidget {
  final Function? next;
  final String imagePath;
  final int secondsTimeDelay;
  final String animationEffect;
  final double? logoSize;

  _AnimatedSplashChild({
    required this.next,
    required this.imagePath,
    required this.animationEffect,
    this.logoSize,
    this.secondsTimeDelay = 3,
  });

  @override
  __AnimatedSplashStateChild createState() => __AnimatedSplashStateChild();
}

class __AnimatedSplashStateChild extends BaseScreen<_AnimatedSplashChild>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late String _imagePath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.secondsTimeDelay),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInCubic,
    ));
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1500)).then(
          (value) {
            widget.next?.call();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.reset();
    _animationController.dispose();
  }

  Widget _buildAnimation() {
    switch (widget.animationEffect) {
      case SplashScreenTypeConstants.fadeIn:
        {
          return FadeTransition(
            opacity: _animation,
            child: Center(
              child: SizedBox(
                height: widget.logoSize,
                child: Image.asset(_imagePath),
              ),
            ),
          );
        }
      case SplashScreenTypeConstants.zoomIn:
        {
          return ScaleTransition(
            scale: _animation,
            child: Center(
              child: SizedBox(
                height: widget.logoSize,
                child: Image.asset(_imagePath),
              ),
            ),
          );
        }
      case SplashScreenTypeConstants.zoomOut:
        {
          return ScaleTransition(
              scale: Tween(begin: 1.5, end: 0.6).animate(CurvedAnimation(
                  parent: _animationController, curve: Curves.easeInCirc)),
              child: Center(
                child: SizedBox(
                  height: widget.logoSize,
                  child: Image.asset(_imagePath),
                ),
              ));
        }
      case SplashScreenTypeConstants.topDown:
      default:
        {
          return SizeTransition(
            sizeFactor: _animation,
            child: Center(
              child: SizedBox(
                height: widget.logoSize,
                child: Image.asset(_imagePath),
              ),
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildAnimation();
  }
}

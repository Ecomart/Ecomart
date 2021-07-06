import 'package:flutter/material.dart';
import 'intro_slider/intro_slider_wrapper.dart';
import 'onboarding_constants.dart';

class OnBoardingWidget extends StatefulWidget {
  final List data;
  final bool isRequiredLogin;
  final String? titleSignIn;
  final String? titleSignUp;
  final String? titlePrev;
  final String? titleSkip;
  final String? titleNext;
  final String? titleDone;
  final String? layout;
  final Function? onTapSignIn;
  final Function? onTapSignUp;
  final Function? onTapDone;

  OnBoardingWidget({
    required this.data,
    this.isRequiredLogin = false,
    this.layout,
    this.titleSignIn,
    this.titleSignUp,
    this.titlePrev,
    this.titleSkip,
    this.titleNext,
    this.titleDone,
    this.onTapSignIn,
    this.onTapSignUp,
    this.onTapDone,
  });

  @override
  _OnBoardingWidgetState createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  bool get isRequiredLogin => widget.isRequiredLogin;
  String? get orderCompleted => (data.isNotEmpty &&
          data.length == 3 &&
          (data[2]['image']?.isNotEmpty ?? false))
      ? data[2]['image']
      : '';
  List get data => widget.data;
  int page = 0;

  List<SlideWrapper> getSlides() {
    final slides = <SlideWrapper>[];

    final Widget loginWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (orderCompleted?.isNotEmpty ?? true)
          Image.asset(
            orderCompleted!,
            fit: BoxFit.fitWidth,
          ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: widget.onTapSignIn as void Function()?,
                child: Text(
                  widget.titleSignIn ?? 'Sign In',
                  style: const TextStyle(
                    color: kColorTeal400,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const Text(
                '    |    ',
                style: TextStyle(color: kColorTeal400, fontSize: 20.0),
              ),
              GestureDetector(
                onTap: widget.onTapSignUp as void Function()? ??
                    'Sign Up' as void Function()?,
                child: Text(
                  // ignore: avoid_as
                  widget.onTapSignUp as String? ?? '',
                  style: const TextStyle(
                    color: kColorTeal400,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    for (var i = 0; i < data.length; i++) {
      final slide = SlideWrapper(
        title: data[i]['title'],
        description: data[i]['desc'],
        marginTitle: const EdgeInsets.only(
          top: 125.0,
          bottom: 50.0,
        ),
        maxLineTextDescription: 2,
        styleTitle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25.0,
          color: kColorGrey900,
        ),
        backgroundColor: Colors.white,
        marginDescription: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 0),
        styleDescription: const TextStyle(
          fontSize: 15.0,
          color: kColorGrey600,
        ),
        foregroundImageFit: BoxFit.fitWidth,
      );

      if (i == 2) {
        slide.centerWidget = loginWidget;
      } else {
        slide.pathImage = data[i]['image'];
      }
      slides.add(slide);
    }
    return slides;
  }

  static const textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  List<Widget> getPages(List data) {
    return [
      for (int i = 0; i < data.length; i++)
        Container(
          color: HexColor(data[i]['background']),
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                data[i]['image'],
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Column(
                children: <Widget>[
                  Text(
                    data[i]['title'],
                    style: textStyle.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data[i]['desc'],
                    style: textStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        )
    ];
  }

  void pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroSliderWrapper(
        slides: getSlides(),
        styleSkipBtn: const TextStyle(color: kColorGrey900),
        styleDoneBtn: const TextStyle(color: kColorGrey900),
        namePrevBtn: widget.titlePrev ?? 'Prev',
        nameSkipBtn: widget.titleSkip ?? 'Skip',
        nameNextBtn: widget.titleNext ?? 'Next',
        nameDoneBtn: isRequiredLogin ? '' : widget.titleDone ?? 'Done',
        isShowDoneBtn: !isRequiredLogin,
        onDonePress: widget.onTapDone,
      ),
    );
  }
}

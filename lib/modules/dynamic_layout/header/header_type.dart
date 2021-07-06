import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../config/header_config.dart';
import '../helper/helper.dart';

class HeaderType extends StatelessWidget {
  final HeaderConfig config;

  const HeaderType({required this.config});

  FontWeight getFontWeight(String fontWeight) {
    switch (fontWeight) {
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
      case '400':
      default:
        return FontWeight.w400;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _fontSize = config.fontSize;
    var _textOpacity = config.textOpacity;
    var _fontWeight = config.fontWeight ?? 400;
    var _textColor = config.textColor ?? Theme.of(context).accentColor;

    var _textStyle = TextStyle(
      fontSize: _fontSize,
      fontWeight: getFontWeight(_fontWeight.toString()),
      color: _textColor.withOpacity(_textOpacity),
    );

    switch (config.type) {
      case 'rotate':
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              config.title,
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(width: 10.0, height: 20.0),
            AnimatedTextKit(
              isRepeatingAnimation: true,
              animatedTexts: [
                for (var name in config.rotate!)
                  RotateAnimatedText(
                    '$name',
                    textStyle: _textStyle,
                  ),
              ],
              repeatForever: true,
            ),
          ],
        );
      case 'fade':
        return SizedBox(
          width: 200.0,
          height: 200.0,
          child: AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
              for (var name in config.rotate!)
                FadeAnimatedText(
                  name,
                  textStyle: _textStyle,
                ),
            ],
            repeatForever: true,
          ),
        );
      case 'typer':
        return SizedBox(
          width: 250.0,
          child: AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
              for (var name in config.rotate!)
                TyperAnimatedText(
                  '$name',
                  textStyle: _textStyle,
                ),
            ],
          ),
        );
      case 'typewriter':
        return SizedBox(
          width: 250.0,
          child: AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
              for (var name in config.rotate!)
                TypewriterAnimatedText(
                  '$name',
                  textStyle: _textStyle,
                ),
            ],
            repeatForever: true,
          ),
        );
      case 'scale':
        return SizedBox(
          width: 250.0,
          child: AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
              for (var name in config.rotate!)
                ScaleAnimatedText(
                  '$name',
                  textStyle: _textStyle,
                ),
            ],
            repeatForever: true,
          ),
        );
      case 'color':
        return SizedBox(
          width: 250.0,
          height: 40,
          child: AnimatedTextKit(
            isRepeatingAnimation: true,
            onTap: () {},
            animatedTexts: [
              for (var name in config.rotate!)
                ColorizeAnimatedText(
                  '$name',
                  textStyle: _textStyle,
                  colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.yellow,
                    Colors.red,
                  ],
                ),
            ],
            repeatForever: true,
          ),
        );
      case 'animatedSearch':
        return Container(
          height: 40.0,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: Helper.formatDouble(config.shadow ?? 15.0)!,
                offset: Offset(0, Helper.formatDouble(config.shadow ?? 10.0)!),
              ),
            ],
            borderRadius: BorderRadius.circular(
              Helper.formatDouble(config.radius ?? 30.0)!,
            ),
            border: Border.all(
              width: 1.0,
              color: Colors.black.withOpacity(0.05),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AnimatedTextKit(
                isRepeatingAnimation: true,
                pause: const Duration(milliseconds: 2000),
                totalRepeatCount: 50,
                animatedTexts: [
                  for (var name in config.rotate!)
                    TypewriterAnimatedText(
                      '$name',
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 150),
                      textStyle: _textStyle,
                    ),
                ],
              ),
            ],
          ),
        );
      case 'static':
      default:
        return AutoSizeText(
          config.title,
          style: _textStyle,
          maxLines: 3,
          minFontSize: _fontSize - 10,
          maxFontSize: _fontSize,
          group: AutoSizeGroup(),
        );
    }
  }
}

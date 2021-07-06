import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show FluxImage, iconPicker;
import 'package:provider/provider.dart';

import '../../../models/cart/cart_base.dart';
import '../config/logo_config.dart';

class LogoIcon extends StatelessWidget {
  final LogoConfig config;
  final Function onTap;
  final MenuIcon? menuIcon;

  const LogoIcon({
    Key? key,
    required this.config,
    required this.onTap,
    this.menuIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      key: const Key('drawerMenu'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          config.iconRadius,
        ),
      ),
      elevation: 0,
      fillColor: config.iconBackground != null
          ? config.iconBackground!.withOpacity(config.iconOpacity)
          : Theme.of(context).backgroundColor.withOpacity(config.iconOpacity),
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 6,
      ),
      onPressed: () => onTap()!,
      child: Icon(
        menuIcon != null
            ? iconPicker(
                menuIcon!.name!,
                menuIcon!.fontFamily ?? 'CupertinoIcons',
              )
            : Icons.blur_on,
        color:
            config.iconColor ?? Theme.of(context).accentColor.withOpacity(0.9),
        size: config.iconSize,
      ),
    );
  }
}

class Logo extends StatelessWidget {
  final onSearch;
  final onTapDrawerMenu;
  final String? logo;
  final LogoConfig config;

  const Logo({
    Key? key,
    required this.config,
    required this.onSearch,
    required this.onTapDrawerMenu,
    this.logo,
  }) : super(key: key);

  Widget renderLogo() {
    if (config.image != null) {
      if (config.image!.contains('http')) {
        return FluxImage(imageUrl: config.image!, height: 50);
      }
      return Image.asset(
        config.image!,
        height: 40,
      );
    }

    /// render from config to support dark/light theme
    if (logo != null) {
      return FluxImage(imageUrl: logo!, height: 40);
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRotate = screenSize.width > screenSize.height;
    final totalCart =
        Provider.of<CartModel>(context, listen: true).totalCartQuantity;

    return Builder(
      builder: (context) {
        return Container(
          width: screenSize.width,
          child: FittedBox(
            fit: BoxFit.cover,
            child: Container(
              width: screenSize.width /
                  ((isRotate ? 1.25 : 2) /
                      (screenSize.height / screenSize.width)),
              constraints: const BoxConstraints(minHeight: 40.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: (config.showMenu ?? false)
                          ? LogoIcon(
                              menuIcon: config.menuIcon,
                              onTap: onTapDrawerMenu,
                              config: config,
                            )
                          : const SizedBox(),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if (config.showLogo) Center(child: renderLogo()),
                              if (config.showLogo && config.name != null) ...[
                                const SizedBox(width: 5),
                                Text(
                                  config.name!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (config.showSearch)
                      Expanded(
                        child: LogoIcon(
                          menuIcon:
                              config.searchIcon ?? MenuIcon(name: 'search'),
                          onTap: onSearch,
                          config: config,
                        ),
                      ),
                    if (config.showCart)
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            LogoIcon(
                              menuIcon:
                                  config.cartIcon ?? MenuIcon(name: 'bag'),
                              onTap: onSearch,
                              config: config,
                            ),
                            if (totalCart > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    totalCart.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      height: 1.3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    if (!config.showSearch && !config.showCart)
                      const Expanded(child: SizedBox())
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

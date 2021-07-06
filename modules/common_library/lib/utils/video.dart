import 'logs.dart';

class Videos {
  static String? getVideoLink(String? content) {
    if (content == null) {
      return '';
    }

    final youtubeLink = _getYoutubeLink(content);

    if (youtubeLink != null) {
      return youtubeLink;
    }
    final facebookLink = _getFacebookLink(content);
    if (facebookLink != null) {
      return facebookLink;
    } else {
      return _getVimeoLink(content);
    }
  }

  static String? _getYoutubeLink(String? content) {
    final regExp = RegExp(
        'https://www.youtube.com/((v|embed))\/?[a-zA-Z0-9_-]+',
        multiLine: true,
        caseSensitive: false);

    String? youtubeUrl;

    try {
      final matches = regExp.allMatches(content!);
      if (matches.isNotEmpty) {
        youtubeUrl = matches.first.group(0) ?? '';
      }
      // ignore: empty_catches
    } catch (error) {}
    return youtubeUrl;
  }

  static String? _getFacebookLink(String? content) {
    if (content == null) {
      return '';
    }

    final regExp = RegExp(
        'https://www.facebook.com\/[a-zA-Z0-9\.]+\/videos\/(?:[a-zA-Z0-9\.]+\/)?([0-9]+)',
        multiLine: true,
        caseSensitive: false);

    String? facebookVideoId;
    String? facebookUrl;
    try {
      final matches = regExp.allMatches(content);

      if (matches.isNotEmpty) {
        facebookVideoId = matches.first.group(1);
        if (facebookVideoId != null) {
          facebookUrl =
              'https://www.facebook.com/video/embed?video_id=$facebookVideoId';
        }
      }
    } catch (error, trace) {
      printLog(error);
      printLog(trace);
    }
    return facebookUrl;
  }

  static String? _getVimeoLink(String? content) {
    if (content == null) {
      return '';
    }

    final regExp = RegExp('https://player.vimeo.com/((v|video))\/?[0-9]+',
        multiLine: true, caseSensitive: false);

    String? vimeoUrl;

    try {
      final matches = regExp.allMatches(content);
      if (matches.isNotEmpty) {
        vimeoUrl = matches.first.group(0);
      }
    } catch (error) {
      printLog(error);
    }
    return vimeoUrl;
  }
}

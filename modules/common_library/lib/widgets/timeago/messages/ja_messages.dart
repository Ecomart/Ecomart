import 'lookupmessages.dart';

/// Japanese messages
class JaMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '今から';
  @override
  String suffixAgo() => '前';
  @override
  String suffixFromNow() => '後';
  @override
  String lessThanOneMinute(int seconds) => '1分未満';
  @override
  String aboutAMinute(int minutes) => '約1分';
  @override
  // ignore: unnecessary_brace_in_string_interps
  String minutes(int minutes) => '${minutes}分';
  @override
  String aboutAnHour(int minutes) => '約1時間';
  @override
  // ignore: unnecessary_brace_in_string_interps
  String hours(int hours) => '約${hours}時間';
  @override
  String aDay(int hours) => '約1日';
  @override
  // ignore: unnecessary_brace_in_string_interps
  String days(int days) => '約${days}日';
  @override
  String aboutAMonth(int days) => '約1か月';
  @override
  // ignore: unnecessary_brace_in_string_interps
  String months(int months) => '約${months}か月';
  @override
  String aboutAYear(int year) => '約1年';
  @override
  // ignore: unnecessary_brace_in_string_interps
  String years(int years) => '約${years}年';
  @override
  String wordSeparator() => '';
}

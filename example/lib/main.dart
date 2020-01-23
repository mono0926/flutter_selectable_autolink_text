import 'package:flutter/material.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Selectable Autolink Text'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _basic(context),
            const Divider(height: 32),
            _advanced(context),
            const Divider(height: 24),
            _custom(context),
            const Divider(height: 48),
            _moreAdvanced(context),
          ],
        ),
      ),
    );
  }

  Widget _basic(BuildContext context) {
    return SelectableAutoLinkText(
      'Basic https://flutter.dev',
      linkStyle: TextStyle(color: Colors.blueAccent),
      onTap: (url) => print('🍅Tap: $url'),
      onLongPress: (url) => print('🍕LongPress: $url'),
    );
  }

  Widget _advanced(BuildContext context) {
    return SelectableAutoLinkText(
      '''
Advanced
Selectable Autolink Text https://github.com/housmart/flutter_selectable_autolink_text
for Flutter https://flutter.dev
tel:012-3456-7890
email mail@example.com
normal text
normal text
''',
      style: TextStyle(color: Colors.black87),
      linkStyle: TextStyle(color: Colors.purpleAccent),
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) async {
        print('🌶Tap: $url');
        if (await canLaunch(url)) {
          launch(url, forceSafariVC: false);
        }
      },
      onLongPress: (url) {
        print('🍔LongPress: $url');
        Share.share(url);
      },
      onTapOther: () {
        print('🍇️onTapOther');
      },
    );
  }

  Widget _custom(BuildContext context) {
    return SelectableAutoLinkText(
      'Custom link @screen_name.'
      '\nHello #hash_tag! Like https://twitter.com.',
      style: TextStyle(color: Colors.brown[800]),
      linkStyle: TextStyle(color: Colors.orangeAccent[700]),
      linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) => print('🍒Tap: $url'),
      onLongPress: (url) => print('🍩LongPress: $url'),
      onDebugMatch: (match) =>
          print('DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`'),
    );
  }

  Widget _moreAdvanced(BuildContext context) {
    final blueStyle = const TextStyle(color: Colors.blueAccent);
    final pinkStyle = const TextStyle(color: Colors.pinkAccent);
    final bold1Style =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    final bold2Style =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    final italic2Style =
        const TextStyle(fontStyle: FontStyle.italic, fontSize: 14);
    final regExpPattern = r'\[([^\]]+)\]\(([\S]+)\)';
    final regExp = RegExp(regExpPattern);

    return SelectableAutoLinkText(
      '[More advanced usage](bold1)\n'
      '\n'
      '[This is a link text](https://google.com)\n'
      '[This text is bold](bold2)\n'
      'This text is normal\n'
      '[This text is italic](italic2)\n'
      '[This text is pink](pink)\n',
      linkRegExpPattern: regExpPattern,
      onTransformDisplayTextAttr: (s) {
        final match = regExp.firstMatch(s);
        if (match?.groupCount == 2) {
          final text1 = match.group(1);
          final text2 = match.group(2);
          switch (text2) {
            case 'bold1':
              return TextAttribute(text1, style: bold1Style);
            case 'bold2':
              return TextAttribute(text1, style: bold2Style);
            case 'italic2':
              return TextAttribute(text1, style: italic2Style);
            case 'pink':
              return TextAttribute(text1, style: pinkStyle);
            default:
              if (text2.startsWith('http')) {
                return TextAttribute(text1, style: blueStyle, link: text2);
              } else {
                return TextAttribute(text1);
              }
          }
        }
        return TextAttribute(s);
      },
      onTap: (url) => launch(url, forceSafariVC: false),
      onLongPress: (url) => Share.share(url),
    );
  }
}

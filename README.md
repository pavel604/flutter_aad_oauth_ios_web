# Flutter Azure AD for iOS and WEB

This library is a merger of [flutter_aad_oauth](https://pub.dev/packages/flutter_aad_oauth) and [aad_oauth](https://pub.dev/packages/aad_oauth) plugins on pub.dev. 

It's been refactored to exclude additional depenedencies, such as [universal_html](https://pub.dev/packages/universal_html) and [keyboard_actions](https://pub.dev/packages/keyboard_actions), and is using only what comes with Flutter. 

JWT utility is also included, so you don't need to add extra dependency.

This library works with iOS and WEB platforms only, and it does not require BuildContext or GlobalKey to work.

Just add this folder to your project and use as you would normally

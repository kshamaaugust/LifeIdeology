# Life_Ideology

## Flutter setup on local
	export PATH="$PATH:/Library/WebServer/Documents/flutter/flutter/bin"

## Open Simulator
	open -a Simulator

## make your flutter folder:
	flutter create LifeIdeology

## To see all details:
	flutter doctor

## To run flutter app:
	flutter run

## after implement in yaml file:
	flutter pub get

## after import package in amy file:
	flutter packages upgrade

## Upgrade Flutter:
	flutter upgrade
	flutter pub upgrade

## For Social Login (google) signin update in yaml:
	dependencies:
		google_sign_in: ^4.5.3

## For using signin button update in yaml:
	dependencies:
		flutter_signin_button: ^0.2.8

## For using FontAwesome, update in yaml:
	dependencies:
		font_awesome_flutter: ^8.4.0

## To add assets to your application, add an assets section, like this:
	assets:
    - assets/images/

## For use Percentage Indecator, update in yaml:
	dependencies:
		percent_indicator: "^2.1.5"

## modify .yaml file for using API:
	http: any
	shared_preferences: any  

## After update yaml file run command: 
	flutter pub get

## for use localstorage update yaml file: 
	dependencies:
		localstorage: ^3.0.0

## for use flutterSEcureStorage update yaml file: 
	dependencies:
		flutter_secure_storage: ^3.3.3

## /var/www/apps/time/ForTimeStint/android/app/build.gradle :
	 minSdkVersion 18

## To see all channel in flutter, command is here: 
	flutter channel

## To remove html tag from API string:
	dependencies:
		flutter_html: any

## To use web, update inn yaml:
	dependencies:
	  flutter_web_browser: "^0.13.0"
	import 'package:flutter_web_browser/flutter_web_browser.dart';

## Update in yaml, For App logo change:
	dev_dependencies:
		flutter_launcher_icons: "^0.8.1"
	flutter_icons:
		image_path: "assets/images/256.png" 
		android: true
		ios: true
## Run command after update in yaml, for main logo change:
	flutter pub get
	flutter pub run flutter_launcher_icons:main

## For use device id:
	dependencies
		device_id: ^0.1.3
	import 'package:device_id/device_id.dart';
  		

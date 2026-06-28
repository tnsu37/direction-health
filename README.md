# Flutter-boiler-plate


## Architecture
* flutter + getx + http + mvc pattern

## 패키지명 변경 커맨드
* flutter pub run change_app_package_name:main 

## 아이콘 생성 커맨드
* dart run icons_launcher:create

## keystore generate
* keytool -genkey -v -keystore my-release-key.keystore -alias my-key-alias -keyalg RSA -keysize 2048 -validity 10000

## 파이어베이스 연동
* firebase login
* dart pub global activate flutterfire_cli
* flutterfire configure

## 알림 아이콘 변경
* android/app/src/main/res/mipmap에 있는 ic_launcher 파일 들 변경

## 안드로이드 키 확인
* keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
* keytool -list -v -keystore <릴리즈 키 위치> -alias <릴리즈 키 alias명>

## 키해시

* keytool -exportcert -alias <릴리즈 키 alias명> -keystore <릴리즈 키 위치> | openssl sha1 -binary | openssl base64


## 플러터 웹 build
flutter build web --web-renderer html --release
# FairRx (student prototype)

Scan a prescription or medicine strip, find the generic name, and compare
real 2021 MRPs of options with the same ingredient and strength.

## Run it
1. Install Flutter (stable) and Android Studio. Run `flutter doctor`.
2. In this folder: `flutter create . --platforms=android` (adds the android/ folder, keeps lib/).
3. In `android/app/build.gradle` (or build.gradle.kts) set `minSdk = 23`.
4. In `android/app/src/main/AndroidManifest.xml` add inside <manifest>:
   `<uses-permission android:name="android.permission.CAMERA"/>`
5. `flutter pub get` then `flutter run` on a phone (the camera needs a real device).
6. Release build: `flutter build apk --release --split-per-abi` (check the size).

## Screens (15)
Splash, Disclaimer, Home, Scan, Scan result, Search, Medicine detail
(with alternatives), History, Reminders, Add reminder, Premium, Settings,
Privacy policy, About, plus the ad banner placeholder.

## Honest limits
- Data: real MRPs from "Pharmaceutical Prices in Pakistan 2021" (Open Data Pakistan, 462 rows). After cleaning, about 250 products are used. The file has no licence stated, so check the reuse rules before a Play Store release. Generic names were parsed by script from a messy column, so some may be wrong.
- Reminders are saved in the app. Phone notifications are the next step
  (flutter_local_notifications).
- Ads and Premium are demo screens. Real revenue needs AdMob and Google Play Billing.
- This code was written without a Flutter compiler in this workspace, so
  run `flutter analyze` and fix any small errors first.

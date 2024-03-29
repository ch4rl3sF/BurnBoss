# BurnBoss

A workout app in which users create their own workouts.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Steps to develop BurnBoss on a new machine:
1. Install Git
2. Install Android Studio
   a. Install Flutter and its dart dependancy
3. Use git clone [https]
4. Open projects in android studio
5. Install Dart sdk
   a. Install Chocolatey
   b. Install Dart sdk
   c. enable dart sdk for project (will be found in C:/tools)
6. Install flutter from the internet
   a. Extract into C:/src/ (create it)
   b. follow the steps in the flutter download page to add the env path (Path > edit > New > C:/src/flutter/bin > Move up to 2nd pos)
7. In android studio, install command line tools (latest) in SDK manager > SDK tools
8. Run flutter doctor --android-licenses and accept them



Colors:
Surface: #121212
   Surface Dim: #0c0c0c
   Surface Container: #292929

Primary: #FF2c14
   Primary Container: #FFA48C
   On Primary Container: #D70000

Secondary: #1DE6C9
   Secondary Container: #0E0F0F
   On Secondary Container: #006D3F


How to develop the APK to push to production:
Using cmd:
 - run: cd C:\src\flutter\bin\flutter.bat
 - run: --no-color build apk

Using Android Studio:
 - At the top, go into build, then flutter, then APK

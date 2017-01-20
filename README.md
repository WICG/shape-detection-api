
# Shape Detection API Specification _:stars:_:movie_camera:

This is the repository for `shape-detection-api`, an experimental API for detecting Shapes (e.g. Faces, Barcodes, Text) in live or still images on the Web by **using accelerated hardware/OS resources**.

You're welcome to contribute! Let's make the Web rock our socks off!

## [Introduction](https://wicg.github.io/shape-detection-api/#introduction) :blue_book:

Photos and images constitute the largest chunk of the Web, and many include recognisable features, such as human faces, text or QR codes. Detecting these features is computationally expensive, but would lead to interesting use cases e.g. face tagging or detection of high saliency areas. Users interacting with WebCams or other Video Capture Devices have become accustomed to camera-like features such as the ability to focus directly on human faces on the screen of their devices. This is particularly true in the case of mobile devices, where hardware manufacturers have long been supporting these features. Unfortunately, Web Apps do not yet have access to these hardware capabilities, which makes the use of computationally demanding libraries necessary.

## Use cases :camera:

QR/barcode/text detection can be used for:
* user identification/registration, e.g. for [voting purposes](https://twitter.com/RegistertoVote/status/733123511128981508);
* eCommerce, e.g. [Walmart Pay](https://www.slashgear.com/awalmart-announces-walmart-pay-for-qr-code-based-mobile-payments-10417912/);
* Augmented Reality overlay, e.g. [here](http://www.multidots.com/augmented-reality/);
* Driving online-to-offline engagement, fighting fakes [etc](https://www.clickz.com/why-have-qr-codes-taken-off-in-china/23662/).

Face detection can be used for:
* producing fun effects, e.g. [Snapchat Lenses](https://support.snapchat.com/en-US/a/lenses1);
* giving hints to encoders or auto focus routines;
* user name tagging;
* enhance accesibility by e.g. making objects appear larger as the user gets closer like [HeadTrackr](https://www.auduno.com/headtrackr/examples/targets.html);
* speeding up Face Recognition by indicating the areas of the image where faces are present.


## Current Related Efforts and Workarounds :wrench:

Some Web Apps -gasp- run Detection in Javascript. A performance comparison of some such libraries can be found [here](https://github.com/mtschirs/js-objectdetect#performance) (note that this performance evaluation does not include e.g. WebCam image acquisition and/or canvas interactions).

Samsung Browser [has a private API](developer.samsung.com/internet) (click to unfold "Overview for Android", then search for "QR code reader").

**TODO**: compare a few JS/native libraries in terms of size and performance.

Android Native Apps usually integrate [ZXing](https://github.com/zxing/zxing) (which amounts to adding ~560KB when counting [core.jar](http://repo1.maven.org/maven2/com/google/zxing/core/3.3.0/), [android-core.jar](http://repo1.maven.org/maven2/com/google/zxing/android-core/3.3.0/) and [android-integration.jar](http://repo1.maven.org/maven2/com/google/zxing/android-integration/3.3.0/))).

OCR reader in Javascript are north of 1MB of size ()

## Potential for misuse :money_with_wings:

Face Detection is an expensive operation due to the algorithmic complexity. Many requests, or demanding systems like a live stream feed with a certain frame rate, could slow down the whole system or greatly increase power consumption.

## Platform specific implementation notes :computer:

## Overview

What platforms support what detector?

Encoder   | Mac| Android | Win10  | Linux   | ChromeOs |
--------- |:--:| :------:| :---:  | :------:| :------: |
Face      | sw | hw/sw   | sw     | &#10008;| &#10008; |
QR/Barcode| sw | sw      |&#10008;| &#10008;| &#10008; |
Text      | sw | sw      | sw     | &#10008;| &#10008; |


### Android

Android provides both a stand alone software face detector and a interface to the hardware ones.

| API           |     uses...     | Release notes  |
| ------------- |:-------------:| -----:|
| [FaceDetector](https://developer.android.com/reference/android/media/FaceDetector)| Software based using the [Neven face detector](https://android.googlesource.com/platform/external/neven)| API Level 1, 2008|
| [Camera2](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest.html#STATISTICS_FACE_DETECT_MODE)| Hardware | API Level 21/Lollipop, 2014 |
| [Camera.Face](https://developer.android.com/reference/android/hardware/Camera.Face.html) (old)| Hardware | API Level 14/Ice Cream Sandwich, 2011 |

The availability of the actual hardware detection depends on the actual chip; according to the market share in [1H 2016](http://www.antutu.com/en/view.shtml?id=8256) Qualcomm, MediaTek, Samsung and HiSilicon are the largest individual OEMs and they all have support for Face Detection (all the top-10 phones are covered as well):
* [Qualcomm Snapdragon](https://developer.qualcomm.com/software/snapdragon-sdk-android/facial-recognition) chipset family supports it since ~2013 as part of their ISP.
* MediaTek as part of [CorePilot 2.0](http://cdn-cw.mediatek.com/White%20Papers/MediaTek_CorePilot%202.0_Final.pdf) (introduced in 2015).
* [Samsung Exynos](http://www.samsung.com/semiconductor/minisite/Exynos/data/Benefits_of_Exynos_5420_ISP_for_Enhanced_Imaging_Experience.pdf) (at least 2013).
* Huawei HiSilicon [Kirin950](http://www.androidauthority.com/huawei-hisilicon-kirin-950-official-653811) since 2015 (this fabless manufacturer is relatively new).
* It is worth noting that ARM [acquired Apical in 2016](https://www.arm.com/products/graphics-and-multimedia/computer-vision) for its computer vision expertise.

Barcode/QR and Text detection is available via Google Play Services [barcode](https://developers.google.com/android/reference/com/google/android/gms/vision/barcode/package-summary) and [text](https://developers.google.com/android/reference/com/google/android/gms/vision/text/package-summary), respectively.

### Mac OS X / iOS

Mac OS X/iOS provides `CIDetector` for Face, QR, Text and Rectangle detection in software.

| API           |     uses...     | Release notes  |
| ------------- |:-------------:| -----:|
| [CIDetector, Mac OS X](https://developer.apple.com/library/mac/documentation/CoreImage/Reference/CIDetector_Ref/)| Software | OS X v10.7, 2011 |
| [CIDetector, iOS](https://developer.apple.com/library/ios/documentation/CoreImage/Reference/CIDetector_Ref/) | Software | iOS v5.0, 2011 |
| [AVFoundation](https://developer.apple.com/reference/avfoundation/avcapturemetadataoutput?language=objc)| Hardware | iOS 6.0, 2012 |

Apple has supported Face Detection in hardware since the [Apple A5 processor](https://en.wikipedia.org/wiki/Apple_A5) introduced in 2011.

### Windows

Windows 10 has a [FaceDetector](https://msdn.microsoft.com/library/windows/apps/dn974129) class and support for Text Detection [OCR](https://msdn.microsoft.com/en-us/library/windows/apps/windows.media.ocr.aspx).

## Rendered URL :bookmark_tabs:

The rendered version of this site can be found in https://wicg.github.io/shape-detection-api (if that's not alive for some reason try the [rawgit rendering](https://rawgit.com/WICG/shape-detection-api/gh-pages/index.html)).

## Examples and demos

Blabla

## Notes on bikeshedding :bicyclist:

To compile, run:

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 > index.html
```

if the produced file has a strange size (i.e. zero), then something went terribly wrong; run instead

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F output=err
```
and try to figure out why `bikeshed` did not like the `.bs` :'(

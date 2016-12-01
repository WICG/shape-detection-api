
# Shape Detection API Specification _:stars:_:movie_camera:

This is the repository for `shape-detection-api`, an experimental API for detecting Shapes (e.g. Faces and other Objects) in live or still images on the Web by **using accelerated hardware**.

You're welcome to contribute! Let's make the Web rock our socks off!

## [Introduction](https://wicg.github.io/shape-detection-api/#introduction) :blue_book:

Photos and images constitute the largest chunk of the Web, and many include recognisable features, such as human faces or QR codes. Detecting these features is computationally expensive, but would lead to interesting use cases e.g. face tagging or detection of high saliency areas. Also, users interacting with WebCams or other Video Capture Devices have become accustomed to camera-like features such as the ability to focus directly on human faces on the screen of their devices. This is particularly true in the case of mobile devices, where hardware manufacturers have long been supporting these features. Unfortunately, Web Apps do not yet have access to these hardware capabilities, which makes the use of computationally demanding libraries necessary.

## Use cases :camera:

* QR/barcode detection can be used for quick user registration, e.g. for [voting purposes](https://twitter.com/RegistertoVote/status/733123511128981508).

* Live video feeds would like to identify faces in a picture/video as highly salient areas to e.g. give hints to image or video encoders.

* Social network pages would like to quickly identify the human faces in a picture/video and offer the user e.g. the possibility of tagging which name corresponds to which face.

* Face detection is the first step before Face Recognition: detected faces are used for the recognition phase, greatly speeding the process.

* Enhance accesibility by e.g. coupling zoom in/out to detected face size.

* Fun! you can map glasses, funny hats and other overlays on top of the detected faces

* QR codes can be used as markers to overlay synthetic Augmented Reality objects (see e.g. [here](http://www.multidots.com/augmented-reality/)).

## Current Related Efforts and Workarounds :wrench:

Some Web Apps -gasp- run Detection in Javascript. A performance comparison of some such libraries can be found [here](https://github.com/mtschirs/js-objectdetect#performance) (note that this performance evaluation does not include e.g. WebCam image acquisition and/or canvas interactions).

Samsung Browser [has a private API](developer.samsung.com/internet) (click to unfold "Overview for Android", then search for "QR code reader").

**TODO**: compare a few JS/native libraries in terms of size and performance.

Android Native Apps usually integrate [ZXing](https://github.com/zxing/zxing) (which amounts to adding ~560KB when counting [core.jar](http://repo1.maven.org/maven2/com/google/zxing/core/3.3.0/), [android-core.jar](http://repo1.maven.org/maven2/com/google/zxing/android-core/3.3.0/) and [android-integration.jar](http://repo1.maven.org/maven2/com/google/zxing/android-integration/3.3.0/))).

## Potential for misuse :money_with_wings:

Face Detection is an expensive operation due to the algorithmic complexity. Many requests, or demanding systems like a live stream feed with a certain frame rate, could slow down the whole system or greatly increase power consumption.

## Platform specific implementation notes :computer:

### Android

Android provides both a stand alone software detector and a hardware based interface to the hardware ones.

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

### Mac OS X / iOS

Mac OS X/iOS provides `CIDetector` for Face, QR, Text and Rectangle detection in software.

| API           |     uses...     | Release notes  |
| ------------- |:-------------:| -----:|
| [CIDetector, Mac OS X](https://developer.apple.com/library/mac/documentation/CoreImage/Reference/CIDetector_Ref/)| Software | OS X v10.7, 2011 |
| [CIDetector, iOS](https://developer.apple.com/library/ios/documentation/CoreImage/Reference/CIDetector_Ref/) | Software | iOS v5.0, 2011 |

### Windows

Windows 10 has a [FaceDetector](https://msdn.microsoft.com/library/windows/apps/dn974129) class

## Rendered URL :bookmark_tabs:

The rendered version of this site can be found in https://wicg.github.io/shape-detection-api (if that's not alive for some reason try the [rawgit rendering](https://rawgit.com/WICG/shape-detection-api/gh-pages/index.html)).

## Examples and demos

Blabla

## Notes on bikeshedding :bicyclist:

To compile, I'm just running

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 > index.html
```

if the produced file has a strange size (i.e. zero), then something went terribly wrong; run instead

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F output=err
```
and try to figure out why `bikeshed` did not like the `.bs` :'(


# Shape Detection API Specification _:stars:_:movie_camera:

This is the repository for `shape-detection-api`, an experimental API for detecting Shapes (e.g. Faces and other Objects) in live or still images on the Web by **using accelerated hardware**.

You're welcome to contribute! Let's make the Web rock our socks off!

## [Introduction](https://wicg.github.io/shape-detection-api/#introduction) :blue_book:

Photos and images constitute the largest chunk of the Web, and many include recognisable features, such as human faces or QR codes. Detecting these features is computationally expensive, but would lead to interesting use cases e.g. face tagging or detection of high saliency areas. Also, users interacting with WebCams or other Video Capture Devices have become accustomed to camera-like features such as the ability to focus directly on human faces on the screen of their devices. This is particularly true in the case of mobile devices, where hardware manufacturers have long been supporting these features. Unfortunately, Web Apps do not yet have access to these hardware capabilities, which makes the use of computationally demanding libraries necessary.

## Use cases :camera:

* Live video feeds would like to identify faces in a picture/video as highly salient areas to e.g. give hints to image or video encoders.

* Social network pages would like to quickly identify the human faces in a picture/video and offer the user e.g. the possibility of tagging which name corresponds to which face.

* Face detection is the first step before Face Recognition: detected faces are used for the recognition phase, greatly speeding the process.

* Fun! you can map glasses, funny hats and other overlays on top of the detected faces

* QR/barcode detection can be used for quick user registration, e.g. for [voting purposes](https://twitter.com/RegistertoVote/status/733123511128981508).

* QR codes can be used as markers to overlay synthetic Augmented Reality objects (see e.g. [here](http://www.multidots.com/augmented-reality/)).

## Current Workarounds :wrench:

Some Web Apps -gasp- run Face Detection in Javascript. A performance comparison of some such libraries can be found [here](https://github.com/mtschirs/js-objectdetect#performance).

## Potential for misuse :money_with_wings:

Face Detection is an expensive operation due to the algorithmic complexity. Many requests, or demanding systems like a live stream feed with a certain frame rate, could slow down the whole system or greatly increase power consumption.

## Platform specific implementation notes :computer:

### Android

Android provides a stand alone `FaceDetector` class. It also has a built-in for detecting on the fly while capturing video or taking photos, as part of the `Camera2`s API.

* [Android FaceDetector](https://developer.android.com/reference/android/media/FaceDetector.html)
* [Camera2 CaptureRequest](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest.html#STATISTICS_FACE_DETECT_MODE)

### Mac OS X / iOS

CoreImage library includes a `CIDetector` class that provides not only Face Detection, but also QR, Text and Rectangles.

* [CIDetector class, Mac OS X](https://developer.apple.com/library/mac/documentation/CoreImage/Reference/CIDetector_Ref/)
* [CIDetector class, iOS](https://developer.apple.com/library/ios/documentation/CoreImage/Reference/CIDetector_Ref/)

## Rendered URL

The rendered version of this site can be found in https://wicg.github.io/shape-detection-api (if that's not alive for some reason try the [rawgit rendering](https://rawgit.com/WICG/shape-detection-api/gh-pages/index.html)).

## Notes on bikeshedding

To compile, I'm just running

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 > index.html
```

if the produced file has a strange size (i.e. zero), then something went terribly wrong; run instead

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F output=err
```
and try to figure out why `bikeshed` did not like the `.bs` :'(

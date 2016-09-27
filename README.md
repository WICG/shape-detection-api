
# Shape Detection API Specification _:stars:_:movie_camera:

This is the repository for `shape-detection-api`, an experimental API for detecting Shapes (e.g. Faces and other Objects) in live or still images on the Web, by using hardware acceleration.

You're welcome to contribute! Let's make the Web rock our socks off!

## Use cases

* Live video feeds would like to identify faces in a picture/video as highly salient areas to e.g. give hints to image or video encoders.

* Social network pages would like to quickly identify the human faces in a picture/video and offer the user e.g. the possibility of tagging which name corresponds to which face.

* Face detection is the first step before Face Recognition: detected faces are used for the recognition phase, greatly speeding the process.

* Fun! you can map glasses, funny hats and other overlays on top of the detected faces

* QR/barcode detection can be used for quick user registration, e.g. for [voting purposes](https://twitter.com/RegistertoVote/status/733123511128981508).

# Rendered URL

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

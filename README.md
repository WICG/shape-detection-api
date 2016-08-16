
# Shape Detection API Specification _:stars:_:movie_camera:

This is the repository for `shape-detection-api`, an experimental API for detecting Shapes (and Faces) in live or still images on the Web, using hardware acceleration.

You're welcome to contribute! Let's make the Web rock our socks off!

The rendered version of this site can be found in https://wicg.github.io/shape-detection-api -- but, if that's not alive for some reason, here https://rawgit.com/WICG/shape-detection-api/master/index.html as well.


## Notes on bikeshedding
To compile, I just run

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F force=1 > index.html
```

if the produced file has a strange size (i.e. zero), then something went terribly wrong; run instead

```
curl https://api.csswg.org/bikeshed/ -F file=@index.bs -F output=err
```
and try to figure out why `bikeshed` did not like the `.bs` :'(

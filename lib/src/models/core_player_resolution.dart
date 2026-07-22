/// Enum representing the different resolutions available for the video.
enum CorePlayerResolution {
  p240,
  p360,
  p480,
  p720,
  p1080;

  @override
  String toString() {
    switch (this) {
      case CorePlayerResolution.p240:
        return '240p';
      case CorePlayerResolution.p360:
        return '360p';
      case CorePlayerResolution.p480:
        return '480p';
      case CorePlayerResolution.p720:
        return '720p';
      case CorePlayerResolution.p1080:
        return '1080p';
    }
  }
}

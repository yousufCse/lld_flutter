// ignore_for_file: avoid_print

// Abstract class defining the media player interface
abstract class MediaPlayer {
  String getName();
  void play();
  void pause();
  void stop();
  bool isPlaying();
  int getDuration();
  int getCurrentPosition();
}

// Real implementation of MediaPlayer
class VideoPlayer implements MediaPlayer {
  final String name;
  bool _isPlaying = false;
  final int _duration;
  int _currentPosition = 0;

  VideoPlayer(this.name, this._duration);

  @override
  String getName() => name;

  @override
  void play() {
    if (!_isPlaying) {
      _isPlaying = true;
      print('[$name] ▶️ Playing video');
    }
  }

  @override
  void pause() {
    if (_isPlaying) {
      _isPlaying = false;
      print('[$name] ⏸️ Video paused');
    }
  }

  @override
  void stop() {
    if (_isPlaying) {
      _isPlaying = false;
      _currentPosition = 0;
      print('[$name] ⏹️ Video stopped');
    }
  }

  @override
  bool isPlaying() => _isPlaying;

  @override
  int getDuration() => _duration;

  @override
  int getCurrentPosition() => _currentPosition;

  // Additional method for this implementation
  void seekTo(int position) {
    if (position >= 0 && position <= _duration) {
      _currentPosition = position;
      print('[$name] Seeking to $position seconds');
    }
  }
}

// Null Object implementation of MediaPlayer
class NullMediaPlayer implements MediaPlayer {
  // Singleton pattern
  static final NullMediaPlayer _instance = NullMediaPlayer._internal();

  NullMediaPlayer._internal();

  factory NullMediaPlayer() => _instance;

  @override
  String getName() => "No Media";

  @override
  void play() {
    print('No media available to play');
  }

  @override
  void pause() {
    print('No media available to pause');
  }

  @override
  void stop() {
    print('No media available to stop');
  }

  @override
  bool isPlaying() => false;

  @override
  int getDuration() => 0;

  @override
  int getCurrentPosition() => 0;
}

// MediaPlayerFactory to create media players
class MediaPlayerFactory {
  static final Map<String, MediaPlayer> _availableMedia = {
    'nature': VideoPlayer('Nature Documentary', 300),
    'tutorial': VideoPlayer('Flutter Tutorial', 600),
    'music': VideoPlayer('Music Video', 240),
  };

  static MediaPlayer getMediaPlayer(String mediaId) {
    // Instead of returning null, return a NullMediaPlayer
    return _availableMedia[mediaId] ?? NullMediaPlayer();
  }
}

// Media Controller class that uses MediaPlayer
class MediaController {
  void playMedia(String mediaId) {
    print('\n--- Attempting to play: $mediaId ---');

    // Get media player without worrying about null
    final MediaPlayer player = MediaPlayerFactory.getMediaPlayer(mediaId);

    // Show media info
    print('Media: ${player.getName()}');
    print('Duration: ${player.getDuration()} seconds');

    // No need for null checks anywhere
    player.play();

    // Display playback status
    String status = player.isPlaying() ? 'Playing' : 'Not playing';
    print('Current status: $status');
  }
}

void main() {
  print(
    '-------------------------------\n| Null Object Pattern Example |\n-------------------------------',
  );

  final mediaController = MediaController();

  // Play existing media
  mediaController.playMedia('nature');
  mediaController.playMedia('tutorial');

  // Attempt to play non-existent media - no null check needed
  mediaController.playMedia('nonexistent');

  print('-------------------------------');
}

class Song {
  final String title;
  final String singer;
  final String url;
  final String? coverImage;

  Song({
    required this.title,
    required this.singer,
    required this.url,
    this.coverImage,
  });
}

class MusicData {
  static List<Song> songs = [
    Song(
      title: "Bohemian Rhapsody",
      singer: "Queen",
      url: "assets/music/bohemian_rhapsody.mp3",
      coverImage:
          "https://c4.wallpaperflare.com/wallpaper/1021/802/327/musicians-freddie-mercury-freddy-mercury-brian-may-roger-taylor-john-deacon-men-queen-music-band-black-background-album-covers-bohemian-rhapsody-wallpaper-preview.jpg",
    ),
    Song(
      title: "Imagine",
      singer: "John Lennon",
      url: "assets/music/imagine.mp3",
      coverImage:
          "https://townsquare.media/site/295/files/2018/03/92397_0.jpg?w=980&q=75",
    ),
    Song(
      title: "Billie Jean",
      singer: "Michael Jackson",
      url: "assets/music/billie_jean.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/5/55/Michael_Jackson_-_Thriller.png?20250318015058",
    ),
    Song(
      title: "Rolling in the Deep",
      singer: "Adele",
      url: "assets/music/rolling_in_the_deep.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/thumb/7/74/Adele_-_Rolling_in_the_Deep.png/250px-Adele_-_Rolling_in_the_Deep.png",
    ),
    Song(
      title: "Shape of You",
      singer: "Ed Sheeran",
      url: "assets/music/shape_of_you.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/thumb/b/b4/Shape_Of_You_%28Official_Single_Cover%29_by_Ed_Sheeran.png/250px-Shape_Of_You_%28Official_Single_Cover%29_by_Ed_Sheeran.png",
    ),
    Song(
      title: "Blinding Lights",
      singer: "The Weeknd",
      url: "assets/music/blinding_lights.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/thumb/e/e6/The_Weeknd_-_Blinding_Lights.png/250px-The_Weeknd_-_Blinding_Lights.png",
    ),
    Song(
      title: "Yellow",
      singer: "Coldplay",
      url: "assets/music/yellow.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/f/fd/Coldplay_-_Parachutes.png",
    ),
    Song(
      title: "Smells Like Teen Spirit",
      singer: "Nirvana",
      url: "assets/music/smells_like_teen_spirit.mp3",
      coverImage:
          "https://cdn-images.dzcdn.net/images/cover/f0282817b697279e56df13909962a54a/500x500.jpg",
    ),
    Song(
      title: "Too Much Heaven",
      singer: "Bee Gees",
      url: "assets/music/too_much_heaven.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/thumb/8/86/Toomuchheaven.jpg/250px-Toomuchheaven.jpg",
    ),
    Song(
      title: "Without Me",
      singer: "Eminem",
      url: "assets/music/without_me.mp3",
      coverImage:
          "https://upload.wikimedia.org/wikipedia/en/thumb/a/ad/Eminem_-_Without_Me_CD_cover.jpg/250px-Eminem_-_Without_Me_CD_cover.jpg",
    ),
  ];
}

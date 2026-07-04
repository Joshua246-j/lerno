class AppAssets {
  // Common paths
  static const String _svgRoot = 'assets/svg';

  // Folders
  static const String iconsFolder = '$_svgRoot/icons';
  static const String avatarsFolder = '$_svgRoot/avatars';
  static const String badgesFolder = '$_svgRoot/badges';
  static const String leagueFolder = '$_svgRoot/league';
  static const String gamesFolder = '$_svgRoot/games';

  // specific icons (from our setup script)
  static const String iconHome = '$iconsFolder/home.svg';
  static const String iconBook = '$iconsFolder/book.svg';
  static const String iconStore = '$iconsFolder/store.svg';
  static const String iconUser = '$iconsFolder/user.svg';
  static const String iconSettings = '$iconsFolder/settings.svg';
  static const String iconStar = '$iconsFolder/star.svg';
  static const String iconAward = '$iconsFolder/award.svg';
  static const String iconCheck = '$iconsFolder/check.svg';
  static const String iconX = '$iconsFolder/x.svg';
  static const String iconChevronRight = '$iconsFolder/chevron-right.svg';
  static const String iconChevronLeft = '$iconsFolder/chevron-left.svg';
  static const String iconPlay = '$iconsFolder/play.svg';
  static const String iconPause = '$iconsFolder/pause.svg';

  // Fallbacks if specific avatar missing
  static const String fallbackAvatar = 'assets/images/avatars/octopus.svg';

  // Helper method to resolve avatar path
  static String getAvatarPath(String id) {
    // Check if it is a starter avatar
    final isStarter = ['robot', 'dinosaur', 'panda', 'fox', 'astronaut', 'octopus', 'wizard', 'penguin', 'dragon'].contains(id);
    if (isStarter) {
      return 'assets/svg/avatars/starter/$id.svg';
    }
    return 'assets/svg/avatars/shop/$id.svg';
  }
}

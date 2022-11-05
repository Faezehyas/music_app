enum BottomBarEnum { Save, Search, Home, Explore, Profile }

int selectBottomBarfromEnum(BottomBarEnum bottomBarEnum) {
  switch (bottomBarEnum) {
    case BottomBarEnum.Save:
      return 0;
    case BottomBarEnum.Search:
      return 1;
    case BottomBarEnum.Home:
      return 2;
    case BottomBarEnum.Explore:
      return 3;
    default:
      return 4;
  }
}

enum MusicQualityEnum { low, high, master }

MusicQualityEnum musicQualityEnumFromString(String quality) {
  switch (quality) {
    case 'LQ':
      return MusicQualityEnum.low;
    case 'HQ':
      return MusicQualityEnum.high;
    case 'MASTER':
      return MusicQualityEnum.master;
    default:
      return MusicQualityEnum.low;
  }
}

String musicQualityEnumToString(MusicQualityEnum musicQualityEnum) {
  switch (musicQualityEnum) {
    case MusicQualityEnum.low:
      return 'LQ';
    case MusicQualityEnum.high:
      return 'HQ';
    case MusicQualityEnum.master:
      return 'MASTER';
    default:
      return 'LQ';
  }
}

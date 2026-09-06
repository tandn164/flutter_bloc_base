sealed class AnnouncementsEvent {
  const AnnouncementsEvent();
}

class AnnouncementsStarted extends AnnouncementsEvent {
  const AnnouncementsStarted();
}

class AnnouncementsRefreshRequested extends AnnouncementsEvent {
  const AnnouncementsRefreshRequested();
}

class AnnouncementsCacheClearRequested extends AnnouncementsEvent {
  const AnnouncementsCacheClearRequested();
}

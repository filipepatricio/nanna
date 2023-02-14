const reasonKey = 'reason';
const badgeCountKey = 'badge_count';

enum BadgeCountReason { briefEntriesUpdated, briefEntrySeenByUser, newBriefPublished }

extension BadgeCountReasonExtension on BadgeCountReason {
  String get value {
    switch (this) {
      case BadgeCountReason.briefEntriesUpdated:
        return "brief_entries_updated";
      case BadgeCountReason.briefEntrySeenByUser:
        return "brief_entry_seen_by_user";
      case BadgeCountReason.newBriefPublished:
        return "new_brief_published";
    }
  }
}

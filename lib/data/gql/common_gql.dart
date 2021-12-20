class CommonGQLModels {
  const CommonGQLModels._();

  static const String topic = '''
    id
    title
    lastUpdatedAt
    owner {
      __typename
      ... on Expert {
        $expert
      }
      ... on Editor {
        $editor
      }
    }
    summaryCards{
      text
    }
    introduction
    highlightedPublishers {
      $publisher
    }
    coverImage {
      publicId
    }
    heroImage {
      publicId
    }
    readingList {
      id
      name
      entries {
        note
        style {
          color
          type
        }
        item {
          __typename
          ... on Article {
            $article
          }
        }
      }
    }
  ''';

  static const String expert = '''
      id
      bio
      name
      avatar {
        publicId
      }
  ''';

  static const String editor = '''
      name
      avatar {
        publicId
      }
  ''';

  static const String publisher = '''
      name
      darkLogo{
        publicId
      }
      lightLogo {
        publicId
      }
  ''';

  static const String article = '''
      sourceUrl
      slug
      note
      id
      author
      title
      strippedTitle
      type
      publicationDate
      timeToRead
      image {
        publicId
      }
      publisher {
        $publisher
      }
  ''';
}

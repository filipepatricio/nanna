class CommonGQLModels {
  const CommonGQLModels._();

  static const String topic = '''
    id
    title
    lastUpdatedAt
    summaryCards{
      text
    }
    introduction
    $highlightedPublishers
    category {
      name
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

  static const String highlightedPublishers = '''
      highlightedPublishers {
        id
        name
        darkLogo{
          publicId
        }
        lightLogo {
          publicId
        }
      }
    ''';

  static const String article = '''
      wordCount
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
        name
        id
        darkLogo{
          publicId
        }
         lightLogo {
          publicId
        }
      }
    ''';
}

class CommonGQLModels {
  const CommonGQLModels._();

  static const String topic = '''
    id
    slug
    title
    url
    strippedTitle
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
      areaOfExpertise
      instagram
      linkedin
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
      darkLogo {
        publicId
      }
      lightLogo {
        publicId
      }
  ''';

  static const String fullArticle = '''
    $article
    text {
      content
      markupLanguage
    }
  ''';

  static const String article = '''
      sourceUrl
      slug
      id
      url
      author
      title
      strippedTitle
      credits
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

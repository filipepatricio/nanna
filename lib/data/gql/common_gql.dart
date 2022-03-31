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
      ... on EditorialTeam {
        $editorialTeam
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
      id
      name
      bio
      avatar {
        publicId
      }
  ''';

  static const String editorialTeam = '''
      name
      bio
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

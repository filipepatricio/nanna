class CommonGQLModels {
  const CommonGQLModels._();

  static const String topicPreview = '''
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
    introduction
    highlightedPublishers {
      $publisher
    }
    coverImage {
      publicId
    }
    heroImage {
      $cloudinaryImage
    }
    entryCount
  ''';

  static const String topic = '''
    $topicPreview
    summaryCards{
      text
    }
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
  ''';

  static const String expert = '''
      id
      bio
      name
      areaOfExpertise
      instagram
      linkedin
      website
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
      hasAudioVersion
      articleImage {
        __typename
        ... on CloudinaryImage {
          $cloudinaryImage
        }
        ... on RemoteImage {
          url
        }
      }
      publisher {
        $publisher
      }
  ''';

  static const String cloudinaryImage = '''
        publicId
        caption
  ''';

  static const String exploreSection = '''
        __typename

        id
        name

        ... on ArticlesExploreArea {
          description
          articles {
            ${CommonGQLModels.article}
          }
        }

        ... on ArticlesListExploreArea {
          description
          articles {
            ${CommonGQLModels.article}
          }
        }

        ... on TopicsExploreArea {
          topics {
            ${CommonGQLModels.topicPreview}
          }
        }

        ... on SmallTopicsExploreArea {
          description
          topics {
            ${CommonGQLModels.topicPreview}
          }
        }

        ... on HighlightedTopicsExploreArea {
          backgroundColor
          description
          topics {
            ${CommonGQLModels.topicPreview}
          }
        }
  ''';
}

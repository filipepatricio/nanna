class MockGraphqlResponses {
  //To create this Strings, just send the request in Insomnia and copy/paste exactly what it returns

  static const topicsFromExpert = '''
{
		"getTopicsFromExpert": [
			{
				"coverImage": {
					"publicId": "covers/Cover_5"
				},
				"heroImage": {
					"publicId": "topics/pizza"
				},
				"highlightedPublishers": [
					{
						"darkLogo": {
							"publicId": "publishers/nyt-black"
						},
						"lightLogo": {
							"publicId": "publishers/nyt-white"
						},
						"name": "New York Times"
					},
					{
						"darkLogo": {
							"publicId": "publishers/bloomberg-black"
						},
						"id": "6ce71073-1cca-47df-bcda-5ced92a22aec",
						"lightLogo": {
							"publicId": "publishers/bloomberg-white"
						},
						"name": "Bloomberg"
					},
					{
						"darkLogo": {
							"publicId": "publishers/ft-black"
						},
						"id": "a833867d-daeb-4bab-a8a1-c66614d0c61c",
						"lightLogo": {
							"publicId": "publishers/ft-white"
						},
						"name": "Financial Times"
					}
				],
				"id": "154dfdf6-ae72-4ea9-b4a5-d61e1782099e",
				"introduction": "Perspiciatis iusto et voluptatem ad.",
				"lastUpdatedAt": "2021-12-15T14:24:22Z",
				"summaryCards": [
					{
						"text": "At qui veniam molestiae nostrum itaque sequi fugiat. Libero quia quia aspernatur. In similique omnis consequatur! Fuga corrupti impedit est beatae quia error officiis repellat."
					}
				],
				"title": "Nestle is unhealthy?"
			}
		]
	}
''';

  static const currentBrief = '''
{
    "currentBrief": {
      "goodbye": {
        "headline": "You’re all _informed_",
        "icon": null,
        "message": "Can't get enough?"
      },
      "greeting": {
        "headline": "**👋 Esteban**, here are the topics of the day",
        "icon": null,
        "message": null
      },
      "id": "b838e020-d4f0-45ac-915b-6f38f579dc19",
      "numberOfTopics": 6,
      "topics": [
        {
          "coverImage": {
            "publicId": "covers/Cover_1"
          },
          "heroImage": {
            "publicId": "topics/cybersecurity"
          },
          "highlightedPublishers": [
            {
              "darkLogo": {
                "publicId": "publishers/the-guardian-black"
              },
              "lightLogo": {
                "publicId": "publishers/the-guardian-white"
              },
              "name": "The Guardian"
            }
          ],
          "id": "240d1455-ccf9-4455-8a0a-b4c4f47a2d8b",
          "introduction": "Ratione tenetur impedit placeat aut molestiae?",
          "lastUpdatedAt": "2021-12-08T12:36:06Z",
          "readingList": {
            "entries": [
              {
                "item": {
                  "__typename": "Article",
                  "author": "Pasquale McGlynn",
                  "id": "e2be8f2d-0a08-4f8e-a346-3c0f608ea073",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-08",
                  "publisher": {
                    "darkLogo": null,
                    "id": "5cbcf693-46cf-4685-b0de-45cacee28cc4",
                    "lightLogo": null,
                    "name": "Euronews"
                  },
                  "slug": "2021-11-08-did-denmark-help-the-us-spy-on-european-leaders",
                  "sourceUrl": "https://www.euronews.com/2021/05/31/did-denmark-help-the-u-s-spy-on-european-leaders",
                  "timeToRead": 6,
                  "title": "Did Denmark help the US spy on European leaders?",
                  "type": "FREE"
                },
                "note": "Et deserunt labore distinctio sunt sed non.",
                "style": {
                  "color": "#F3E5F4",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Ms. Joy Hahn V",
                  "id": "545bc1f6-4e7a-4817-97cc-9c12fff8eb9b",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-24",
                  "publisher": {
                    "darkLogo": null,
                    "id": "d49b75a2-dc67-4596-975d-82304825c53c",
                    "lightLogo": null,
                    "name": "DW"
                  },
                  "slug": "2021-11-24-denmarks-role-in-the-nsa-spying-scandal",
                  "sourceUrl": "https://www.dw.com/en/denmarks-role-in-the-nsa-spying-scandal-dws-emmanuelle-chaze/av-57723050",
                  "timeToRead": 5,
                  "title": "Denmark's role in the NSA spying scandal",
                  "type": "PREMIUM"
                },
                "note": null,
                "style": {
                  "color": "#F2E8E7",
                  "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Baron Johnston",
                  "id": "c9e92d8d-eb70-4b0c-b994-548a5b060dd7",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-12-06",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/the-guardian-black"
                    },
                    "id": "46b95722-61b3-4cd4-b4c2-e9f974b3dffa",
                    "lightLogo": {
                      "publicId": "publishers/the-guardian-white"
                    },
                    "name": "The Guardian"
                  },
                  "slug": "2021-12-06-nsa-files-decoded",
                  "sourceUrl": "https://www.theguardian.com/world/interactive/2013/nov/01/snowden-nsa-files-surveillance-revelations-decoded#section/1",
                  "timeToRead": 7,
                  "title": "NSA files: *Decoded*",
                  "type": "FREE"
                },
                "note": "Illum vel est illum odio repellendus.",
                "style": {
                  "color": "#E4F1E2",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              }
            ],
            "id": "9e413bbf-6fbb-41da-a1ff-41729efef9d4",
            "name": "NSA scandal"
          },
          "summaryCards": [
            {
              "text": "Qui iure a et."
            },
            {
              "text": "Voluptas qui nesciunt suscipit quia eum?"
            },
            {
              "text": "*Laborum maxime* tempore qui nulla natus porro et."
            },
            {
              "text": "Fugit dolorum ~~voluptates~~ nobis."
            },
            {
              "text": "Alias ut *corrupti* maxime ab voluptatem et in qui accusamus?"
            },
            {
              "text": "**Magni perspiciatis enim** architecto numquam neque sed illo voluptas rem."
            },
            {
              "text": "Reprehenderit voluptatibus debitis vel explicabo ipsam libero?"
            },
            {
              "text": "Voluptates laudantium tenetur perferendis dolorem ut vel ducimus."
            },
            {
              "text": "Dolores facere aspernatur est voluptatem."
            }
          ],
          "title": "NSA scandal"
        },
        {
          "coverImage": {
            "publicId": "covers/Cover_2"
          },
          "heroImage": {
            "publicId": "topics/israel"
          },
          "highlightedPublishers": [
            {
              "darkLogo": {
                "publicId": "publishers/nyt-black"
              },
              "lightLogo": {
                "publicId": "publishers/nyt-white"
              },
              "name": "New York Times"
            },
            {
              "darkLogo": {
                "publicId": "publishers/the-economist-black"
              },
              "lightLogo": {
                "publicId": "publishers/the-economist-white"
              },
              "name": "The Economist"
            }
          ],
          "id": "30e75a8c-a0d7-4406-93ea-b8ff9316797d",
          "introduction": "Consequatur ut molestiae non corporis sint blanditiis aut!",
          "lastUpdatedAt": "2021-12-08T11:55:58Z",
          "readingList": {
            "entries": [
              {
                "item": {
                  "__typename": "Article",
                  "author": "Wellington Frami",
                  "id": "7c05f2cb-bacf-4ee1-8b65-d4a40f623862",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-27",
                  "publisher": {
                    "darkLogo": null,
                    "id": "5369b048-fcd8-4935-965c-f9827b4e35f3",
                    "lightLogo": null,
                    "name": "Reuters"
                  },
                  "slug": "2021-11-27-netanyahus-disparate-rivals-try-to-nail-down-pact-to-unseat-him",
                  "sourceUrl": "https://www.reuters.com/world/middle-east/netanyahus-disparate-rivals-try-nail-down-pact-unseat-him-2021-05-31/",
                  "timeToRead": 2,
                  "title": "Netanyahu's disparate rivals try to nail down pact to unseat him",
                  "type": "FREE"
                },
                "note": "Earum voluptas eum inventore fuga.",
                "style": {
                  "color": "#F3E5F4",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Margaret Witting",
                  "id": "417134de-ee19-4a47-a686-fdfb27168c19",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-28",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/the-economist-black"
                    },
                    "lightLogo": {
                      "publicId": "publishers/the-economist-white"
                    },
                    "name": "The Economist"
                  },
                  "slug": "2021-11-28-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu",
                  "sourceUrl": "https://www.economist.com/middle-east-and-africa/2021/05/30/israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu",
                  "timeToRead": 4,
                  "title": "Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu",
                  "type": "PREMIUM"
                },
                "note": null,
                "style": {
                  "color": "#F2E8E7",
                  "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Rosetta Grant",
                  "id": "5377389d-54b7-4c74-983c-4ca4975fc2d1",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-27",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/nyt-black"
                    },
                    "lightLogo": {
                      "publicId": "publishers/nyt-white"
                    },
                    "name": "New York Times"
                  },
                  "slug": "2021-11-27-glum-to-gleeful-israeli-media-react-to-possible-end-of-netanyahu-era",
                  "sourceUrl": "https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html",
                  "timeToRead": 7,
                  "title": "Glum to Gleeful, Israeli Media React to Possible End of Netanyahu Era",
                  "type": "FREE"
                },
                "note": "Est quia perspiciatis incidunt fugiat!",
                "style": {
                  "color": "#E4F1E2",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              }
            ],
            "id": "63197e95-8aa4-4f81-b10f-03957e39a539",
            "name": "End of Netanyahu era?"
          },
          "summaryCards": [
            {
              "text": "Illum doloribus facilis et repellendus."
            }
          ],
          "title": "End of Netanyahu era?"
        },
        {
          "coverImage": {
            "publicId": "covers/Cover_3"
          },
          "heroImage": {
            "publicId": "topics/family"
          },
          "highlightedPublishers": [
            {
              "darkLogo": {
                "publicId": "publishers/nyt-black"
              },
              "lightLogo": {
                "publicId": "publishers/nyt-white"
              },
              "name": "New York Times"
            },
            {
              "darkLogo": {
                "publicId": "publishers/the-economist-black"
              },
              "lightLogo": {
                "publicId": "publishers/the-economist-white"
              },
              "name": "The Economist"
            }
          ],
          "id": "15bb0e97-d2a2-4306-aa33-7f7dd1796768",
          "introduction": "Qui quod rem dolorem qui ut quia?",
          "lastUpdatedAt": "2021-12-08T11:55:58Z",
          "readingList": {
            "entries": [
              {
                "item": {
                  "__typename": "Article",
                  "author": "Dr. Tyrell Walker I",
                  "id": "565a3c51-13bc-4e84-ab55-a93d3a4c6f20",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-18",
                  "publisher": {
                    "darkLogo": null,
                    "id": "e2057289-a571-447d-b31f-2a46e182d3d8",
                    "lightLogo": null,
                    "name": "BBC"
                  },
                  "slug": "2021-11-18-china-allows-three-children-in-major-policy-shift",
                  "sourceUrl": "https://www.bbc.com/news/world-asia-china-57303592",
                  "timeToRead": 6,
                  "title": "China allows three children in major policy shift",
                  "type": "FREE"
                },
                "note": "Incidunt debitis dignissimos quo voluptate praesentium exercitationem?",
                "style": {
                  "color": "#F3E5F4",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Annamae Hackett",
                  "id": "49a63fa9-14f7-4fcd-8b5a-1ca4669bfcc9",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-14",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/nyt-black"
                    },
                    "lightLogo": {
                      "publicId": "publishers/nyt-white"
                    },
                    "name": "New York Times"
                  },
                  "slug": "2021-11-14-from-one-child-to-three-how-chinas-family-planning-policies-have-evolved",
                  "sourceUrl": "https://www.nytimes.com/2021/05/31/world/asia/china-child-policy.html?action=click&module=Top%20Stories&pgtype=Homepage",
                  "timeToRead": 7,
                  "title": "From One Child to Three: How China’s Family Planning Policies Have Evolved",
                  "type": "PREMIUM"
                },
                "note": null,
                "style": {
                  "color": "#F2E8E7",
                  "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Stevie Crooks",
                  "id": "fb86b9ff-ee8b-4fab-bf3f-93ad95e33490",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-09",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/the-economist-black"
                    },
                    "lightLogo": {
                      "publicId": "publishers/the-economist-white"
                    },
                    "name": "The Economist"
                  },
                  "slug": "2021-11-09-is-chinas-population-shrinking",
                  "sourceUrl": "https://www.economist.com/china/2021/04/29/is-chinas-population-shrinking",
                  "timeToRead": 2,
                  "title": "Is China’s population shrinking?",
                  "type": "FREE"
                },
                "note": "Quia doloribus saepe qui et hic!",
                "style": {
                  "color": "#E4F1E2",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              }
            ],
            "id": "8ed95eb1-64d5-41ba-a566-f705b7eca6ed",
            "name": "China demography problem"
          },
          "summaryCards": [
            {
              "text": "Voluptatibus voluptatem fuga eveniet ut sint at suscipit ut!"
            },
            {
              "text": "Amet blanditiis eum animi dolorum."
            },
            {
              "text": "Et vel ut iste distinctio est aut?"
            },
            {
              "text": "Praesentium voluptatum esse veritatis numquam sed ut!"
            },
            {
              "text": "Quia exercitationem eum reprehenderit in neque vero non delectus!"
            },
            {
              "text": "Ut dolores officiis cumque."
            },
            {
              "text": "Sint velit quidem est eos ex quas distinctio labore."
            }
          ],
          "title": "China demography problem"
        },
        {
          "coverImage": {
            "publicId": "covers/Cover_4"
          },
          "heroImage": {
            "publicId": "topics/industry"
          },
          "highlightedPublishers": [
            {
              "darkLogo": {
                "publicId": "publishers/ft-black"
              },
              "id": "0d86f672-4ecc-4e9e-a70e-e13a219e9624",
              "lightLogo": {
                "publicId": "publishers/ft-white"
              },
              "name": "Financial Times"
            }
          ],
          "id": "1f4fa332-952d-4573-ad55-ff68123c50f6",
          "introduction": "Vel omnis culpa in provident!",
          "lastUpdatedAt": "2021-12-08T11:55:58Z",
          "readingList": {
            "entries": [
              {
                "item": {
                  "__typename": "Article",
                  "author": "Gregoria Hoeger Jr.",
                  "id": "df68019e-ac0c-4949-9671-21f773bbd873",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-22",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/ft-black"
                    },
                    "id": "0d86f672-4ecc-4e9e-a70e-e13a219e9624",
                    "lightLogo": {
                      "publicId": "publishers/ft-white"
                    },
                    "name": "Financial Times"
                  },
                  "slug": "2021-11-22-who-will-pay-europes-bold-plan-on-emissions-risks-political-blowback",
                  "sourceUrl": "https://www.ft.com/content/a4e3791b-9d9e-4bf9-ae74-fe1cf1980625",
                  "timeToRead": 2,
                  "title": "Who will pay? Europe’s bold plan on emissions risks political blowback",
                  "type": "FREE"
                },
                "note": "Qui et nam quis minima totam eum tenetur odit consequatur.",
                "style": {
                  "color": "#F3E5F4",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Yoshiko Terry",
                  "id": "3a209584-4ffe-4b28-bb67-484570edffb8",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-16",
                  "publisher": {
                    "darkLogo": null,
                    "id": "ac88b910-ea2d-4512-8069-a8739f949b52",
                    "lightLogo": null,
                    "name": "Vox"
                  },
                  "slug": "2021-11-16-the-5-most-important-questions-about-carbon-taxes-answered",
                  "sourceUrl": "https://www.vox.com/energy-and-environment/2018/7/20/17584376/carbon-tax-congress-republicans-cost-economy",
                  "timeToRead": 4,
                  "title": "The 5 most important questions about *carbon taxes*, answered",
                  "type": "PREMIUM"
                },
                "note": null,
                "style": {
                  "color": "#F2E8E7",
                  "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Willa Zemlak",
                  "id": "2d7f5caa-10ef-427a-b5bc-8f29a8ca3ae9",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-22",
                  "publisher": {
                    "darkLogo": null,
                    "id": "5369b048-fcd8-4935-965c-f9827b4e35f3",
                    "lightLogo": null,
                    "name": "Reuters"
                  },
                  "slug": "2021-11-22-carbon-pricing-markets-taxes-or-regulation",
                  "sourceUrl": "https://www.reuters.com/business/energy/carbon-pricing-markets-taxes-or-regulation-kemp-2021-05-07/",
                  "timeToRead": 4,
                  "title": "Carbon pricing - markets, taxes or *regulation*?",
                  "type": "FREE"
                },
                "note": "Accusantium et deleniti voluptas et voluptatibus sit cupiditate.",
                "style": {
                  "color": "#E4F1E2",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              }
            ],
            "id": "46e9179d-3b99-454d-8ffc-e8786e50c910",
            "name": "EU's plans on CO2 pricing"
          },
          "summaryCards": [
            {
              "text": "Vel doloribus ut voluptatem eius consequuntur dolores molestiae saepe occaecati."
            },
            {
              "text": "Adipisci ut vero ex qui mollitia enim nemo dolores distinctio."
            },
            {
              "text": "Debitis porro nisi sunt molestias ipsum id!"
            },
            {
              "text": "Minus rerum accusantium qui rerum eligendi."
            },
            {
              "text": "Voluptate nam et ab ab fugiat cupiditate ipsam est et?"
            },
            {
              "text": "Et natus et assumenda tempora autem optio hic quia voluptates."
            },
            {
              "text": "Atque labore non impedit omnis et!"
            },
            {
              "text": "Culpa quia voluptatibus impedit eos quis rerum numquam?"
            },
            {
              "text": "Vel provident aspernatur quia sequi repellendus."
            },
            {
              "text": "Quo consequuntur libero maiores."
            }
          ],
          "title": "EU's plans on CO2 pricing"
        },
        {
          "coverImage": {
            "publicId": "covers/Cover_5"
          },
          "heroImage": {
            "publicId": "topics/pizza"
          },
          "highlightedPublishers": [
            {
              "darkLogo": {
                "publicId": "publishers/bloomberg-black"
              },
              "id": "09948646-e0d2-4f08-9581-e860c7a6a90f",
              "lightLogo": {
                "publicId": "publishers/bloomberg-white"
              },
              "name": "Bloomberg"
            },
            {
              "darkLogo": {
                "publicId": "publishers/ft-black"
              },
              "id": "0d86f672-4ecc-4e9e-a70e-e13a219e9624",
              "lightLogo": {
                "publicId": "publishers/ft-white"
              },
              "name": "Financial Times"
            },
            {
              "darkLogo": {
                "publicId": "publishers/nyt-black"
              },
              "lightLogo": {
                "publicId": "publishers/nyt-white"
              },
              "name": "New York Times"
            }
          ],
          "id": "09ea12f6-1f2a-41bb-9337-227b5b26d62c",
          "introduction": "Dicta quibusdam enim in natus eveniet!",
          "lastUpdatedAt": "2021-12-08T11:55:58Z",
          "readingList": {
            "entries": [
              {
                "item": {
                  "__typename": "Article",
                  "author": "Valentina Lakin DVM",
                  "id": "d19a2f8b-7478-420e-85d3-4125b5f14d7c",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-16",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/ft-black"
                    },
                    "id": "0d86f672-4ecc-4e9e-a70e-e13a219e9624",
                    "lightLogo": {
                      "publicId": "publishers/ft-white"
                    },
                    "name": "Financial Times"
                  },
                  "slug": "2021-11-16-nestle-document-says-majority-of-its-food-portfolio-is-unhealthy",
                  "sourceUrl": "https://www.ft.com/content/4c98d410-38b1-4be8-95b2-d029e054f492",
                  "timeToRead": 4,
                  "title": "Nestlé document says majority of its food portfolio is unhealthy",
                  "type": "FREE"
                },
                "note": "Est est nemo qui consequatur repudiandae quia vel.",
                "style": {
                  "color": "#F3E5F4",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Miss Laurie Corwin Sr.",
                  "id": "6876dbd0-8788-4ea9-b57e-36398fa92f5d",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-30",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/bloomberg-black"
                    },
                    "id": "09948646-e0d2-4f08-9581-e860c7a6a90f",
                    "lightLogo": {
                      "publicId": "publishers/bloomberg-white"
                    },
                    "name": "Bloomberg"
                  },
                  "slug": "2021-11-30-nestle-eyes-strategy-update-amid-criticism-of-unhealthy-products",
                  "sourceUrl": "https://www.bloomberg.com/news/articles/2021-06-01/nestle-eyes-strategy-update-amid-criticism-of-unhealthy-products?srnd=markets-vp",
                  "timeToRead": 8,
                  "title": "Nestle Eyes Strategy Update Amid Criticism of Unhealthy Products",
                  "type": "PREMIUM"
                },
                "note": null,
                "style": {
                  "color": "#F2E8E7",
                  "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Miss Zoie Langworth",
                  "id": "a1658690-55a2-41ca-b536-7237ec66f14f",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-22",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/nyt-black"
                    },
                    "lightLogo": {
                      "publicId": "publishers/nyt-white"
                    },
                    "name": "New York Times"
                  },
                  "slug": "2021-11-22-the-big-money-is-going-vegan",
                  "sourceUrl": "https://www.nytimes.com/2021/05/18/business/oatly-ipo-milk-substitutes.html",
                  "timeToRead": 8,
                  "title": "The Big Money Is Going Vegan",
                  "type": "FREE"
                },
                "note": "Ipsam dolor id sed dolores natus quaerat omnis sequi.",
                "style": {
                  "color": "#E4F1E2",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              }
            ],
            "id": "823b8173-8df6-472b-96af-db4269e3febe",
            "name": "Nestle is unhealthy?"
          },
          "summaryCards": [
            {
              "text": "Dolorem autem et quo nam porro quasi?"
            },
            {
              "text": "Quaerat recusandae eum est?"
            },
            {
              "text": "Inventore et mollitia totam!"
            }
          ],
          "title": "Nestle is unhealthy?"
        },
        {
          "coverImage": {
            "publicId": "covers/Cover_6"
          },
          "heroImage": {
            "publicId": "topics/lab"
          },
          "highlightedPublishers": [
            {
              "darkLogo": {
                "publicId": "publishers/nyt-black"
              },
              "lightLogo": {
                "publicId": "publishers/nyt-white"
              },
              "name": "New York Times"
            }
          ],
          "id": "18c664f9-9673-4f29-9877-9c318f1b32be",
          "introduction": "Fugit atque rerum officia nihil voluptate quo.",
          "lastUpdatedAt": "2021-12-08T11:55:58Z",
          "readingList": {
            "entries": [
              {
                "item": {
                  "__typename": "Article",
                  "author": "Rico Batz",
                  "id": "ec95e220-4497-47d2-b706-c61d0ea882a3",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-12-01",
                  "publisher": {
                    "darkLogo": null,
                    "id": "5cbcf693-46cf-4685-b0de-45cacee28cc4",
                    "lightLogo": null,
                    "name": "Euronews"
                  },
                  "slug": "2021-12-01-who-renames-covid-variants-to-non-stigmatising-letters-of-greek-alphabet",
                  "sourceUrl": "https://www.euronews.com/2021/06/01/who-renames-covid-variants-to-non-stigmatising-letters-of-greek-alphabet",
                  "timeToRead": 8,
                  "title": "WHO renames COVID variants to 'non-stigmatising' letters of Greek alphabet",
                  "type": "FREE"
                },
                "note": "Dicta earum ab molestias et.",
                "style": {
                  "color": "#F3E5F4",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Jaden Thompson",
                  "id": "132f66ee-da17-496f-ae52-a55402a98404",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-11-09",
                  "publisher": {
                    "darkLogo": {
                      "publicId": "publishers/nyt-black"
                    },
                    "lightLogo": {
                      "publicId": "publishers/nyt-white"
                    },
                    "name": "New York Times"
                  },
                  "slug": "2021-11-09-coronavirus-variants-and-mutations",
                  "sourceUrl": "https://www.nytimes.com/interactive/2021/health/coronavirus-variant-tracker.html",
                  "timeToRead": 9,
                  "title": "Coronavirus Variants and Mutations",
                  "type": "PREMIUM"
                },
                "note": null,
                "style": {
                  "color": "#F2E8E7",
                  "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
                }
              },
              {
                "item": {
                  "__typename": "Article",
                  "author": "Emma Flatley",
                  "id": "6d034dbc-8112-4da5-9c2a-52dbe4486529",
                  "image": {
                    "publicId": "articles/storm"
                  },
                  "publicationDate": "2021-12-06",
                  "publisher": {
                    "darkLogo": null,
                    "id": "d14b467c-19f8-499c-86e5-04f37bf17031",
                    "lightLogo": null,
                    "name": "AP News"
                  },
                  "slug": "2021-12-06-bye-alpha-eta-greek-alphabet-ditched-for-hurricane-names",
                  "sourceUrl": "https://apnews.com/article/no-greek-alphabet-hurricane-names-b504a7326955bb171530777c140103e2",
                  "timeToRead": 4,
                  "title": "Bye Alpha, Eta: Greek alphabet ditched for hurricane names",
                  "type": "FREE"
                },
                "note": "Illo qui enim ipsa unde.",
                "style": {
                  "color": "#E4F1E2",
                  "type": "ARTICLE_COVER_WITH_SMALL_IMAGE"
                }
              }
            ],
            "id": "f7195fb5-84f3-4d3a-9168-32f7276e0b99",
            "name": "COVID-variant names"
          },
          "summaryCards": [
            {
              "text": "Praesentium repellendus consequatur quibusdam fugiat sit eligendi sunt."
            },
            {
              "text": "Qui doloremque alias corporis consequuntur quisquam dicta voluptatum."
            },
            {
              "text": "Ullam ducimus corrupti iusto dolor voluptatibus perferendis eos!"
            },
            {
              "text": "Amet animi maiores qui sit aut aliquid!"
            },
            {
              "text": "Officia perspiciatis ad enim maxime ducimus."
            },
            {
              "text": "Perspiciatis velit magni modi enim praesentium non veniam ullam!"
            },
            {
              "text": "Asperiores id illo voluptas ut illum animi eum facere dolorum."
            },
            {
              "text": "Et reprehenderit occaecati itaque consequatur reprehenderit a debitis ullam non."
            },
            {
              "text": "Deserunt fugiat sequi qui quis aspernatur rerum pariatur?"
            },
            {
              "text": "Voluptatem temporibus qui commodi commodi quasi doloribus ut tempora reprehenderit."
            }
          ],
          "title": "COVID-variant names"
        }
      ]
    }
  }
''';
}

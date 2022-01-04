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
				"headline": "**👋 Moritz**, here are the topics of the day",
				"icon": null,
				"message": null
			},
			"id": "49b8669a-ebd2-4cfb-b473-f1d5a563e479",
			"numberOfTopics": 6,
			"topics": [
				{
					"category": null,
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
							"id": "7768da13-47c1-4907-9264-abc0aca796aa",
							"lightLogo": {
								"publicId": "publishers/the-guardian-white"
							},
							"name": "The Guardian"
						}
					],
					"id": "1e55abe0-d711-44b4-a37c-7e1a279b439a",
					"introduction": "Molestiae quisquam unde similique molestiae doloremque est.",
					"lastUpdatedAt": "2021-12-23T11:38:26Z",
					"owner": {
						"__typename": "Editor",
						"avatar": null,
						"name": "Editorial Team"
					},
					"readingList": {
						"entries": [
							{
								"item": {
									"__typename": "Article",
									"author": "Beverly Mraz II",
									"id": "ea61ec88-d656-456e-84a7-78705cb6c095",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-21",
									"publisher": {
										"darkLogo": null,
										"id": "b4611ce6-d96d-449c-afac-a6059bb38f10",
										"lightLogo": null,
										"name": "Euronews"
									},
									"slug": "2021-12-21-did-denmark-help-the-us-spy-on-european-leaders",
									"sourceUrl": "https://www.euronews.com/2021/05/31/did-denmark-help-the-u-s-spy-on-european-leaders",
									"strippedTitle": "Did Denmark help the US spy on European leaders?",
									"timeToRead": 7,
									"title": "Did Denmark help the US spy on European leaders?",
									"type": "FREE",
									"wordCount": 1862
								},
								"note": "Adipisci impedit sunt ut dolorem est beatae quia accusamus qui.",
								"style": {
									"color": "#F3E5F4",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							},
							{
								"item": {
									"__typename": "Article",
									"author": "Cassandre Lueilwitz",
									"id": "ec9dc456-5d62-4277-9dea-9b0639529468",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-03",
									"publisher": {
										"darkLogo": null,
										"id": "ab82cc55-1e35-4dca-abfc-8ef90aef25af",
										"lightLogo": null,
										"name": "DW"
									},
									"slug": "2021-12-03-denmarks-role-in-the-nsa-spying-scandal",
									"sourceUrl": "https://www.dw.com/en/denmarks-role-in-the-nsa-spying-scandal-dws-emmanuelle-chaze/av-57723050",
									"strippedTitle": "Denmark's role in the NSA spying scandal",
									"timeToRead": 10,
									"title": "Denmark's role in the NSA spying scandal",
									"type": "PREMIUM",
									"wordCount": 2426
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
									"author": "Piper Ankunding II",
									"id": "c3cb4ac3-5bae-40dd-b29b-d855b8b343ba",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-13",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/the-guardian-black"
										},
										"id": "7768da13-47c1-4907-9264-abc0aca796aa",
										"lightLogo": {
											"publicId": "publishers/the-guardian-white"
										},
										"name": "The Guardian"
									},
									"slug": "2021-12-13-nsa-files-decoded",
									"sourceUrl": "https://www.theguardian.com/world/interactive/2013/nov/01/snowden-nsa-files-surveillance-revelations-decoded#section/1",
									"strippedTitle": "NSA files: Decoded",
									"timeToRead": 5,
									"title": "NSA files: Decoded",
									"type": "FREE",
									"wordCount": 1166
								},
								"note": "Ut non consequuntur cumque.",
								"style": {
									"color": "#E4F1E2",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							}
						],
						"id": "88afff48-ff28-47ba-9793-a307d98df5f8",
						"name": "NSA scandal"
					},
					"summaryCards": [
						{
							"text": "Accusamus atque libero consequatur voluptas recusandae! Omnis eius nemo sed aliquid! Iure minima quis aut vel. Asperiores enim voluptas in rerum eaque dolores odio."
						}
					],
					"title": "NSA scandal"
				},
				{
					"category": null,
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
							"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
							"lightLogo": {
								"publicId": "publishers/nyt-white"
							},
							"name": "New York Times"
						},
						{
							"darkLogo": {
								"publicId": "publishers/the-economist-black"
							},
							"id": "b5ddeb29-6635-4334-a191-024e50078d13",
							"lightLogo": {
								"publicId": "publishers/the-economist-white"
							},
							"name": "The Economist"
						}
					],
					"id": "04311be4-53a1-4680-927b-997ec91ea775",
					"introduction": "Provident veritatis non fugit velit error hic dolorum facilis quia.",
					"lastUpdatedAt": "2021-12-23T11:38:26Z",
					"owner": {
						"__typename": "Editor",
						"avatar": null,
						"name": "Editorial Team"
					},
					"readingList": {
						"entries": [
							{
								"item": {
									"__typename": "Article",
									"author": "Krista Trantow",
									"id": "65563b8e-74a2-4617-abc6-9ba77aa5d09a",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-05",
									"publisher": {
										"darkLogo": null,
										"id": "a58eb760-c093-413b-8694-68bf37c21f41",
										"lightLogo": null,
										"name": "Reuters"
									},
									"slug": "2021-12-05-netanyahus-disparate-rivals-try-to-nail-down-pact-to-unseat-him",
									"sourceUrl": "https://www.reuters.com/world/middle-east/netanyahus-disparate-rivals-try-nail-down-pact-unseat-him-2021-05-31/",
									"strippedTitle": "Netanyahu's disparate rivals try to nail down pact to unseat him",
									"timeToRead": 5,
									"title": "Netanyahu's disparate rivals try to nail down pact to unseat him",
									"type": "FREE",
									"wordCount": 1339
								},
								"note": "Nihil voluptatibus incidunt est aut est commodi sapiente!",
								"style": {
									"color": "#F3E5F4",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							},
							{
								"item": {
									"__typename": "Article",
									"author": "Hollis Abshire",
									"id": "1bffe35d-fd14-4fac-a3fe-63fa9be51c9a",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-07",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/the-economist-black"
										},
										"id": "b5ddeb29-6635-4334-a191-024e50078d13",
										"lightLogo": {
											"publicId": "publishers/the-economist-white"
										},
										"name": "The Economist"
									},
									"slug": "2021-12-07-israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu",
									"sourceUrl": "https://www.economist.com/middle-east-and-africa/2021/05/30/israels-opposition-has-finally-mustered-a-majority-to-dislodge-binyamin-netanyahu",
									"strippedTitle": "Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu",
									"timeToRead": 6,
									"title": "Israel’s opposition has finally mustered a majority to dislodge Binyamin Netanyahu",
									"type": "PREMIUM",
									"wordCount": 1612
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
									"author": "Hoyt Baumbach",
									"id": "3ca86bcf-a681-4a4a-b382-bb0c97795a0d",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-14",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/nyt-black"
										},
										"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
										"lightLogo": {
											"publicId": "publishers/nyt-white"
										},
										"name": "New York Times"
									},
									"slug": "2021-12-14-glum-to-gleeful-israeli-media-react-to-possible-end-of-netanyahu-era",
									"sourceUrl": "https://www.nytimes.com/2021/05/31/world/middleeast/israeli-media-netanyahu-bennett.html",
									"strippedTitle": "Glum to Gleeful, Israeli Media React to Possible End of Netanyahu Era",
									"timeToRead": 7,
									"title": "Glum to Gleeful, Israeli Media React to Possible End of Netanyahu Era",
									"type": "FREE",
									"wordCount": 1689
								},
								"note": "Vel repellat alias ut.",
								"style": {
									"color": "#E4F1E2",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							}
						],
						"id": "b30f27c2-1ae7-4ef9-997c-980ec1941d49",
						"name": "End of Netanyahu era?"
					},
					"summaryCards": [
						{
							"text": "Eveniet voluptate officia ullam? Et architecto tempora fuga? Sit omnis fugiat dolorum quaerat! Natus harum rerum provident qui provident deserunt nobis ullam?"
						}
					],
					"title": "End of Netanyahu era?"
				},
				{
					"category": null,
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
							"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
							"lightLogo": {
								"publicId": "publishers/nyt-white"
							},
							"name": "New York Times"
						},
						{
							"darkLogo": {
								"publicId": "publishers/the-economist-black"
							},
							"id": "b5ddeb29-6635-4334-a191-024e50078d13",
							"lightLogo": {
								"publicId": "publishers/the-economist-white"
							},
							"name": "The Economist"
						}
					],
					"id": "c4182ab6-6be4-4e00-8cc6-fe2a836236d4",
					"introduction": "Molestias doloribus saepe ipsum ea repellat.",
					"lastUpdatedAt": "2021-12-23T11:38:26Z",
					"owner": {
						"__typename": "Editor",
						"avatar": null,
						"name": "Editorial Team"
					},
					"readingList": {
						"entries": [
							{
								"item": {
									"__typename": "Article",
									"author": "Brady Runolfsson",
									"id": "a613a8b2-7d8a-4526-bbdc-00802b000913",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-15",
									"publisher": {
										"darkLogo": null,
										"id": "72357ccf-13d4-4552-a320-ccb4eeaa899f",
										"lightLogo": null,
										"name": "BBC"
									},
									"slug": "2021-12-15-china-allows-three-children-in-major-policy-shift",
									"sourceUrl": "https://www.bbc.com/news/world-asia-china-57303592",
									"strippedTitle": "China allows three children in major policy shift",
									"timeToRead": 8,
									"title": "China allows three children in major policy shift",
									"type": "FREE",
									"wordCount": 1906
								},
								"note": "Dolorem commodi consequatur consequatur suscipit iusto laboriosam voluptas!",
								"style": {
									"color": "#F3E5F4",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							},
							{
								"item": {
									"__typename": "Article",
									"author": "Kade Bednar",
									"id": "77f8fd75-9807-4165-a314-636768c83da4",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-11-29",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/nyt-black"
										},
										"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
										"lightLogo": {
											"publicId": "publishers/nyt-white"
										},
										"name": "New York Times"
									},
									"slug": "2021-11-29-from-one-child-to-three-how-chinas-family-planning-policies-have-evolved",
									"sourceUrl": "https://www.nytimes.com/2021/05/31/world/asia/china-child-policy.html?action=click&module=Top%20Stories&pgtype=Homepage",
									"strippedTitle": "From One Child to Three: How China’s Family Planning Policies Have Evolved",
									"timeToRead": 9,
									"title": "From One Child to Three: How China’s Family Planning Policies Have Evolved",
									"type": "PREMIUM",
									"wordCount": 2157
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
									"author": "Freida Jenkins",
									"id": "965e17c0-cb7d-4ce8-a8ff-0c533cf81209",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-11-24",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/the-economist-black"
										},
										"id": "b5ddeb29-6635-4334-a191-024e50078d13",
										"lightLogo": {
											"publicId": "publishers/the-economist-white"
										},
										"name": "The Economist"
									},
									"slug": "2021-11-24-is-chinas-population-shrinking",
									"sourceUrl": "https://www.economist.com/china/2021/04/29/is-chinas-population-shrinking",
									"strippedTitle": "Is China’s population shrinking?",
									"timeToRead": 3,
									"title": "Is China’s population shrinking?",
									"type": "FREE",
									"wordCount": 856
								},
								"note": "Et itaque dolores nihil.",
								"style": {
									"color": "#E4F1E2",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							}
						],
						"id": "9bae7452-3b0d-4ecb-ba75-0ad9e5b97563",
						"name": "China demography problem"
					},
					"summaryCards": [
						{
							"text": "Et voluptatem sed consequatur voluptatem! Sequi qui ducimus vero? Harum ut voluptates qui delectus nostrum est illum suscipit quos. Porro odio magnam libero ut excepturi repellat impedit sit et."
						}
					],
					"title": "China demography problem"
				},
				{
					"category": null,
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
							"id": "29617abf-dee3-47a4-a2f0-44fd60c3a157",
							"lightLogo": {
								"publicId": "publishers/ft-white"
							},
							"name": "Financial Times"
						}
					],
					"id": "b5d36664-720b-4966-89fb-3166ef3bcd84",
					"introduction": "Nobis fugit veritatis delectus deserunt debitis est.",
					"lastUpdatedAt": "2021-12-23T11:38:26Z",
					"owner": {
						"__typename": "Editor",
						"avatar": null,
						"name": "Editorial Team"
					},
					"readingList": {
						"entries": [
							{
								"item": {
									"__typename": "Article",
									"author": "Agustin Friesen",
									"id": "685d5e0c-bf17-48e9-8dca-40d8ceb12641",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-13",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/ft-black"
										},
										"id": "29617abf-dee3-47a4-a2f0-44fd60c3a157",
										"lightLogo": {
											"publicId": "publishers/ft-white"
										},
										"name": "Financial Times"
									},
									"slug": "2021-12-13-who-will-pay-europes-bold-plan-on-emissions-risks-political-blowback",
									"sourceUrl": "https://www.ft.com/content/a4e3791b-9d9e-4bf9-ae74-fe1cf1980625",
									"strippedTitle": "Who will pay? Europe’s bold plan on emissions risks political blowback",
									"timeToRead": 2,
									"title": "Who will pay? Europe’s bold plan on emissions risks political blowback",
									"type": "FREE",
									"wordCount": 559
								},
								"note": "Adipisci est est at excepturi nobis quas voluptatem!",
								"style": {
									"color": "#F3E5F4",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							},
							{
								"item": {
									"__typename": "Article",
									"author": "Marlene Rosenbaum",
									"id": "605fae86-fe0b-47a8-a2b9-c5f71745b3dd",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-07",
									"publisher": {
										"darkLogo": null,
										"id": "2c47ab82-fcdb-4216-ac84-96e57b462a5d",
										"lightLogo": null,
										"name": "Vox"
									},
									"slug": "2021-12-07-the-5-most-important-questions-about-carbon-taxes-answered",
									"sourceUrl": "https://www.vox.com/energy-and-environment/2018/7/20/17584376/carbon-tax-congress-republicans-cost-economy",
									"strippedTitle": "The 5 most important questions about carbon taxes, answered",
									"timeToRead": 6,
									"title": "The 5 most important questions about carbon taxes, answered",
									"type": "PREMIUM",
									"wordCount": 1519
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
									"author": "Elwin Fay",
									"id": "f95edaf8-753c-4f77-830a-634c3af3a707",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-01",
									"publisher": {
										"darkLogo": null,
										"id": "a58eb760-c093-413b-8694-68bf37c21f41",
										"lightLogo": null,
										"name": "Reuters"
									},
									"slug": "2021-12-01-carbon-pricing-markets-taxes-or-regulation",
									"sourceUrl": "https://www.reuters.com/business/energy/carbon-pricing-markets-taxes-or-regulation-kemp-2021-05-07/",
									"strippedTitle": "Carbon pricing - markets, taxes or regulation?",
									"timeToRead": 6,
									"title": "Carbon pricing - markets, taxes or regulation?",
									"type": "FREE",
									"wordCount": 1473
								},
								"note": "Hic sapiente consequatur officia porro sapiente veniam fugit rem.",
								"style": {
									"color": "#E4F1E2",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							}
						],
						"id": "254a5c81-402a-4684-a77f-8afb1c1b31c1",
						"name": "EU's plans on CO2 pricing"
					},
					"summaryCards": [
						{
							"text": "Nisi vel doloribus odit eaque qui cupiditate. Sunt aut odio sed nisi numquam ut! Qui et porro architecto tempore ut ut ea. Impedit autem iusto non fugit recusandae magnam velit!"
						}
					],
					"title": "EU's plans on CO2 pricing"
				},
				{
					"category": null,
					"coverImage": {
						"publicId": "covers/Cover_5"
					},
					"heroImage": {
						"publicId": "topics/pizza"
					},
					"highlightedPublishers": [
						{
							"darkLogo": {
								"publicId": "publishers/ft-black"
							},
							"id": "29617abf-dee3-47a4-a2f0-44fd60c3a157",
							"lightLogo": {
								"publicId": "publishers/ft-white"
							},
							"name": "Financial Times"
						},
						{
							"darkLogo": {
								"publicId": "publishers/nyt-black"
							},
							"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
							"lightLogo": {
								"publicId": "publishers/nyt-white"
							},
							"name": "New York Times"
						},
						{
							"darkLogo": {
								"publicId": "publishers/bloomberg-black"
							},
							"id": "7f05249a-88de-4cf2-83ca-dc8a70442d4c",
							"lightLogo": {
								"publicId": "publishers/bloomberg-white"
							},
							"name": "Bloomberg"
						}
					],
					"id": "f1cf66d5-4737-429d-b34f-844f97243b99",
					"introduction": "Sunt facilis quod doloribus dignissimos qui maiores molestiae cumque.",
					"lastUpdatedAt": "2021-12-23T11:38:26Z",
					"owner": {
						"__typename": "Editor",
						"avatar": null,
						"name": "Editorial Team"
					},
					"readingList": {
						"entries": [
							{
								"item": {
									"__typename": "Article",
									"author": "Darwin Bailey",
									"id": "2efa75c4-729b-4783-925e-e5357ee03988",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-10",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/ft-black"
										},
										"id": "29617abf-dee3-47a4-a2f0-44fd60c3a157",
										"lightLogo": {
											"publicId": "publishers/ft-white"
										},
										"name": "Financial Times"
									},
									"slug": "2021-12-10-nestle-document-says-majority-of-its-food-portfolio-is-unhealthy",
									"sourceUrl": "https://www.ft.com/content/4c98d410-38b1-4be8-95b2-d029e054f492",
									"strippedTitle": "Nestlé document says majority of its food portfolio is unhealthy",
									"timeToRead": 6,
									"title": "Nestlé document says majority of its food portfolio is unhealthy",
									"type": "FREE",
									"wordCount": 1596
								},
								"note": "Animi ipsum ea accusantium.",
								"style": {
									"color": "#F3E5F4",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							},
							{
								"item": {
									"__typename": "Article",
									"author": "Chaya Cassin",
									"id": "d211ecac-9f17-44b5-9a7d-12028d811daa",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-05",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/bloomberg-black"
										},
										"id": "7f05249a-88de-4cf2-83ca-dc8a70442d4c",
										"lightLogo": {
											"publicId": "publishers/bloomberg-white"
										},
										"name": "Bloomberg"
									},
									"slug": "2021-12-05-nestle-eyes-strategy-update-amid-criticism-of-unhealthy-products",
									"sourceUrl": "https://www.bloomberg.com/news/articles/2021-06-01/nestle-eyes-strategy-update-amid-criticism-of-unhealthy-products?srnd=markets-vp",
									"strippedTitle": "Nestle Eyes Strategy Update Amid Criticism of Unhealthy Products",
									"timeToRead": 10,
									"title": "Nestle Eyes Strategy Update Amid Criticism of Unhealthy Products",
									"type": "PREMIUM",
									"wordCount": 2401
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
									"author": "Hazle Becker",
									"id": "1465716a-d67c-4ac9-aabc-f901f3e0240c",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-01",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/nyt-black"
										},
										"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
										"lightLogo": {
											"publicId": "publishers/nyt-white"
										},
										"name": "New York Times"
									},
									"slug": "2021-12-01-the-big-money-is-going-vegan",
									"sourceUrl": "https://www.nytimes.com/2021/05/18/business/oatly-ipo-milk-substitutes.html",
									"strippedTitle": "The Big Money Is Going Vegan",
									"timeToRead": 6,
									"title": "The Big Money Is Going Vegan",
									"type": "FREE",
									"wordCount": 1477
								},
								"note": "Omnis dolor labore fuga perspiciatis dolor nemo eius ut.",
								"style": {
									"color": "#E4F1E2",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							}
						],
						"id": "0d88b04b-e0df-409f-abc5-e558ce76d9fc",
						"name": "Nestle is unhealthy?"
					},
					"summaryCards": [
						{
							"text": "Laudantium quidem est voluptatem et debitis fugit. Vero maiores error dolor soluta qui qui harum ut. Illum atque earum iste sit delectus? Et est nihil est quia et vitae in voluptatem quaerat."
						}
					],
					"title": "Nestle is unhealthy?"
				},
				{
					"category": null,
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
							"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
							"lightLogo": {
								"publicId": "publishers/nyt-white"
							},
							"name": "New York Times"
						}
					],
					"id": "aa326e1f-ec14-4829-b8a3-cb21dbd25259",
					"introduction": "Nulla culpa similique aliquid dolores repellendus quia?",
					"lastUpdatedAt": "2021-12-23T11:38:26Z",
					"owner": {
						"__typename": "Expert",
						"areaOfExpertise": "Global Warming",
						"avatar": null,
						"bio": "Hi, it's Bill Gates!If you don't know me... look outside... Windows!",
						"chunkedBio": [
							"Hi, it's Bill Gates!",
							"If you don't know me... look outside... Windows!"
						],
						"id": "f5d7f2d5-1cd8-458a-a42d-dd130cbbbcc0",
						"name": "@billgates"
					},
					"readingList": {
						"entries": [
							{
								"item": {
									"__typename": "Article",
									"author": "Jordon Mraz",
									"id": "aed48530-2aec-4d9c-b4b2-841ae450fea3",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-12-05",
									"publisher": {
										"darkLogo": null,
										"id": "b4611ce6-d96d-449c-afac-a6059bb38f10",
										"lightLogo": null,
										"name": "Euronews"
									},
									"slug": "2021-12-05-who-renames-covid-variants-to-non-stigmatising-letters-of-greek-alphabet",
									"sourceUrl": "https://www.euronews.com/2021/06/01/who-renames-covid-variants-to-non-stigmatising-letters-of-greek-alphabet",
									"strippedTitle": "WHO renames COVID variants to 'non-stigmatising' letters of Greek alphabet",
									"timeToRead": 5,
									"title": "WHO renames COVID variants to 'non-stigmatising' letters of Greek alphabet",
									"type": "FREE",
									"wordCount": 1229
								},
								"note": "Blanditiis maiores qui qui magni hic voluptatem ratione.",
								"style": {
									"color": "#F3E5F4",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							},
							{
								"item": {
									"__typename": "Article",
									"author": "Nikki Becker",
									"id": "fbfb5a69-a8e1-4368-94a9-1a58122cd26a",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-11-30",
									"publisher": {
										"darkLogo": {
											"publicId": "publishers/nyt-black"
										},
										"id": "4b7a44f1-3585-4591-85de-0d6e92d34f66",
										"lightLogo": {
											"publicId": "publishers/nyt-white"
										},
										"name": "New York Times"
									},
									"slug": "2021-11-30-coronavirus-variants-and-mutations",
									"sourceUrl": "https://www.nytimes.com/interactive/2021/health/coronavirus-variant-tracker.html",
									"strippedTitle": "Coronavirus Variants and Mutations",
									"timeToRead": 7,
									"title": "Coronavirus Variants and Mutations",
									"type": "PREMIUM",
									"wordCount": 1858
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
									"author": "Kyler Bradtke",
									"id": "776f773f-fc30-4e7f-844a-9e8013c11350",
									"image": {
										"publicId": "articles/storm"
									},
									"publicationDate": "2021-11-25",
									"publisher": {
										"darkLogo": null,
										"id": "8115cad7-72b8-4514-a1f7-4c9305726182",
										"lightLogo": null,
										"name": "AP News"
									},
									"slug": "2021-11-25-bye-alpha-eta-greek-alphabet-ditched-for-hurricane-names",
									"sourceUrl": "https://apnews.com/article/no-greek-alphabet-hurricane-names-b504a7326955bb171530777c140103e2",
									"strippedTitle": "Bye Alpha, Eta: Greek alphabet ditched for hurricane names",
									"timeToRead": 4,
									"title": "Bye Alpha, Eta: Greek alphabet ditched for hurricane names",
									"type": "FREE",
									"wordCount": 1032
								},
								"note": "Eaque similique deserunt aut asperiores?",
								"style": {
									"color": "#E4F1E2",
									"type": "ARTICLE_COVER_WITH_BIG_IMAGE"
								}
							}
						],
						"id": "dd403ae7-eb0c-4710-a40f-1566ce478e7e",
						"name": "COVID-variant names"
					},
					"summaryCards": [
						{
							"text": "Dolores consequuntur reprehenderit magni et iure magnam rerum. Magnam velit aperiam id asperiores consequatur est! Velit quisquam fugiat laborum ad voluptate perspiciatis velit. Labore nihil omnis lab"
						}
					],
					"title": "COVID-variant names"
				}
			]
		}
	}
''';
}

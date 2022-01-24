class MockGraphqlResponses {
  //To create this Strings, just send the request in Insomnia and copy/paste exactly what it returns

  static const topicsFromExpert = '''
  {
    "getTopicsFromExpert": [
      $topic
    ]
  }
  ''';

  static const topic = '''
    {
      $_coverImage,
      $_heroImage,
      $_highlightedPublishers,
      "id": "154dfdf6-ae72-4ea9-b4a5-d61e1782099e",
      "introduction": "Perspiciatis iusto et voluptatem ad.",
      "lastUpdatedAt": "2021-12-15T14:24:22Z",
      $_summaryCards,
      "title": "Nestle is unhealthy?"
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
            $_coverImage,
            $_heroImage,
            $_highlightedPublishers,
            "id": "1e55abe0-d711-44b4-a37c-7e1a279b439a",
            "introduction": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            "lastUpdatedAt": "2021-12-23T11:38:26Z",
            $_ownerEditor,
            "readingList": {
              "entries": [
                $_readingLisEntryPremiumWithBigImage,
                $_readingLisEntryFreeWithoutImage
              ],
              "id": "88afff48-ff28-47ba-9793-a307d98df5f8",
              "name": "Lorem **ipsum sit amet** incididunt elit eiusmod sit"
            },
            $_summaryCards,
            "title": "Lorem **ipsum sit amet** incididunt elit eiusmod sit",
            "strippedTitle": "Lorem ipsum sit amet incididunt elit eiusmod sit"
          },
          {
            "category": null,
            $_coverImage,
            $_heroImage,
            $_highlightedPublishers,
            "id": "aa326e1f-ec14-4829-b8a3-cb21dbd25259",
            "introduction": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            "lastUpdatedAt": "2021-12-23T11:38:26Z",
            $_ownerExpert,
            "readingList": {
              "entries": [
                $_readingLisEntryPremiumWithBigImage,
                $_readingLisEntryFreeWithoutImage
              ],
              "id": "dd403ae7-eb0c-4710-a40f-1566ce478e7e",
              "name": "Lorem ipsum sit amet incididunt elit eiusmod sit"
            },
            $_summaryCards,
            "title": "Lorem **ipsum sit amet** incididunt elit eiusmod sit",
            "strippedTitle": "Lorem ipsum sit amet incididunt elit eiusmod sit"
          }
        ]
      }
    }
  ''';

  static const arzticleContentMarkdown = '''
  {
    "content": "Novak Djokovic is no doubt spending his time detained in an immigration hotel in Melbourne doing yoga and tai chi, stretching, meditating and adhering to every facet of the strict training regimen that has helped him become the world's No. 1 tennis player.\\r\\n\\r\\nOn the streets below, Serbian supporters are staging a candlelight vigil and serenading him amid visa-limbo while lawyers fight a deportation order that would deny Djokovic the chance to compete for a 10th Australian Open title and, with it, a men's-record 21st Grand Slam title.\\r\\n\\r\\nFrom abroad, Serbian President Aleksandar Vucic has decried what he called a \\"political witch hunt\\" conducted against his country's revered native son. Djokovic's father, Srdjan, meantime, told Serbian supporters that Australia was crucifying his son, saying: \\"Jesus was crucified on the cross . . . but he is still alive among us. They are trying to crucify and belittle Novak and throw him to his knees.\\"\\r\\n\\r\\nUntil Monday, when a federal court is expected to end the diplomatic incident that has taken on circuslike theatrics, Djokovic must remain in the hotel.\\r\\n\\r\\nYet if his career has proved anything, it is that Djokovic's determination to chart his own course - at least in terms of his physical training and mental preparation - is the essence of his dominance in tennis.\\r\\n\\r\\nAnd if allowed to enter the country to contest the Australian Open, he may turn this politically charged period in exile - which he could have avoided by following the vaccine mandate that applies to all players, officials and fans at this year's tournament - into a yet another \\"go-against-the grain\\" triumph.\\r\\nMonday's hearing will be held one week before the tournament's Jan. 17 start.\\r\\n\\r\\nDjokovic was detained at Melbourne's airport overnight Wednesday as Australian border officials reviewed his visa and qualifications for a medical exemption to Australia's strict covid vaccination requirements.\\r\\n\\r\\nHe was one of \\"a handful\\" among 26 applicants granted an exemption by Tennis Australia and the government of the state of Victoria to compete in the tournament.\\r\\n\\r\\nThe rationale for Djokovic's exemption, which was granted in consultation by medical authorities who reviewed applicants without knowing their identity, was a previous covid infection, the Guardian reported.\\r\\n\\r\\nBut Australia's national standard for medical proof that a visitor to the country cannot be vaccinated, which is enforced at the border, is higher.\\r\\n\\r\\nDjokovic has acknowledged contracting covid in summer 2020, after taking part in a short-lived exhibition he staged in Serbia and Croatia amid minimal precautions. It is unclear if he contracted covid more recently.\\r\\n\\r\\nWith 20 Grand Slams and the men's record-holder for weeks atop the world ranking, Djokovic, 34, is quite possibly the greatest to ever play tennis.\\r\\n\\r\\nTwo qualities in particular set the 6-2, 170-pound Djokovic apart: A fanatical adherence to a strict gluten-free diet and a program of stretching and exercise that has transformed his otherwise unremarkable physique (much like Tom Brady) into a purpose-built, pliable winning machine.\\r\\n\\r\\nAnd profound self-belief and self-determination that have pulled him from the brink of defeat in countless high-stakes matches. Djokovic's inner belief is arguably his greatest asset, but it doesn't necessarily mesh with decision-making for the greater good - such as complying with vaccine mandates amid a global pandemic.\\r\\n\\r\\nAs a tennis player, Djokovic has no discernible weakness. He has forged himself, over years of training, into an uncommonly complete player. His defense is as much a weapon as his offense. His return of serve is without peer, complemented by a highly effective serve.\\r\\n\\r\\nWith the foot speed, reach and flexibility to blast winners even if badly out of position, he covers virtually every inch of the court, sapping opponents' will in the process.\\r\\n\\r\\nAnd he has mastered the mental game, whether that means summoning his best when most players would be at their breaking point or breaking the momentum of unfavorable spells with a bathroom break or call for a trainer.\\r\\n\\r\\nNone of these attributes was bestowed. They are not gifts, but the product of relentless work.\\r\\nDjokovic has been chasing tennis perfection since childhood - the past two decades, in the form of Roger Federer and Rafael Nadal, champions who are elder by five-plus years, in the case of Federer, and 11 months, in the case of Nadal.\\r\\n\\r\\nFederer had won 16 Grand Slam singles titles, and Nadal had won nine by the time Djokovic claimed his second (at the 2011 Australian Open). But over the decade since, Djokovic has closed the gap with breathtaking efficiency, winning eight of the 13 majors contested since July 2018, to make it a three-way tie for a men's record 20 major titles.\\r\\n\\r\\nBut Djokovic has yet to close the gap in fans' affection. He has been forever a third wheel in the sport's love affair with Federer and Nadal.\\r\\n\\r\\nIn his early career, Djokovic made himself difficult for many to cheer, outside of his devoted following in the Balkans. His tactics smacked of gamesmanship, at times. And he got off on a bad foot with the highly partisan crowd at the U.S. Open, chiding them for not showing due respect.\\r\\n\\r\\nYet last September, amid the most gutting defeat of his career - as his pursuit of the rare calendar-year Grand Slam was scuttled by a straight-sets loss to Daniil Medvedev in the U.S. Open final - Djokovic wept with a pathos that won hearts.\\r\\n\\r\\nAfterward, he spoke unabashedly about what it meant to feel the crowd's embrace. \\"I felt something I never felt in my life here in New York,\\" Djokovic said. \\"I did not expect anything. But the amount of support and energy and love I got from the crowd was something that I'll remember forever. I mean, that's the reason on the changeover I just teared up. The emotion, the energy was so strong. I mean, it's as strong as winning 21 Grand Slams. That's how I felt, honestly. I felt very, very special.\\"\\r\\n\\r\\nIf Djokovic's deportation is overturned Monday, he will enter the Australian Open as the tournament's nine-time and defending champion, the world No. 1 and a heavy favorite. But he will face significant unknowns, starting with his opening match.\\r\\n\\r\\nHow will he be received by fans at Melbourne Park, given the national outcry that erupted when he posted the news Tuesday that he had been granted a medical exemption to the tournament's vaccine requirement? Will the inevitable boos shouted by some be drowned out by the vociferous cheers of his Serbian supporters? If the crowd is split, can Djokovic still perform at his best?\\r\\n\\r\\nAsked after his victory in the 2021 Australian Open how it felt to be criticized so often, Djokovic said: \\"Of course it hurts. I'm a human being like yourself, like anybody else. I have emotions. I don't enjoy when somebody attacks me in the media openly and stuff. . . . But I think I've developed a thick skin over the years to just dodge those things and focus on what matters to me the most.\\"\\r\\n",
    "markupLanguage": "MARKDOWN"
  }
  ''';

  static const articleContentHTML = '''
  {
    "content": "<div id=\\"readability-page-1\\" class=\\"page\\"><div>\\n\\t\\t\\t\\t\\t\\t\\t\\t\\t\\n\\t\\t\\t\\t\\t\\t\\t<div id=\\"amazon-polly-audio-table\\">\\n\\t\\t\\t\\t<p>Press play to listen to this article</p>\\n\\t\\t\\t\\t\\n\\t\\t</div>\\n<p>The Omicron variant is driving an unprecendented wave of coronavirus infection in Europe that, because it is so contagious, means it will be hard for most people to avoid exposure to the disease.</p>\\n\\n\\n\\n<p>Even if Omicron is less deadly than earlier versions of the Sars-CoV-2 virus, hospitals and other critical services still face enormous strains in the weeks ahead as staff are infected or have to isolate.</p>\\n\\n\\n\\n<p>But what happens then? Some scientists say that the current surge heralds an \\"exit wave\\" from the two-year-old pandemic and a transition to a new, less dangerous, endemic phase where societies will have to learn to live with the virus. Others call this wishful thinking and warn that, with more people infected than ever, risks will only grow of a new, and more dangerous, strain emerging: </p>\\n\\n\\n\\n<h3>How big will the Omicron wave be?&nbsp;</h3>\\n\\n\\n\\n<p>The Omicron wave has been compared by political leaders to a tidal wave: France reached a dizzying <a href=\\"https://www.france24.com/en/live-news/20220104-france-s-daily-covid-19-cases-top-270-000\\" target=\\"_blank\\">270,000 new cases</a> on Tuesday, while countries including <a href=\\"https://www.ekathimerini.com/news/1174971/new-infections-record-expected-to-be-smashed-again/\\" target=\\"_blank\\">Greece</a>, <a href=\\"https://www.ilsole24ore.com/art/coronavirus-oggi-170844-nuovi-casi-e-259-decessi-AEQ2tK6\\" target=\\"_blank\\">Italy</a>, and <a href=\\"https://www.elcomercio.es/sociedad/salud/espana-bate-nuevo-20220103195350-ntrc.html\\" target=\\"_blank\\">Spain</a> are also setting infection records. Eastern European countries are now detecting their <a href=\\"https://www.reuters.com/world/europe/bulgaria-detects-first-cases-omicron-coronavirus-variant-2022-01-02/\\" target=\\"_blank\\">first</a> Omicron cases.</p>\\n\\n\\n\\n<p>But health experts agree that, unlike this time last year, intensive care units aren't at risk of being overrun. While Omicron can sidestep prior immunity, <a href=\\"https://www.ft.com/content/15795cbc-b15e-427c-a7dd-9e116ebb08a5\\" target=\\"_blank\\">studies</a> point to vaccines and previous infections still protecting against the worst outcomes.</p>\\n\\n\\n\\n<p>In the U.K. — the first country in Europe to encounter Omicron — new infections crossed the threshold of <a href=\\"https://www.aljazeera.com/news/2022/1/4/india-hits-highest-daily-covid-cases-since-september-live-news\\" target=\\"_blank\\">200,000</a> on Tuesday and hospitalizations are increasing. But the number of patients being mechanically ventilated remains <a href=\\"https://coronavirus.data.gov.uk/details/healthcare\\" target=\\"_blank\\">flat</a> despite the surge in infections. That's a positive signal for the rest of Europe.</p>\\n\\n\\n\\n<h3>How bad will it be?&nbsp;</h3>\\n\\n\\n\\n<p>Omicron is capable of dodging immunity from a standard course of vaccination or prior infection with COVID-19. But, importantly, booster shots appear to be effective and Omicron itself is less dangerous than earlier variants. Research points to the variant concentrating in the <a href=\\"https://www.theguardian.com/world/2022/jan/02/new-studies-reinforce-belief-that-omicron-is-less-likely-to-damage-lungs\\" target=\\"_blank\\">upper airways</a>, avoiding the more sensitive lungs previously linked with fatal complications from COVID-19. </p>\\n\\n\\n\\n\\n\\n\\n<p>Despite the variant's lesser virulence and widespread immunity from vaccines, health systems are still under pressure. In Italy, patients are filling regular hospital beds even if they don't end up in the ICU, said Fidelia Cascini, assistant professor of public health at the Università Cattolica Sacro Cuore in Rome. This means drawing on resources that could be used for other patients in health systems already struggling with backlogs and staff shortages. &nbsp;</p>\\n\\n\\n\\n<p>More broadly, mass absences when staff have to isolate after testing positive could threaten essential services and critical infrastructure, and undermine the continent's fragile economic recovery from recent lockdowns.</p>\\n\\n\\n\\n<p>Sarah Scobie, deputy director of research at the health-focused think tank Nuffield Trust, said that 25,000 U.K. health care workers were off sick in the most recent week for which data is available. In England, several hospital trusts have declared \\"<a href=\\"https://www.theguardian.com/society/2022/jan/03/several-nhs-trusts-declare-critical-incidents-amid-covid-staff-crisis\\" target=\\"_blank\\">critical incidents</a>\\" due to staff shortages. The full impact of Omicron remains to be seen, Scobie cautioned, since it is only now starting to spread among the elderly, who are more likely to become severely ill from the coronavirus.</p>\\n\\n\\n\\n<h3>When will it end?</h3>\\n\\n\\n\\n<p>Flemming&nbsp;Konradsen, professor of global environmental health at the University of Copenhagen, expects Europe to be in a very different place by the end of February. In Denmark, the first country on the continent to record a major Omicron wave, the variant's rapid spread means that it will run through the population quickly.</p>\\n\\n\\n\\n<p>\\"After the burnout, we'll have a population in Denmark that is close to 90 percent infected or immunized. And that, of course, will make the disease quite different,\\" said Konradsen. People will still get sick but the risk of serious illness will concentrate in settings such as nursing homes and hospitals.</p>\\n\\n\\n\\n<p>This scenario is likely to play out across Europe, as the rollout of booster shots and immunity gained through infection with Omicron improves the population's defenses. Eastern Europe, where vaccination levels lag, could be vulnerable: \\"I would expect that many health systems across Europe during the month of January into mid-February would be put under significant pressure,\\" said Konradsen. </p>\\n\\n\\n\\n<h3>Is South Africa the future?</h3>\\n\\n\\n\\n<p>South Africa was one of the first countries to detect the Omicron variant in late November. Public health experts have since analyzed the Omicron wave to understand how the variant might spread around the world. </p>\\n\\n\\n\\n<p>With its young demographic profile, the African nation isn't a perfect parallel to anywhere in Europe. Still, cases have already <a href=\\"https://www.bbc.com/news/world-africa-59832843\\" target=\\"_blank\\">peaked</a> without a large increase in deaths. And, in contrast to earlier waves, South Africa held off from imposing further restrictions even as Omicron surged. So far, that approach has paid off.&nbsp;</p>\\n\\n\\n\\n<p>“We basically made a strong case that going to higher levels of restrictions should be only informed if healthcare facilities were imminently under threat and not based on the increasing number of cases,” said Shabir Madhi, professor of vaccinology at the University of the Witwatersrand and chair of the National Advisory Group on Immunization in South Africa. “It worked extremely well, with minimum damage in South Africa compared to what happened in the past.”</p>\\n\\n\\n\\n<p>Going forward, the focus needs to be on preventing severe disease and death, said Madhi. “By continuously harping on about the number of people that have been infected, it's really missing the point that the virus is not going to disappear,” he said.</p>\\n\\n\\n\\n<h3>Can we learn to live with the virus?</h3>\\n\\n\\n\\n<p>Scientists are starting to speak of a possible end to the pandemic, with the virus becoming \\"endemic,\\" circulating freely but posing less of a threat to societies.</p>\\n\\n\\n\\n<p>That's the view of epidemiologist Maria Van Kerkhove, the World Health Organization’s technical lead on COVID-19. Speaking in December, she predicted a <a href=\\"https://www.politico.eu/article/who-forecasts-coronavirus-pandemic-will-end-in-2022/\\">long transition</a> before the end of the pandemic. “Endemic doesn't mean that it's not dangerous,” Van Kerkhove added.  </p>\\n\\n\\n\\n<p>But there is no consensus on just how the pandemic will evolve, or even what living with an endemic virus will be like. </p>\\n\\n\\n\\n<p>Masks, for example, are likely to remain a common feature in Europe, as they already were in Asia throughout the flu season, said Martin McKee, professor of public health at the London School of Hygiene &amp; Tropical Medicine.&nbsp;</p>\\n\\n\\n\\n<p>He’s a signatory of a letter co-authored by a number of different public health experts advocating for a “<a href=\\"https://www.politico.eu/article/health-experts-vaccines-alone-arent-enough-against-pandemic/\\">vaccine plus</a>” strategy that focuses both on jabs and public health measures, including tighter restrictions if needed. McKee said the focus should continue to be on suppressing the virus, which can still pose a risk for the most vulnerable.</p>\\n\\n\\n\\n<h3>Could a more deadly variant emerge?</h3>\\n\\n\\n\\n<p>McKee warned, however, that there is no scientific consensus on whether the coronavirus will remain less deadly: It could continue to evolve and again become more dangerous. A group of Swedish-based scientists shares that fear: \\"Letting large amounts of infection circulate is like opening Pandora’s box. We&nbsp;should expect more unpleasant surprises to come. We have hardly seen the last variant,\\" they wrote in an <a href=\\"http://politico.eu/article/climate-change-coronavirus-global-tipping-points\\" target=\\"_blank\\">opinion piece</a> for POLITICO.</p>\\n\\n\\n\\n<p>David Heymann, professor of infectious disease epidemiology at the London School of Hygiene &amp; Tropical Medicine, agreed that there was always the chance of a dangerous mutation. But, he added, the high level of population immunity reached in the U.K. should guide a different approach. Rather than top-down decisions like lockdowns, people should perform their own risk assessments. For example, testing themselves before going out to dinner, or avoiding vulnerable people if there might be a risk of infection.   </p>\\n\\n\\n\\n<p>\\"It's a matter of just letting this disease become like other diseases, one that we do our own assessment on,\\" he said. \\"Let's get on with doing what we need to do to prevent this from rapidly spreading and to protect others.\\"</p>\\n\\n\\n\\n<p><em>This article is part of </em><span>POLITICO</span><em>’s premium policy service: Pro Health Care. From drug pricing, EMA, vaccines, pharma and more, our specialized journalists keep you on top of the topics driving the health care policy agenda. Email </em><a href=\\"https://www.politico.eu/cdn-cgi/l/email-protection#d2a2a0bd92a2bdbebba6bbb1bdfcb7a7\\" target=\\"_blank\\"><em><span data-cfemail=\\"7a0a08153a0a1516130e131915541f0f\\">[email&nbsp;protected]</span></em></a><em> for a complimentary trial.&nbsp;</em></p>\\n\\t\\t\\t\\t\\t\\t\\t\\t</div></div>",
    "markupLanguage": "HTML"
	}
  ''';

  // Internal parts

  static const _coverImage = '''
  "coverImage": {
    "publicId": "covers/Cover_5"
  }
  ''';

  static const _heroImage = '''
  "heroImage": {
    "publicId": "topics/pizza"
  }
  ''';

  static const _publisher = '''
  {
    "darkLogo": {
      "publicId": "publishers/nyt-black"
    },
    "lightLogo": {
      "publicId": "publishers/nyt-white"
    },
    "id": "7768da13-47c1-4907-9264-abc0aca796aa",
    "name": "New York Times"
  }
  ''';

  static const _highlightedPublishers = '''
  "highlightedPublishers": [
    $_publisher,
    $_publisher
  ]
  ''';

  static const _ownerEditor = '''
  "owner": {
    "__typename": "Editor",
    "avatar": null,
    "name": "Editorial Team"
  }
  ''';

  static const _ownerExpert = '''
  "owner": {
    "__typename": "Expert",
    "areaOfExpertise": "Global Warming",
    "avatar": {
      "publicId": "owner_1"
    },
    "bio": "Hi, it's Bill Gates!If you don't know me... look outside... Windows!",
    "chunkedBio": [
      "Hi, it's Bill Gates!",
      "If you don't know me... look outside... Windows!"
    ],
    "id": "f5d7f2d5-1cd8-458a-a42d-dd130cbbbcc0",
    "name": "@billgates"
  }
  ''';

  static const _readingLisEntryPremiumWithBigImage = '''
  {
    "item": {
      "__typename": "Article",
      "author": "Cassandre Lueilwitz",
      "id": "ec9dc456-5d62-4277-9dea-9b0639529468",
      "image": {
        "publicId": "articles/storm"
      },
      "publicationDate": "2021-12-03",
      "publisher": $_publisher,
      "slug": "2021-12-03-denmarks-role-in-the-nsa-spying-scandal",
      "sourceUrl": "https://www.dw.com/en/denmarks-role-in-the-nsa-spying-scandal-dws-emmanuelle-chaze/av-57723050",
      "strippedTitle": "Denmark's role in the NSA spying scandal",
      "timeToRead": 10,
      "title": "Denmark's role in the NSA spying scandal",
      "type": "PREMIUM",
      "wordCount": 2426
    },
    "note": "Germany is seeking to break a surge in coronavirus infections; India detects two cases of new Omicron variant in Karnataka; Greece and Finland detect first Omicron cases.",
    "style": {
      "color": "#F2E8E7",
      "type": "ARTICLE_COVER_WITH_BIG_IMAGE"
    }
  }
  ''';

  static const _readingLisEntryFreeWithoutImage = '''
    {
      "item": {
        "__typename": "Article",
        "author": "Piper Ankunding II",
        "id": "c3cb4ac3-5bae-40dd-b29b-d855b8b343ba",
        "image": {
          "publicId": "articles/storm"
        },
        "publicationDate": "2021-12-13",
        "publisher": $_publisher,
        "slug": "2021-12-13-nsa-files-decoded",
        "sourceUrl": "https://www.theguardian.com/world/interactive/2013/nov/01/snowden-nsa-files-surveillance-revelations-decoded#section/1",
        "strippedTitle": "NSA files: Decoded",
        "timeToRead": 5,
        "title": "NSA files: Decoded",
        "type": "FREE",
        "wordCount": 1166
      },
      "note": "Germany is seeking to break a surge in coronavirus infections; India detects two cases of new Omicron variant in Karnataka; Greece and Finland detect first Omicron cases.",
      "style": {
        "color": "#E4F1E2",
        "type": "ARTICLE_COVER_WITHOUT_IMAGE"
      }
    }
    ''';

  static const _summaryCards = '''
  "summaryCards": [
    {
      "text": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mu."
    },
    {
      "text": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula."
    }
  ]
  ''';
}

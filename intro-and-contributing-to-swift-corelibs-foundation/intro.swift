let slides = Slides(pages: [

    Image(title: "images/cocoaheads-auckland-logo.png", bulletPoints: []),

    Cover(title: "Welcome to CocoaHeads Auckland!!", bulletPoints: ["meetup.isFirst == true"]),

    Cover(title: "Who are we?", bulletPoints: []),

    Image(title: "images/meme.jpg", bulletPoints: []),

    Page(title: "Our plan", bulletPoints: [
        "Monthly meet up",
        "  Always 2nd Thursday of the month",
        "Talk about things you built on macOS/iOS/tvOS/watchOS",
        "  Your own projects",
        "  Open source projects",
        "Share best practices",
        "  Design",
        "  Build",
        "  Release",
        "  Marketing",
        "Share stuffs you are intrested in",
        "  Apple platform news",
        "  Libraries",
        "  Way to do things (design patterns, programming paradims)",
        "  Programming Languages",
    ]),

    Image(title: "images/cocoaheads-map.png", bulletPoints: ["We are all around the world!"]),

    Image(title: "images/fiserv-logo.png", bulletPoints: ["Sponsor"]),

    Page(title: "Today's topics", bulletPoints: [
        "Contributing to swift-corelibs-foundation",
        "  Yan Li",
        "Introduce MVVM & how to implement it in your iOS app",
        "  Harvey Hu ",
        "A simple wrapped commandline macOS App",
        "  Jesse",
    ]),
])

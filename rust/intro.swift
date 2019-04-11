import TruffautSupport

let presentation = Presentation(pages: [
    Page(contents: [
        .image("cocoa-heads.png"),
        .text("CocoaHeads.meetup(at: .march)"),
    ]),

    Page(title: "CocoaHeads.meetup(at: .march)", contents: [
        .text("Scalable Messenger Applications - Roman"),
        .text("Introduction to Rust - Yan"),
    ]),

    Page(title: "The JetBrains IDE Raffle", contents: [
        .text("Free 1-year subscription to one of the JetBrains IDEs"),
        .indent([
            .text("AppCode, RubyMine, PyCharm, GoLand, CLion, ReSharper, PhpStorm, etc."),
        ]),
        .text("Randomly picked in attendees and speakers"),
        .text("After the second talk"),
    ]),
])

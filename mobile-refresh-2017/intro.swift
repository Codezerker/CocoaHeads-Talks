import TruffautSupport

let presentation = Presentation(pages: [
    Page(contents:[
        .image("images/CocoaHeads-Auckland.png"),
        .text("Welcome to CocoaHeads!!"),
    ]),

    Page(title: "What's CocoaHeads?", contents: [
        .text("Talk about things you built on macOS/iOS/tvOS/watchOS"),
        .text("Share best practices"),
        .text("Apple platform news"),
        .text("Bimonthly meet up"),
        .indent([
            .text("2nd Thursday of the month"),
        ]),
    ]),

    Page(contents: [
        .image("images/fiserv-logo.png"),
        .text("Sponsor"),
    ]),

    Page(title: "Today's Topics", contents: [
        .text("The native part of React Native"),
        .indent([
            .text("Jesse"),
        ]),
        .text("ARKit"),
        .indent([
            .text("Leon"),
        ]),
        .sourceCode(.plainText, "s/*/swift/"),
        .indent([
            .text("Yan"),
        ]),
    ]),
])

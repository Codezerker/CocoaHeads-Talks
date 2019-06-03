import TruffautSupport

let presentation = Presentation(pages: [

  Page(title: "Hash Tables", subtitle: "An Implementation Detail Series"),

  Page(title: "Topics", contents: [
    .text("Direct Addressing"),
    .text("Hash Functions"),
    .text("Collision Resolutions"),
    .indent([
      .text("Chaining"),
      .text("Open Addressing"),
    ]),
    .text("Examples"),
    .indent([
      .text("A Basic HashTable"),
      .text("NSDictionary/CFDictionary"),
      .text("Swift.Dictionary"),
      .text("Google Swiss Table"),
    ]),
  ]),

])

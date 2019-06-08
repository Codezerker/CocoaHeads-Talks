import TruffautSupport

let presentation = Presentation(pages: [

  Page(title: "Hash Tables", subtitle: "An Implementation Detail Series"),

  Page(title: "Previously on \"Implementation Detail\"", contents: [
    .text("Data Type Overheads"),
    .indent([
      .text("Static and Primitive Types"),
      .text("Structs, Enums, Tuples"),
      .text("Fixed-size Arrays"),
      .text("Heap Allocationed Types"),
    ]),
    .text("Function Call Overheads"),
    .indent([
      .text("Static Function Call"),
      .text("Dynamic Dispatch"),
      .text("Swift Witness Table"),
    ]),
  ]),

  Page(title: "Topics", contents: [
    .text("What is a Hash Table?"),
    .text("Direct-Address Tables"),
    .text("Hash Tables"),
    .text("Collision Resolutions"),
    .indent([
      .text("Chaining"),
      .text("Open Addressing"),
      .indent([
        .text("Linear Probing"),
        .text("Quadratic Probing"),
        .text("Double Hashing"),
      ]),
    ]),
    .text("Examples"),
    .indent([
      .text("A Basic HashTable"),
      .text("NSDictionary/CFDictionary"),
      .text("Swift.Dictionary"),
    ]),
    .text("Advanced Optimisations"),
    .indent([
      .text("Robin Hood Hashing"),
      .text("Google Swiss Table"),
    ]),
  ]),

  Page(title: "What is a Hash Table?", contents: [
    .text("Basic operations:"),
    .indent([
      .text("Insert"),
      .text("Search"),
      .text("Delete"),
      .text("All basic operations require O(1) time (on average)"),
    ]),
    .text("Hash Table in programming languages:"),
    .indent([
      .text("Swift - Dictioanry"),
      .text("Objective-C - NSDictionary/CFDictionary"),
      .text("C++ - std::unordered_map"),
      .text("Rust - std::HashMap"),
      .text("Python - Dictionary"),
      .text("Ruby - Hash"),
    ]),
  ]),

  Page(title: "Direct-Address Tables", contents: [
    .image("./images/direct_addressing.jpg"),
    .indent([
      .text("Not a Hash Table"),
      .text("Time complexity"),
      .indent([
        .text("Insert - O(1) worst case"),
        .text("Search - O(1) worst case"),
        .text("Delete - O(1) worst case"),
      ]),
      .text("Won't work for unknown number of keys"),
    ]),
  ]),

  Page(title: "Hash Table", contents: [
    .image("./images/hash_table.jpg"),
    .text("Let m be number of slots in the table, then"),
    .indent([
      .text("h(): U -> {0, 1, ..., m -1 }"),
    ]),
    .text("Time complexity"),
    .indent([
      .text("Insert - O(1) average case"),
      .text("Search - O(1) average case"),
      .text("Delete - O(1) average case"),
    ]),
    .text("Why \"average case\" instead of \"worst case\"?"),
    .indent([
      .text("h(k2) == h(k5)"),
    ]),
  ]),

  Page(title: "Thanks!", subtitle: "@eyeplum"),

  Page(
    title: "What happens before main()?",
    subtitle: "Stay tuned for the next \"Implementation Detail\" talk!"
  ),

])

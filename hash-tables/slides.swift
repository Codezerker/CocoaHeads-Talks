import TruffautSupport

let simple_chained_hash_map = """
struct HashMap<K: Hashable, V> {
  slots: Array<LinkedList<(K, V)>>
}
"""

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
      .sourceCode(.plainText, "Insert<K: Hashable, V>(key: K, value: V)"),
      .sourceCode(.plainText, "Search<K: Hashable, V>(key: K) -> Optional<V>"),
      .sourceCode(.plainText, "Delete<K: Hashable>(key: K)"),
      .text("All basic operations require O(1) time (on average)"),
    ]),
    .text("Hash Table in programming languages:"),
    .indent([
      .text("Swift - Dictioanry"),
      .text("Objective-C - NSDictionary/CFDictionary"),
      .text("C++ - std::unordered_map"),
      .text("Rust - std::collections::HashMap"),
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
      .text("Works well when universe of keys is small"),
    ]),
  ]),

  Page(title: "Hash Tables", contents: [
    .image("./images/hash_table.jpg"),
    .text("Let m be number of slots in the table, then"),
    .indent([
      .sourceCode(.plainText, "h(k): U -> { 0, 1, ..., m -1 }"),
      .text("The output of h() should appear \"random\""),
      .indent([
        .text("HashDoS"),
      ]),
    ]),
    .text("Time complexity"),
    .indent([
      .text("Insert - O(1) average case"),
      .text("Search - O(1) average case"),
      .text("Delete - O(1) average case"),
    ]),
    .text("Why \"average case\" instead of \"worst case\"?"),
    .indent([
      .text("Because of collisions: h(k2) == h(k5)"),
      .text("And rehashing"),
    ]),
  ]),

  Page(title: "Collision Resolution: Chaining", contents: [
    .image("./images/chaining.jpg"),
    .text("Pseudo implementation"),
    .indent([
      .sourceCode(.rust, simple_chained_hash_map),
      .text(""),
      .text("Search(key)"),
      .indent([
        .sourceCode(.plainText, "find the tuple in slots[h(key)] where tuple.0 == key"),
      ]),
      .text("Insert(key, value)"),
      .indent([
        .sourceCode(.plainText, "use Search(key) and replace existing tuple"),
        .sourceCode(.plainText, "otherwise insert (key, value) at the head of slots[h(key)]"),
      ]),
      .text("Delete"),
      .indent([
        .sourceCode(.plainText, "delete the tuple in slots[h(key)] where tuple.0 == key"),
      ]),
    ]),
    .text("Downsides of chaining"),
    .indent([
      .text("Inefficient memory usage"),
      .text("Not cache friendly"),
      .indent([
        .image("./images/cache_scaling.jpg"),
      ]),
    ]),
  ]),

  Page(title: "Collision Resolution: Open Addressing", contents: [
    .image("./images/probing.jpg"),
    .sourceCode(.plainText, "given h'(k) : U -> { 0, 1, ..., m - 1 }"),
    .sourceCode(.plainText, "for i in 0..=(m - 1)"),
    .text("Linear probing"),
    .indent([
      .sourceCode(.plainText, "h(k, i) = (h'(k) + i) mod m"),
      .text("Clustering"),
    ]),
    .text("Quadratic probing"),
    .indent([
      .sourceCode(.plainText, "h(k, i) = (h'(k) + c1 * i + c2 * i^2) mod m"),
      .text("Choosing c1, c2 and m is very important, these will work:"),
      .indent([
        .sourceCode(.plainText, "let c1 = 1, c2 = 0"),
        .sourceCode(.plainText, "let c1 = 1/2, c2 = 1/2, m is power of 2"),
      ]),
      .text("If wrong c1, c2 and m is chosen, not all indices will be probed"),
    ]),
    .text("Xcode Playground: Probing Sequence Examples"),
  ]),

  Page(title: "Rehashing", contents: [
    .text("When the load factor reaches the limit"),
    .indent([
      .text("Reallocate the internal storage"),
      .text("Perform Insert(key, value) for each of the existing values"),
      .text("Not a simple copy because m has changed"),
    ]),
    .text("Rehasing when m grows from 0 to 140,000"),
    .indent([
      .image("./images/amortized_constant.png"),
    ]),
    .text("The O(1) in hash table basic operations are conditional"),
    .indent([
      .text("Average case constant time"),
      .text("Amortized constant time"),
    ]),
  ]),

  Page(title: "Example: A Basic HashTable", contents: [
    .text("2x slower compared to std::collections::HashMap"),
    .text("4x slower compared to hashbrown::HashMap"),
  ]),

  Page(title: "Example: NSDictionary/CFDictionary", contents: [
    .text("NSDictionary is-a CFDictionary"),
    .text("CFDictionary has-a CFBasicHash")
  ]),

  Page(title: "Example: Swift.Dictionary", contents: [
    .sourceCode(.plainText, "__RawDictionaryStorage"),
    .sourceCode(.plainText, "__CocoaDictionary -> NSDictionary")
  ]),

  Page(title: "Advanced: Robin Hood Hashing", contents: [
    .text("TODO"),
    .text("Used in Rust std::collections::HashMap"),
  ]),

  Page(title: "Advanced: Google Swiss Table", contents: [
    .text("TODO"),
  ]),

  Page(title: "Thanks!", subtitle: "@eyeplum"),

  Page(
    title: "What happens before main()?",
    subtitle: "Stay tuned for the next \"Implementation Detail\" talk!"
  ),

])

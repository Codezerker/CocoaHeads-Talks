import TruffautSupport

let simple_chained_hash_map = """
struct HashMap<K: Hashable, V> {
  slots: Array<LinkedList<(K, V)>>
}
"""

let example_linear_probing = """
 index |  0  |  1  |  2  |  3  |  4   |  5  |  6  |  7  |
-------|-----|-----|-----|-----|------|-----|-----|-----|
 value | 5,7 |     |     | 4,8 | 12,9 |     |     | 8,2 |
-------|-----|-----|-----|-----|------|-----|-----|-----|
 slot  |  0  |     |     |  3  |  3   |     |     |  7  |
"""

let robin_hood_hashing_1 = """
 index |  0  |  1   |  2  |  3  |  4   |  5  |  6  |  7  |
-------|-----|------|-----|-----|------|-----|-----|-----|
 value | 5,7 | 29,7 | 6,6 | 3,4 | 12,9 |     |     | 8,2 |
-------|-----|------|-----|-----|------|-----|-----|-----|
 slot  |  0  |  0   |  1  |  2  |  3   |     |     |  7  |
          ^
          | D(13) -> 0
          | D(5) -> 0
        (13,3)
"""

let robin_hood_hashing_2 = """
 index |  0  |  1   |  2  |  3  |  4   |  5  |  6  |  7  |
-------|-----|------|-----|-----|------|-----|-----|-----|
 value | 5,7 | 29,7 | 6,6 | 3,4 | 12,9 |     |     | 8,2 |
-------|-----|------|-----|-----|------|-----|-----|-----|
 slot  |  0  |  0   |  1  |  2  |  3   |     |     |  7  |
                ^
                | D(13) -> 1
                | D(29) -> 1
              (13,3)
"""

let robin_hood_hashing_3 = """
 index |  0  |  1   |  2  |  3  |  4   |  5  |  6  |  7  |
-------|-----|------|-----|-----|------|-----|-----|-----|
 value | 5,7 | 29,7 | 6,6 | 3,4 | 12,9 |     |     | 8,2 |
-------|-----|------|-----|-----|------|-----|-----|-----|
 slot  |  0  |  0   |  1  |  2  |  3   |     |     |  7  |
                       ^
                       | D(13) -> 2
                       | D(6) -> 1
                     (13,3)
"""

let robin_hood_hashing_4 = """
 index |  0  |  1   |  2   |  3  |  4   |  5  |  6  |  7  |
-------|-----|------|------|-----|------|-----|-----|-----|
 value | 5,7 | 29,7 | 13,3 | 3,4 | 12,9 |     |     | 8,2 |
-------|-----|------|------|-----|------|-----|-----|-----|
 slot  |  0  |  0   |  0   |  2  |  3   |     |     |  7  |
                       ^
                       | D(6) -> 1
                       | D(13) -> 2
                     (6, 6)
"""

let robin_hood_hashing_5 = """
 index |  0  |  1   |  2   |  3  |  4  |  5   |  6  |  7  |
-------|-----|------|------|-----|-----|------|-----|-----|
 value | 5,7 | 29,7 | 13,3 | 6,6 | 3,4 | 12,9 |     | 8,2 |
-------|-----|------|------|-----|-----|------|-----|-----|
 slot  |  0  |  0   |  0   |  1  |  2  |  3   |     |  7  |
"""

let swiss_table_data_layout = """
 index |   0    |   1    |   2    |   3    |   4    | ... |   15   |
-------|--------|--------|--------|--------|--------|     |--------|
 value |        |        |        |        |        | ... |        |
-------|--------|--------|--------|--------|--------|     |--------|
 ctrl  |11111111|11111111|11111111|11111111|11111111| ... |11111111|
"""

let swiss_table_ctrl_byte = """
0b11111111  // EMPTY
0b10000000  // DELETED
0b0.......  // FULL - The rest 7 bits are set to `h(k) >> (64 - 7)`
"""

let swiss_table_example = """
 index |   0    |   1    |   2    |   3    |   4    | ... |   15   |
-------|--------|--------|--------|--------|--------|     |--------|
 value | (5,7)  |        | (39,8) |        |garbage | ... |        |
-------|--------|--------|--------|--------|--------|     |--------|
 ctrl  |01010111|11111111|00110110|11111111|10000000| ... |11111111|
"""

let swiss_table_lookup = """
let ctrls = x86::_mm_load_si128(self.ctrl[i]);
---------------------------------------------     ------------
| 01010111 | 11111111 | 00101010 | 10000000 | ... | 11111111 |
---------------------------------------------     ------------

let key = x86::_mm_set1_epi8(42);
---------------------------------------------     ------------
| 00101010 | 00101010 | 00101010 | 00101010 | ... | 00101010 |
---------------------------------------------     ------------

let compare_result = x86::_mm_cmpeq_epi8(ctrls, key);
---------------------------------------------     ------------
| 00000000 | 00000000 | 11111111 | 00000000 | ... | 00000000 |
---------------------------------------------     ------------

let result = x86::_mm_movemask_epi8(compare_result);
---------------------------------------------     ------------
|    0     |    0     |    1     |    0     | ... |    0     |
---------------------------------------------     ------------
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
      .sourceCode(.plainText, example_linear_probing),
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
    .text("Used in Rust std::collections::HashMap"),
    .text("\"Takes away from the rich and gives it to the poor\""),
    .indent([
      .text("Insert (13,3) where h(13) -> 0"),
      .text("Awww, but index 0 is occupied 😳"),
      .sourceCode(.plainText, robin_hood_hashing_1),
      .text("Check: D(13) > D(5) -> false 😢"),
      .sourceCode(.plainText, robin_hood_hashing_2),
      .text("Check: D(13) > D(29) -> false 😢"),
      .sourceCode(.plainText, robin_hood_hashing_3),
      .text("Check: D(13) > D(6) -> true 🥺"),
      .sourceCode(.plainText, robin_hood_hashing_4),
      .text("Now (6,6) needs a slot 😢"),
      .text("Repeating the process above until (6,6) is happy 😌"),
      .sourceCode(.plainText, robin_hood_hashing_5),
    ]),
  ]),

  Page(title: "Advanced: Google Swiss Table", contents: [
    .text("Open sourced as absl::flat_hash_map and absl::flat_hash_set"),
    .text("Also has a Rust implementation called hashbrown::HashMap"),
    .text("Haven't seen a Swift implementation yet 👀"),
    .text("An open addressing hash table that is:"),
    .indent([
      .text("Faster in basic operations"),
      .text("More compact in storage"),
      .text("More cache friendly"),
    ]),
    .text("Internally, data are stored in groups of 16 elements"),
    .indent([
      .sourceCode(.plainText, swiss_table_data_layout),
    ]),
    .text("8-bit control byte"),
    .indent([
      .sourceCode(.plainText, swiss_table_ctrl_byte),
    ]),
    .text("After a few insertions an deletions"),
    .indent([
      .sourceCode(.plainText, swiss_table_example),
    ]),
    .text("What about search?"),
    .indent([
      .text("Use h(k) to locate the first group"),
      .text("Introducing SIMD (Single Instruction, Multiple Data)"),
      .text("More specifically, need a few instructions from SSE2 (Streaming SIMD Extensions 2)"),
      .indent([
        .sourceCode(.plainText, "x86::_mm_load_si128    // Loads 128 bit into the register"),
        .sourceCode(.plainText, "x86::_mm_set1_epi8     // Broadcasts a 8 bit integer into a 128 bit integer"),
        .sourceCode(.plainText, "x86::_mm_cmpeq_epi8    // Compares two 128 bit (16 * 8 bits) integers"),
        .sourceCode(.plainText, "x86::_mm_movemask_epi8 // Collapses the 128 bit integer into a 16 bit integer"),
      ]),
      .text("Lookup in group `i`"),
      .indent([
        .sourceCode(.plainText, swiss_table_lookup),
      ]),
      .text("If found potential match, compare the key"),
      .indent([
        .text("If keys are equal, finish lookup"),
        .text("Else move to the next group"),
      ]),
    ]),
  ]),

  Page(title: "References", contents: [
    .text("Introduction to Algorithms by Cormen,Leiserson,Rivest,Stein"),
    .text("apple/swift"),
    .text("apple/swift-corelibs-foundation"),
    .text("The Swiss Army Knife of Hashmaps by Arrow of Code"),
  ]),

  Page(
    title: "What happens before main()?",
    subtitle: "Stay tuned for the next \"Implementation Detail\" talk!"
  ),

])

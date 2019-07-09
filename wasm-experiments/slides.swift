import TruffautSupport

let ownership = """
struct Person { name: String, birth: u16 }

let composers = vec![
    Person { name: "Palestrina".to_owned(), birth: 1525 },
    Person { name: "Dowland".to_owned(), birth: 1563 },
    Person { name: "Lully".to_owned(), birth: 1632 },
];
"""

let borrowing_error = """
fn show(composers: Vec<Person>) { ... }

show(composers); // <----- ownership moved, 'composers' is now uninitialized!
println!("{}", composers.len()); // compile error!
"""

let borrowing = """
struct Concert<'a> { composers: &'a Vec<Person> }

fn show(composers: &Vec<Person>) { ... }
fn sort_in_place(composers: &mut Vec<Person>) { ... }

let concert: Concert;
{
  let mut composers = ...;
  sort_in_place(&mut composers); // <----- mutable borrow, 'composers' is still valid
  show(&composers); // <----- borrow, 'composers' is still valid

  concert = Concert { composers: &composers };
}
println!("{}", concert.composers.len()); // compile error!

// error[E0597]: `composers` does not live long enough
//
//         concert = Concert { composers: &composers };
//                                        ^^^^^^^^^^ borrowed value does not live long enough
//     }
//     - `composers` dropped here while still borrowed
//     println!("{}", concert.composers.len());
//                    ----------------- borrow later used here
"""

let over_borrowing = """
fn over_borrow(
    composers: &mut Vec<Person>,
    other_composers: &mut Vec<Person>
) { ... }

over_borrow(&mut composers, &mut composers); // compile error!

// error[E0499]: cannot borrow `composers` as mutable more than once at a time
//
//     over_borrow(&mut composers, &mut composers);
//                      ---------       ^^^^^^^^^- first borrow ends here
//                      |               |
//                      |               second mutable borrow occurs here
//                      first mutable borrow occurs here
"""

let ios_app = """
Cicero for iOS
├── User Interface
│   ├── Swift (UIKit)
│   └── Objective-C (CoreText)
└── Unicode Database
    └── libucd
        ├── C Headers
        ├── Unsafe and no_mangle Rust
        ├── Unicode Data
        │   └── Rust (open-i18n/rust-unic)
        └── Full-Text Search
            └── Rust (jgallagher/rusqlite)
"""

let macos_app = """
Cicero for macOS
├── User Interface
│   └── Objective-C++ (AppKit and CoreText)
└── Unicode Database
    └── libucd-cpp
        ├── C++ Headers
        └── libucd
            ├── C Headers
            ├── Unsafe and no_mangle Rust
            ├── Unicode Data
            │   └── Rust (open-i18n/rust-unic)
            └── Full-Text Search
                └── Rust (jgallagher/rusqlite)
"""

let wasm_lang = """

🥚 - Work in progress.
🐣 - Unstable but usable.
🐥 - Stable for production usage.

Data from: appcypher/awesome-wasm-langs

=====

🐣 .Net
🐥 AssemblyScript
🥚 Astro
🐥 Brainfuck
🐥 C
🐥 C#
🐥 C++
🐥 Clean
🐣 D
🥚 Elixir
🥚 Faust
🥚 Forest
🐥 Forth
🐥 Go
🥚 Grain
🥚 Haskell
🐣 Java
🐣 JavaScript
🥚 Julia
🐣 Idris
🐣 Kotlin/Native
🥚 Kou
🐥 Lua
🐣 Lys
🥚 Nim
🥚 Ocaml
🐣 Perl
🐣 PHP
🥚 Plorth
🐣 Poetry
🐣 Python
🐣 Prolog
🐣 Ruby
🐥 Rust
🐣 Scheme
🐣 Speedy.js Unmaintained
🐣 Swift
🐣 Turboscript Unmaintained
🐥 TypeScript
🐥 Wah
🐣 Walt
🐣 Wam
🥚 Wracket Unmaintained
🥚 Xlang
🐥 Zig
"""

let presentation = Presentation(pages: [
  Page(title: "Recent Experiments", subtitle: "Rust -> [UIKitForMac, WebAssembly]"),

  Page(title: "Unicode", contents: [
    .text("Unicode provides a unique number for every character,"),
    .text("no matter what the platform,"),
    .text("no matter what the program,"),
    .text("no matter what the language."),
    .text("...and emojies!"),
    .text("Latest version 12.1 (U+32FF ㋿)"),
  ]),

  Page(title: "#UnicodeIsHard", contents: [
    .text("ICU - International Components for Unicode"),
    .indent([
      .text("The \"reference\" implementation for the Standard"),
      .text("icu4c and icu4j, latest version 64.2"),
      .text("Used widely in the industry (Google, Apple, Microsoft)"),
      .text("Initial released in 1999 (original name: IBM Classes for Unicode)"),
      .text("github.com/unicode-org/icu"),
    ]),
    .text("rust-unic: Unicode and Internationalization Crates for Rust"),
    .indent([
      .text("A Rust crate to unify many matured Unicode crates"),
      .text("Work in progress, latest version 0.9.0"),
      .text("Things I have to build from scratch as I go:"),
      .indent([
        .text("name, hangul, unihan, block, name-aliases"),
        .text("Unicode 12.1"),
      ]),
      .text("github.com/open-i18n/rust-unic"),
    ]),
  ]),

  Page(title: "Rust: Compile Time Memory Safety", contents: [
    .text("For example:"),
    .sourceCode(.rust, ownership),
    .text(""),
    .text("Using is moving (similar to std::move in C++)"),
    .text(""),
    .sourceCode(.rust, borrowing_error),
    .text(""),
    .text("Referencing is borrowing, lifetime is guaranteed"),
    .text(""),
    .sourceCode(.rust, borrowing),
    .text(""),
    .text("You can only mutable borrow a value to one borrower at a time!"),
    .text(""),
    .sourceCode(.rust, over_borrowing),
    .text(""),
  ]),

  Page(title: "Rust: Tools", contents: [
    .text("cargo: build system and package manager"),
    .indent([
      .text("Packages are called \"crates\""),
      .sourceCode(.plainText, "Cargo.toml"),
      .sourceCode(.plainText, "cargo build"),
    ]),
    .text("Language Server for code completion"),
    .text("gdb/lldb for debugging"),
  ]),

  Page(title: "Cicero: A Unicode Tool", contents: [
    .text("Released"),
    .sourceCode(.plainText, ios_app),
    .text("In Development"),
    .sourceCode(.plainText, macos_app),
    .text("Hourglass FFI (Foreign Function Interface)"),
    .indent([
      .sourceCode(.plainText, "Swift/ObjC(++) <-> C <-> Rust"),
    ]),
  ]),

  Page(title: "Demo", subtitle: "Cicero for macOS"),

  Page(title: "Catalyst", contents: [
    .text("🤔 Cicero for iOS supports iPad"),
    .text("🤔 libucd supports x86_64"),
    .text("❓ Cicero for iOS supports Catalyst?"),
    .text(""),
    .sourceCode(.plainText, "❌ Building for UIKitForMac, but linking in object file (***.o) built for macOS"),
    .text(""),
    .text("iOS (and Simulator) Target"),
    .indent([
      .sourceCode(.plainText, "arm64-apple-ios"),
      .sourceCode(.plainText, "x86_64-apple-ios"),
    ]),
    .text("macOS Target"),
    .indent([
      .sourceCode(.plainText, "x86_64-apple-darwin"),
    ]),
    .text("Catalyst Target"),
    .indent([
      .sourceCode(.plainText, "x86_64-apple-ios13.0-macabi"),
    ]),

    .text("Where is this infomation stored?"),
    .indent([
      .text("Probably in the Mach-O header"),
      .text("Story for next time: What happens before main()?"),
    ]),
  ]),

  Page(title: "WebAssembly", contents: [
    .sourceCode(.plainText, "wasm32-unknown-unknown"),
    .text("Portable binary format for web browsers (for now)"),
    .text("All supported browsers recognise the same standard format"),
    .indent([
      .text("Think of Mach-O on Darwin and ELF on Linux"),
    ]),
    .text("Also has a human readable representation: S-expression"),
    .indent([
      .text("Think of LLVM Intermediate Representation (IR)"),
    ]),
    .text("A simplified LLVM structure:"),
    .indent([
      .text("Frontend"),
      .indent([
        .text("*.c/*.cpp/*.m/*.swift/*.rs -> IR"),
        .text("Examples: clang, swift-lang, rust"),
      ]),
      .text("Optimizer"),
      .indent([
        .text("IR -> IR"),
        .text("IR mostly is represented in a binary format (bitcode)"),
        .text("But it also has a human readable format .ll"),
      ]),
      .text("Backend"),
      .indent([
        .text("IR -> .a/.dylib/.exe/.lib/.dll"),
      ]),
    ]),
    .text("To support wasm32-unknown-unknown in LLVM"),
    .indent([
      .text("New Backend: IR -> wasm32"),
    ]),
    .sourceCode(.plainText, wasm_lang),
    .text("rust-unic works in WebAssembly!"),
    .text("The same hourglass FFI"),
    .indent([
      .sourceCode(.plainText, "JavaScript <-> WebAssembly <-> Rust"),
    ]),
  ]),

  Page(title: "Demo", subtitle: "wasm-unic POC"),

  Page(title: "Thanks!", subtitle: "@eyeplum"),
])

import TruffautSupport

let objcxx_example = """
/* main.mm */

@import Foundation; // Requires -fmodules
@import std.string; // Requires -fcxx-modules

#pragma mark - An Objective-C Class

@interface Greeting: NSObject
@property (nonatomic, strong) NSString* greets;
- (instancetype)initWithGreets:(NSString *)greets NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
@end

@implementation Greeting
- (instancetype)initWithGreets:(NSString *)greets {
  if (self = [super init]) {
    _greets = greets;
  }
  return self;
}
@end

#pragma mark - A C++ Class

class Person {
  public:
    std::string mName;
};

#pragma mark - main

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    Greeting* greeting = [[Greeting alloc] initWithGreets:@"Hello"];
    const Person person{ "Yan" };
    NSLog(@"%@, %s!", [greeting greets], person.mName.c_str());
  }
  return 0;
} // Prints \"Hello, Yan!\"
"""

let clang_module_doc = """
Each time a header is included, the compiler must preprocess and parse
the text in that header and every header it includes, transitively.
This process must be repeated for every translation unit in the
application, which involves a huge amount of redundant work. In a
project with N translation units and M headers included in each
translation unit, the compiler is performing M x N work even though
most of the M headers are shared among multiple translation units.
C++ is particularly bad, because the compilation model for templates
forces a huge amount of code into headers.
...
Modules improve access to the API of software libraries by replacing
the textual preprocessor inclusion model with a more robust, more
efficient semantic model.
"""

let presentation = Presentation(pages: [
  Page(title: "Using Ojective-C++", subtitle: "Objective-C for Cocoa, C++ for Low-overhead Abstraction"),

  Page(title: "Programming Languages for Apple Platforms", subtitle: "As Iron Man Armors"),

  Page(contents: [ .image("img/c.png"),      .text("C")             ]),
  Page(contents: [ .image("img/objc.png"),   .text("Objective-C")   ]),
  Page(contents: [ .image("img/swift.png"),  .text("Swift")         ]),
  Page(contents: [ .image("img/objc++.png"), .text("Objective-C++") ]),
  Page(contents: [ .image("img/c++.png"),    .text("C++")           ]),

  Page(title: "What exactly is Objective-C++?", contents: [
    .text("Objective-C and C++ code mixed in the same source file"),
    .text("Supported by Clang (the C/C++/ObjC/ObjC++ frontend of LLVM)"),
    .text("Example:"),
    .sourceCode(.objc, objcxx_example),
  ]),

  Page(title: "Why Objective-C++ in 2019", contents: [
    .text("Cocoa Frameworks -> Objective-C"),
    .text("Cross-platform and Extreme Performance -> Rust/C or C++"),
    .indent([
      .text("C: Limited features, takes a lot effort to design and to use (e.g. libucd)"),
      .text("Rust: No foreign language interoperability at all, only foreign function interface (FFI)"),
      .indent([.text("Hourglass FFI: Swift -> C Interface -> Unsafe Unmangled Rust -> Rust")]),
      .text("C++: Supported by all major platforms, OOP/RAII are (reasonably) easy to implement"),
    ]),
  ]),

  Page(title: "Modern C++ features completes Objective-C", contents: [
    .sourceCode(.plainText, "std::unique_ptr/std::shared_ptr/std::weak_ptr"),
    .sourceCode(.plainText, "std::optional"),
    .sourceCode(.plainText, "std::move"),
    .sourceCode(.plainText, "const T&"),
    .sourceCode(.plainText, "template<typename T>"),
    .sourceCode(.plainText, "namespace"),
    .sourceCode(.plainText, "..."),
  ]),

  Page(title: "Integrate C++ projects with Xcode projects", contents: [
    .text("Use CMake to manage the C++ library project"),
    .indent([.text("Generates Makefile/Ninja/Xcode Project/Visual Studio Project")]),
    .text("Add a new Xcode External Build Tool Target"),
    .text("Add Header Search Paths and Library Search Paths"),
    .text("Link the C++ library"),
    .text("Debug with LLDB"),
  ]),

  Page(title: "Example: Cicero for macOS", subtitle: "Native GUI -> C++ API -> Rust Library"),

  Page(title: "Optimize compile time by enabling Clang Modules", contents: [
    .text("Objective-C compiles fast 🚀"),
    .indent([.image("img/compile_objc.png")]),
    .text("(Objective-)C++ compiles slow 🐌"),
    .indent([.image("img/compile_objc++_no_modules.png")]),
    .text("Clang Modules"),
    .indent([
      .text("From Clang Modules documentation:"),
      .indent([ .text(clang_module_doc)]),
    ]),
    .sourceCode(.plainText, "-fmodules -fcxx-modules 🚀"),
    .indent([.image("img/compile_objc++_modules.png")]),
  ]),

  Page(title: "Thank you!", subtitle: "@eyeplum"),
])

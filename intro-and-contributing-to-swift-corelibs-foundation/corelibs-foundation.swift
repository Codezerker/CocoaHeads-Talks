let slides = Slides(pages: [

  Cover(title: "Contribute to Swift.org", bulletPoints: ["A Personal Experience"]),

  Page(title: "Swift", bulletPoints: [
    "Announced at WWDC2014", "  -> Darwin Platforms",
    "Open sourced at WWDC2015",
    "  -> Ubuntu",
    "The community is keeping expanding it",
    "  -> BSD",
    "  -> Android",
    "  -> Cygwin",
  ]),

  Page(title: "Projects Under Swift.org", bulletPoints: [
    "Compiler and Standard Libraies",
    "Package Manager",
    "Core Libraries",
    "REPL, Debugger and Playgrounds",
  ]),

  Page(title: "swift-corelibs-foundation", bulletPoints: [
    "An implementation of Foundation without Objective-C runtime dependency",
    "The Foundation.framework for the rest of the platforms",
    "  Also referenced as -> SwiftFoundation",
    "  The Objective-C Version -> DarwinFoundation",
    "Currently, only interfaces are shared between the two",
    "  e.g. The Foundation interface update applied in Swift 3",
    "Projects can use CorelibsFoundation with Swift Package Manager",
    "  On Darwin Platforms, Swift projects will still use the DarwinFoundation",
  ]),

  Cover(title: "My Path to Contribute", bulletPoints: ["#16 of 194 / 18 commits / 806 ++ / 227 --"]),

  Page(title: "2015.06 - WWDC2015", bulletPoints: [
    "Apple announced the open source decision",
    "I was there at Presidio, 3rd Floor, Moscone West, San Francisco",
    "GOT REALLY EXCITED!",
  ]),

  Page(title: "2015.12 - github.com/apple/swift", bulletPoints: [
    "Drew a road map",
    "Spent a whole day fantasizing",
    "There was a lot of `NSUnimplemented()`",
  ]),

  Image(title: "images/swift-fantasizing.png", bulletPoints: ["A Swift Fantasizing"]),

  Cover(title: "But I was really busy.", bulletPoints: ["Back then I was working for a startup as the only iOS and macOS Developer"]),

  Page(title: "2016.03 - Changed my job", bulletPoints: [
    "Have some free time",
    "Starter Bugs on Swift Community JIRA",
    "  Fixed SR-865 (About NSUUID.UUIDString)",
    "  First Pull Request",
    "Searched again for `NSUnimplemented()`",
    "  A lot less than 2015.12",
    "  Formatters",
    "  NSAttributedString",
  ]),

  Page(title: "Picked one API to work on", bulletPoints: [
    "Formatters",
    "  The underlying implementations depends on libicu",
    "  Not familiar with libicu",
    "NSAttributedString",
    "  CFAttributedString and CFRunArray"
    "  Easy to get started",
  ]),

  Page(title: "Implemented (part of) NSAttributedString", bulletPoints: [
    "Basic Initializers",
    "Is-A Relationship Between NSAttributedString and CFAttributedString"
    "More Methods...",
  ]),

  Page(title: "2016.06 - Met the merging guys", bulletPoints: [
    "WWDC2016 - Swift Foundation Labs",
    "I was there asking questions",
    "  About dynamic loading NSBundles in Swift",
  ]),

  Cover(title: "Hey, you are the guy on github!", bulletPoints: ["Actually, how can I implement `enumerateAttributes`?"]),

  Cover(title: "Let's see the code in DarwinFoundation.", bulletPoints: ["The merging guy said."]),

  Page(title: "2016.09 - Released with Swift 3", bulletPoints: [
    "First official release of swift-corelibs-foundation",
    "Planning more for the Swift 4 release",
    "  Finishing up NSAttributedString/NSMutableAttributedString",
  ]),

  Cover(title: "The C.C.I.T.P Loop", bulletPoints: ["Checkout -> Compile -> Implement -> Test -> Pull Request"]),

  Page(title: "Checkout", bulletPoints: [
    "$ git clone ...apple/swift",
    "$ ./swift/utils/update-checkout",
    "path/to/swift.org",
    "  ├── clang",
    "  ├── lldb",
    "  ├── llvm",
    "  ├── swift",
    "  ├── swift-corelibs-foundation",
    "  ├── swift-corelibs-xctest",
    "  └── ...",
  ]),

  Page(title: "Compile on macOS", bulletPoints: [
    "Swift.org Trunk Development Toolchain",
    "Xcode",
    "Open swift-corelibs-foundation/Foundation.xcworkspace",
    "Build scheme `SwiftFoundation`",
  ]),

  Page(title: "Compile on Ubuntu", bulletPoints: [
    "$ ./swift/utils/build-script -R --xctest --foundation -j1",
    "  With `-R -j1` about 8GB of RAM is required at the linking phase",
    "  With `-r -j1`, even 12GB is not enough",
    "  llvm 3.4 (default to Ubuntu 14) won't work, use at least llvm 3.6",
    "  The building artifacts will be several GBs",
    "$ cd swift-corelibs-foundation/ && ninja build",
    "  Only builds corelibs-foundation",
    "  Faster and less resource intensive",
    "  `-j8`",
  ]),

  Page(title: "Implement", bulletPoints: [
    "The taxonomy of types",
    "  Swift only",
    "  CF only",
    "  Is-a relationship",
    "  Has-a relationship",
    "Do things without Objective-C Runtime support",
    "Consider cross platform situations",
  ]),

  Page(title: "Implement", bulletPoints: [
    "Syntax Highlighting",
    "  Xcode on macOS",
    "  Text Editor with Swift plugins on any platforms",
    "Code Completion",
    "  Xcode on macOS",
  ]),

  Page(title: "Test on macOS", bulletPoints: [
    "Same as the previous steps",
    "Xcode is your friend",
    "Build the SwiftFoundation scheme",
    "Run Test with the TestFoundation scheme",
  ]),

  Page(title: "Test on Ubuntu", bulletPoints: [
    "The compiled swift binaries must be available",
    "$ cd swift-corelibs-foundation/ && ninja test",
    "$ LD_LIBRARY_PATH=./build/Ninja-ReleaseAssert/foundation-linux-x86_64/Foundation/:./build/Ninja-ReleaseAssert/xctest-linux-x86_64/ ./build/Ninja-ReleaseAssert/foundation-linux-x86_64/TestFoundation/TestFoundation"
  ]),

  Cover(title: "Compile and Test for Ubuntu on macOS?", bulletPoints: ["Yes, with Docker."]),

  Page(title: "Swift.org on Docker", bulletPoints: [
    "Edit in OS X with Xcode",
    "Build and test in containers",
    "$ docker pull eyeplum/swift-foundation-dev",
    "  This Docker image has the latest development env built-in",
    "  llvm-3.9, cmake, ninja, etc.",
    "$ docker run -it -v /path/to/swift.org/:/swift.org eyeplum/swift-foundation-dev /bin/bash"
  ]),

  Image(title: "images/topc-make.png", bulletPoints: ["VirtualBox -> Hypervisor.framework"]),

  Page(title: "Pull Request", bulletPoints: [
    "All implementations should be paired with tests",
    "Follow the Swift.org API guideline",
    "Wait for code review",
    "@swift-ci please test and merge",
    "  If the test fails, don't panic",
    "  Check the jenkins build log to find out the issue",
    "  Sometimes it's unrelated to the pull request",
    "Get merged!  🎉 ",
  ]),

  Page(title: "Some Personal Thoughts", bulletPoints: [
    "The open side of Apple",
    "  It was really hard to peek inside anything inside the 'Apple stuff'",
    "  Now it is possible",
    "Working on the wheel makers' problems",
    "  Helps you understand the 'wheels' better",
    "  Other people may benifit from your work",
    "Have Fun!",
  ]),

  Cover(title: "Thank you!", bulletPoints: ["@eyeplum"]),
])

// MARK: - Code snippets used in slides

let functionPointerExample = """
typealias MGCopyAnswer = (@convention(c) (String) -> String)
...
let symbol = dlsym(gestalt, "MGCopyAnswer".cString(using: .utf8)!)
let function = unsafeBitCast(symbol, to: MGCopyAnswer.self)
let result = function("HardwarePlatform")
...
"""

let castingExample = """
extension NSAttributedString: _CFBridgeable {
    var _cfObject: CFAttributedString {
        return unsafeBitCast(self, to: CFAttributedString.self)
    }
}
"""

let fseventExample = """
/*
FSEventStreamContext.init(
    ..., info: UnsafeMutableRawPointer?,
    ...)
*/

var context = FSEventStreamContext(
    ...,
    info: UnsafeMutableRawPointer(Unmanaged.passUnretained(self)
                                           .toOpaque()),
    ...)

/*
func FSEventStreamCreate(
    ...,
    _ callback: @escaping FSEventStreamCallback,
    _ context: UnsafeMutablePointer<FSEventStreamContext>?,
    ...) -> FSEventStreamRef?
*/

let eventStream = FSEventStreamCreate(
    ...,
    { _, info, _, _, _, _ in
        let this = Unmanaged<FileMonitor>.fromOpaque(info!)
                                         .takeUnretainedValue()
        // do things with 'this'
    },
    &context,
    ...)
"""

let levelDBExample = """
/*
extern char* leveldb_get(
    ...,
    const char* key, size_t keylen,
    size_t* vallen,
    char** errptr);
*/

public func data(for key: String) -> Data? {
    ...
    let keyLength = key.lengthOfBytes(using: .utf8)
    var resultLength: Int = 0
    var errorPtr: UnsafeMutablePointer<Int8>? = nil
    let valueBytes = leveldb_get(...,
                                 key, keyLength,
                                 &resultLength,
                                 &errorPtr)
    let valueRawPtr = UnsafeRawPointer(valueBytes!)
    return Data(bytes: valueRawPtr, count: resultLength)
}
"""

let bytesManipulationExample = """
extension Int: DataConvertible {

    var dataRepresentation: Data {
        // using an array as a pointer
        // bytes: UnsafeRawPointer
        return Data(bytes: [self], count: MemoryLayout<Int>.size)
    }

    init?(data: Data) {
        self = data.withUnsafeBytes { ptr: UnsafePointer<Int> in
            return Int(ptr.pointee)
        }
    }
}
"""

let swiftScriptExample = """
/* hello.swift */
#!/usr/bin/env swift
print("hello world!")
"""

let linkageExample = """
$ otool -L /usr/local/bin/rycooder
/usr/local/bin/rycooder:
    /usr/lib/libobjc.A.dylib
    ...
    .../AVFoundation.framework/.../AVFoundation
    ...
    @rpath/libswiftAVFoundation.dylib
    @rpath/libswiftCore.dylib
    @rpath/libswiftCoreAudio.dylib
    @rpath/libswiftCoreMedia.dylib
    @rpath/libswiftDarwin.dylib
    @rpath/libswiftDispatch.dylib
    @rpath/libswiftFoundation.dylib
    ...
"""

let nstaskExample = """
// NSTask is exposed as Process in Swift
let process = Process()
process.launchPath = command
process.arguments = arguments
process.launch()
process.waitUntilExit()
"""

let packageManifestExample = """
/* Package.swift */
// swift-tools-version:3.1
import PackageDescription
let package = Package(
    name: "Example",
    dependencies: [
        .Package(url: <Package URL>, majorVersion: 1),
    ]
)
"""

let modulemapExample = """
/* module.modulemap */
module Clibleveldb [system] {
  header "/usr/local/include/leveldb/c.h"
  link "leveldb"
  export *
}

/* Package.swift */
import PackageDescription
let package = Package(name: "Clibleveldb")
"""

let staticLinkExample = """
$ otool -L staticLinkedSwiftExecutable
staticLinkedSwiftExecutable:
    /usr/lib/libc++.1.dylib
    .../Foundation.framework/.../Foundation
    ...
    /usr/lib/libobjc.A.dylib
    /usr/lib/libSystem.B.dylib
    /usr/lib/libicucore.A.dylib
"""

let xcodebuildWrapperExample = """
/* ScvFile */
import BuildPassDescription
let buildTask = BuildTask(
    scheme: "MyApp",
    buildConfiguration: .debug
    export: .enterprise("~/Exports"),
    steps: [
        .test,
        .analyze,
        .archive,
        .export,
    ])
let buildPass = BuildPass(tasks: [
    buildTask,
])
"""

let xcodebuildWrapperShellExample = """
# shell
$ scv
"""

let spmComments = """
/* swift-package-manager/ManifestLoader.swift */
...
// For now, we load the manifest by having Swift interpret it directly.
// Eventually, we should have two loading processes, one that loads only
// the declarative package specification using the Swift compiler directly
// and validates it.
...
"""

// MARK: - Slides

import TruffautSupport

let presentation = Presentation(title: "Mobile Refresh", authors: ["Yan Li"], pages: [

    // intro

    Page(title: "s/*/swift/", subtitle: "Replacing everything with Swift"),

    Page(contents: [
        .title("hello"),
        .text("My goal for Swift has always been and still is total world domination.\nIt’s a modest goal."),
        .text("— Chris Lattner"),
    ]),

    Page(title: "Topics", contents: [
        .text("Cocoa and Cocoa Touch Development"),
        .indent([
            .sourceCode(.plainText, ".m/.c/.cpp -> .swift"),
        ]),
        .text("Command-line Tool"),
        .indent([
            .sourceCode(.plainText, ".sh/.py/.rb -> .swift"),
        ]),
        .text("Slides"),
        .indent([
            .sourceCode(.plainText, ".keynote -> .swift"),
        ]),
    ]),

    // cocoa, cocoa touch
    // - pointer types
    // - pointer operations
    // - function pointer

    Page(title: "App Development with Swift", subtitle: "An Objective-C without C"),

    Page(title: "Pointer Types in Swift", contents: [
        .sourceCode(.swift, "UnsafePointer<T>"),
        .sourceCode(.swift, "UnsafeRawPointer<T>"),
        .sourceCode(.swift, "UnsafeBufferPointer<T>"),
        .sourceCode(.swift, "UnsafeRawBufferPointer<T>"),
        .sourceCode(.plainText, "..."),
        .sourceCode(.swift, "UnsafeMutable...Pointer<T>"),
    ]),

    Page(title: "Pointer Types in Swift", contents: [
        .sourceCode(.plainText, "Unsafe[Mutable][Raw][Buffer]Pointer<T>"),
        .indent([
            .text("No 'const' -> Mutable"),
            .text("'T' is 'Void' -> Raw"),
            .text("Direct memory access -> Buffer"),
        ]),
        .sourceCode(.swift, "OpaquePointer"),
        .indent([
            .text("Type can't be represented in Swift"),
        ]),
    ]),

    Page(title: "Function Pointer", contents: [
        .text("Top-level Swift function or closure with @convention(c)"),
        .indent([
            .sourceCode(.swift, functionPointerExample),
        ]),
        .text("No capture of context for surrounding scope in '@convention(c)' functions/closures"),
        .indent([
            .text("'self' is not availabel in the function/closure"),
            .text("If you need the context, pass it as a parameter"),
        ]),
    ]),

    Page(title: "Working with Raw Memory", contents: [
        .sourceCode(.swift, "sizeof()"),
        .indent([
            .sourceCode(.swift, "MemoryLayout<Type>.size"),
            .sourceCode(.swift, "MemoryLayout.size(ofValue: a)"),
        ]),
        .text("Casting"),
        .indent([
            .sourceCode(.swift, castingExample),
        ]),
        .text("Bypassing ARC"),
        .indent([
            .sourceCode(.swift, "Unmanaged.passUnretained(self).toOpaque()"),
        ]),
    ]),

    Page(title: "Example 1: FSEventStreamCreate", contents: [
        .sourceCode(.swift, fseventExample),
    ]),

    Page(title: "Example 2: Wrapping libleveldb", contents: [
        .sourceCode(.swift, levelDBExample),
    ]),

    Page(title: "Example 3: Convert between Int and Data", contents: [
        .sourceCode(.swift, bytesManipulationExample),
    ]),

    Page(title: "Swift & C++", contents: [
        .text("Non-interoperable by default"),
        .text("C++ -> ObjC++ -> ObjC Header -> Swift"),
        .text("C++ -> C Header -> Swift"),
        .indent([
            .sourceCode(.plainText, "NS_SWIFT_NAME"),
            .sourceCode(.plainText, "NS_TYPED_ENUM/NS_TYPED_EXTENSIBLE_ENUM"),
            .sourceCode(.plainText, "NS_NOESCAPE"),
            .sourceCode(.plainText, "NS_ASSUME_NONNULL_BEGIN/NS_ASSUME_NONNULL_END"),
            .sourceCode(.plainText, "NS_SWIFT_UNAVAILABLE"),
        ]),
    ]),

    // swift in the commandline
    // - swift-package-manager
    // - dynamic linking
    //   - system library
    //   - ABI compatibility
    // - static linking

    Page(title: "Build Command-line Tools with Swift",
         subtitle: "Make scripting less painful"),

    Page(title: "Scripting in Swift", contents: [
        .text("A Swift script:"),
        .indent([
            .sourceCode(.swift, swiftScriptExample),
        ]),
        .text("Make it runable from command-line:"),
        .indent([
            .sourceCode(.shell, "$ chmod +x hello.swift"),
        ]),
        .text("Run it like any other scripts:"),
        .indent([
            .sourceCode(.shell, "$ ./hello.swift\nhello world!"),
        ]),
    ]),

    Page(title: "Calling Other Scripts", contents: [
        .sourceCode(.swift, "import Foundation.NSTask"),
        .indent([
            .text("It will 'run another program as a subprocess'"),
        ]),
        .sourceCode(.swift, nstaskExample),
    ]),

    Page(title: "Swift Package Manager", contents: [
        .text("Comes with the Swift toolchain"),
        .text("Supports macOS and Linux"),
        .text("Can build Swift libraires and executables"),
        .indent([
            .text("Also supports C language targets"),
        ]),
        .text("Will fetch (if needed) and link dependencies for you"),
        .text("spm itself is also managed by spm"),
    ]),

    Page(title: "Using Other Swift Packages", contents: [
        .sourceCode(.swift, packageManifestExample),
    ]),

    Page(title: "Using macOS SDK", contents: [
        .text("Has no explicit support"),
        .text("But should just work"),
        .text("macOS only, not for iOS/tvOS/watchOS"),
    ]),

    Page(title: "Using System Libraries", contents: [
        .text("Create a modulemap then wrap it as a package"),
        .indent([
            .sourceCode(.plainText, modulemapExample),
        ]),
        .text("The convention is to prefix the package with 'C'"),
        .indent([
            .sourceCode(.plainText, "e.g. Clibgit, CJPEG, Clibz"),
        ]),
        .text("Add the wrapper to your Package.swift"),
        .indent([
            .sourceCode(.swift, ".Package(url: \".../Clibleveldb\", majorVersion: 0)"),
        ]),
        .text("Then provide a hint the to linker (or provide a pkg-config)"),
        .indent([
            .sourceCode(.shell, "$ swift build -Xlinker -L/lib/search/path"),
        ]),
    ]),

    Page(title: "Depending on Swift Runtime", contents: [
        .sourceCode(.shell, linkageExample),
    ]),

    Page(title: "ABI Compatibility", contents: [
        .text("ABI Compatibility should come in next year (Swift 5)"),
        .text("Before that your executable can only run on a machine with the same Swift Runtime"),
        .text("Or..."),
    ]),

    Page(title: "Static Linked Swift Runtime", contents: [
        .text("Command-line tools created with Xcode is static linked with Swift Runtime"),
        .sourceCode(.shell, staticLinkExample),
    ]),

    Page(title: "Example: Wrapping xcodebuild", contents: [
        .sourceCode(.swift, xcodebuildWrapperExample),
        .sourceCode(.shell, xcodebuildWrapperShellExample),
    ]),

    // s/keynote/swift
    // - slides.swift
    //   - parsing
    //      - SourceKit
    //      - swift-package-manager
    //   - data representation
    // - supporting library
    // - example: Lumiere -> Truffaut -> Truffaut v2

    Page(title: "Create Slides with Swift", subtitle: "Like this one"),

    Page(title: "A Swift Manifest File", subtitle: "v1"),

    Page(title: "Parsing", subtitle: "The SourceKit Way"),

    Page(contents: [
        .text("slides.swift -> SourceKit -> AST as JSON"),
        .text("The manifest file is being used as a declarative markup"),
    ]),

    Page(title: "A Swift Manifest File", subtitle: "v2"),

    Page(title: "Parsing", subtitle: "The Package Manager Way"),

    Page(contents: [
        .text("slides.swift -> swiftc --driver-mode=swift -> JSON"),
        .text("The manifest file is actually being executed"),
    ]),

    Page(contents: [
        .sourceCode(.plainText, spmComments),
    ]),

    // ending

    Page(title: "Thank you!", subtitle: "@eyeplum"),
])


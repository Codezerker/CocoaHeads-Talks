import TruffautSupport

let ucd_files = """
UCD/
├── ArabicShaping.txt
├── BidiBrackets.txt
├── BidiCharacterTest.txt
├── BidiMirroring.txt
├── BidiTest.txt
├── Blocks.txt
├── CJKRadicals.txt
├── CaseFolding.txt
├── CompositionExclusions.txt
├── DerivedAge.txt
├── DerivedCoreProperties.txt
├── DerivedNormalizationProps.txt
├── EastAsianWidth.txt
├── EmojiSources.txt
├── EquivalentUnifiedIdeograph.txt
├── HangulSyllableType.txt
├── Index.txt
├── IndicPositionalCategory.txt
├── IndicSyllabicCategory.txt
├── Jamo.txt
├── LineBreak.txt
├── NameAliases.txt
├── NamedSequences.txt
├── NamedSequencesProv.txt
├── NamesList.html
├── NamesList.txt
├── NormalizationCorrections.txt
├── NormalizationTest.txt
├── NushuSources.txt
├── PropList.txt
├── PropertyAliases.txt
├── PropertyValueAliases.txt
├── ReadMe.txt
├── ScriptExtensions.txt
├── Scripts.txt
├── SpecialCasing.txt
├── StandardizedVariants.txt
├── TangutSources.txt
├── USourceData.txt
├── USourceGlyphs.pdf
├── UnicodeData.txt
├── VerticalOrientation.txt
├── auxiliary
│   ├── GraphemeBreakProperty.txt
│   ├── GraphemeBreakTest.html
│   ├── GraphemeBreakTest.txt
│   ├── LineBreakTest.html
│   ├── LineBreakTest.txt
│   ├── SentenceBreakProperty.txt
│   ├── SentenceBreakTest.html
│   ├── SentenceBreakTest.txt
│   ├── WordBreakProperty.txt
│   ├── WordBreakTest.html
│   └── WordBreakTest.txt
└── extracted
    ├── DerivedBidiClass.txt
    ├── DerivedBinaryProperties.txt
    ├── DerivedCombiningClass.txt
    ├── DerivedDecompositionType.txt
    ├── DerivedEastAsianWidth.txt
    ├── DerivedGeneralCategory.txt
    ├── DerivedJoiningGroup.txt
    ├── DerivedJoiningType.txt
    ├── DerivedLineBreak.txt
    ├── DerivedName.txt
    ├── DerivedNumericType.txt
    └── DerivedNumericValues.txt
"""

let grapheme_break_rules = """
× 	No boundary (do not allow break here)

--------------- Unicode 10.0 -----------------
GB10  (E_Base | EBG) Extend × E_Modifier
GB11  ZWJ × (Glue_After_Zwj | EBG)

--------------- Unicode 11.0 -----------------
GB11  Extended_Pictographic Extend ZWJ × Extended_Pictographic
"""

let presentation = Presentation(pages: [

    // intro

    Page(title: "Unicode and You", subtitle: "try { Unicode::Explain(); } catch (...) {}"),

    Page(title: "Why the function throws?", contents: [
        .image("images/the-unicode-standard.jpg"),
        .text("#UnicodeIsHard"),
    ]),

    Page(title: "Topics", contents: [
        .text("The Unicode Standard"),
        .text("Working with Unicode"),
        .text("Books and Tools"),
    ]),

    // Unicode Standard

    Page(title: "The Unicode Standard", subtitle: "A Whirlwind Tour"),

    Page(title: "What is Unicode?", contents: [
        .text("Unicode provides a unique number for every character,"),
        .text("no matter what the platform,"),
        .text("no matter what the program,"),
        .text("no matter what the language."),
    ]),

    Page(title: "Character number and Character name", contents: [
        .text("Every character in Unicode (called a code point) has two unique identifiers:"),
        .indent([
            .text("Character number"),
            .text("Character name"),
        ]),
        .text("Examples:"),
        .indent([
            .sourceCode(.plainText, "       Character : é"),
            .sourceCode(.plainText, "Character number : U+00E9 (233 in decimal)"),
            .sourceCode(.plainText, "  Character name : LATIN SMALL LETTER E WITH ACUTE"),
            .text(""),
            .sourceCode(.plainText, "       Character : 龑"),
            .sourceCode(.plainText, "Character number : U+9F91 (40,849 in decimal)"),
            .sourceCode(.plainText, "  Character name : CJK UNIFIED IDEOGRAPH-9F91"),
            .text(""),
            .sourceCode(.plainText, "       Character : 💻"),
            .sourceCode(.plainText, "Character number : U+1F4BB (128,187 in decimal)"),
            .sourceCode(.plainText, "  Character name : PERSONAL COMPUTER"),
        ]),
    ]),

    Page(title: "Ranges of Character number", contents: [
        .text("Coding space"),
        .indent([
            .sourceCode(.plainText, "U+0000..U+10FFFF"),
            .text("1,114,111 in total"),
            .text(""),
        ]),
        .text("Coding space is divided into 17 planes, each has 0xFFFF(65535) of space"),
        .indent([
            .sourceCode(.plainText, "U+0000..U+FFFF"),
            .text("Basic Multilingual Plane (BMP): most used characters"),
            .text(""),
            .sourceCode(.plainText, "U+10000..U+1FFFF"),
            .text("Supplementary Multilingual Plane (SMP): special symbols"),
            .text(""),
            .sourceCode(.plainText, "U+20000..U+2FFFF"),
            .text("Supplementary Ideographic Plane (SIP): less used CJK characters"),
            .text("CJK: Chinese-Japanese-Korean"),
            .text(""),
            .sourceCode(.plainText, "U+30000..U+DFFFF"),
            .text("Unassigned, reserved for future use"),
            .text(""),
            .sourceCode(.plainText, "U+E0000..U+EFFFF"),
            .text("Supplementary Special-Purpose Plane (SSPP): reserved for internal use"),
            .text(""),
            .sourceCode(.plainText, "U+F0000..U+10FFFF"),
            .text("Designed for custom private use"),
            .text(""),
        ]),
        .text("Planes are further divided into blocks"),
        .indent([
            .sourceCode(.plainText, "U+0000..U+007F"),
            .text("Basic Latin"),
            .text(""),
            .text("Block name is unique"),
            .text("Block ranges never overlap, always follow the pattern U+nnn0..U+nnnF"),
            .text(""),
            .text("There are 291 blocks in Unicode 11.0"),
        ]),
    ]),

    Page(title: "Demo", subtitle: "Plane -> Block -> Character"),

    Page(title: "The Unicode Database (UCD)", contents: [
        .sourceCode(.plainText, ucd_files),
        .text(""),
        .text("A row in UnicodeData.txt (for character ö):"),
        .indent([
            .text(""),
            .sourceCode(.plainText, "00F6;LATIN SMALL LETTER O WITH DIAERESIS;Ll;0;L;006F 0308;...;00D6;;00D6"),
            .text(""),
            .sourceCode(.plainText, "             00F6 - Character number"),
            .sourceCode(.plainText, "LATIN...DIAERESIS - Character name"),
            .sourceCode(.plainText, "               Ll - Letter, lowercase"),
            .sourceCode(.plainText, "        006F 0308 - Decomposition: o(U+006F) +  ̈(U+0308)"),
            .sourceCode(.plainText, "       00D6;;00D6 - Uppercase, titlecase: Ö(U+00D6)"),
        ]),
    ]),

    Page(title: "Text segmentations in UCD", contents: [
        .sourceCode(.plainText, "GraphemeBreakProperty.txt"),
        .sourceCode(.plainText, "WordBreakProperty.txt"),
        .sourceCode(.plainText, "SentenceBreakProperty.txt"),
        .sourceCode(.plainText, "LineBreak.txt"),
        .text(""),
        .text("Very important for text layout and text editing"),
    ]),

    Page(title: "Grapheme cluster", contents: [
        .text("Multiple Unicode code points act as one character"),
        .text("Example:"),
        .indent([
            .sourceCode(.plainText, "é"),
            .indent([
                .sourceCode(.plainText, "U+0065 LATIN SMALL LETTER E"),
                .sourceCode(.plainText, "U+0301 COMBINING ACUTE ACCENT"),
            ]),
            .sourceCode(.plainText, "🇳🇿"),
            .indent([
                .sourceCode(.plainText, "U+1F1F3 REGIONAL INDICATOR SYMBOL LETTER N"),
                .sourceCode(.plainText, "U+1F1FF REGIONAL INDICATOR SYMBOL LETTER Z"),
            ]),
            .sourceCode(.plainText, "👨‍👩‍👧‍👦"),
            .indent([
                .sourceCode(.plainText, "U+1F468 MAN"),
                .sourceCode(.plainText, "U+200D  ZERO WIDTH JOINER"),
                .sourceCode(.plainText, "U+1F469 WOMAN"),
                .sourceCode(.plainText, "U+200D  ZERO WIDTH JOINER"),
                .sourceCode(.plainText, "U+1F467 GIRL"),
                .sourceCode(.plainText, "U+200D  ZERO WIDTH JOINER"),
                .sourceCode(.plainText, "U+1F466 BOY"),
            ]),
        ]),
        .text("Unicode 11.0 simplified grapheme break rules"),
        .indent([
            .sourceCode(.plainText, grapheme_break_rules),
        ]),
    ]),

    Page(title: "Demo", subtitle: "Grapheme clusters"),

    Page(title: "Unicode encodings: UTF-32", contents: [
        .text("32-bit -> 4 bytes"),
        .text("Code points only need 21-bit (U+0000..U+10FFFF)"),
        .indent([
            .text("First 7-bit is plane number"),
            .text("The following 16-bit is the location in the plane"),
        ]),
        .text("32-bit fits"),
        .indent([
            .text("+ Fast encoding and decoding (direct mapping)"),
            .text("+ Random access is O(1)"),
            .text("+ Robust"),
            .text("- Waste of space"),
        ]),
    ]),

    Page(title: "Unicode encodings: UTF-16", contents: [
        .text("BMP (U+0000..U+FFFF): 16-bit -> 2 bytes"),
        .text("Outside BMP (U+1FFFF..U+10FFFF): a pair of 16-bit -> 2 * 2 bytes"),
        .text("Surrogate pair:"),
        .indent([
            .sourceCode(.plainText, "𝐅 U+1D405 MATHEMATICAL BOLD CAPITAL F"),
            .sourceCode(.plainText, "000011101010000000101 // U+1D405 in binary"),
            .sourceCode(.plainText, "u1 = 00001 | u2 = 110101 | u3 = 0000000101"),
            .sourceCode(.plainText, "u1 -= 1"),
            .sourceCode(.plainText, "110110u1u2 = 1101100000110101 // U+D835, high surrogate"),
            .sourceCode(.plainText, "  110111u3 = 1101110000000101 // U+DC05, low surrogate"),
        ]),
        .text("+ BMP encoding and decoding is fast (direct mapping)"),
        .text("+ Robust, high surrogate must always be followed by low surrogate"),
        .text("- Random access is O(n)"),
    ]),

    Page(title: "Unicode encodings: UTF-8", contents: [
        .text("Basic Latin (ASCII) (U+0000..U+007F): 8-bit -> 1 byte"),
        .text("Outside ASCII: up to 32-bit -> up to 4 bytes"),
        .indent([
            .sourceCode(.plainText, "   Code point in binary | Octec 1  Octec 2  Octec 3  Octec 4"),
            .sourceCode(.plainText, "      00000000 0xxxxxxx | 0xxxxxxx"),
            .sourceCode(.plainText, "      00000yyy yyxxxxxx | 110yyyyy 10xxxxxx"),
            .sourceCode(.plainText, "      zzzzyyyy yyxxxxxx | 1110zzzz 10yyyyyy 10xxxxxx"),
            .sourceCode(.plainText, "uuuww zzzzyyyy yyxxxxxx | 11110uuu 10wwzzzz 10yyyyyy 10xxxxxx"),
        ]),
        .text("+ ASCII encoding and decoding is fast (direct mapping) and efficient (1 byte)"),
        .text("+ Robust, bit pattern enforces completeness"),
        .text("- Random access is O(n)"),
    ]),

    // Working with Unicode

    Page(title: "Working with Unicode", subtitle: "\"👴🏻\".length // => 4 🤔"),

    Page(title: "UI Toolkits usually uses UTF-16 to represent strings", contents: [
        .text("NSString, QString, etc."),
        .text("Possiblly because GUI usually requires good coverage of BMP"),
        .text("Use `length` with care!!"),
        .text("It could mean any of these:"),
        .indent([
            .text("Number of grapheme clusters"),
            .text("Number of UTF-16 code units"),
            .text("Number of UTF-8 bytes"),
        ]),
        .indent([
            .sourceCode(.swift, "import Foundation"),
            .sourceCode(.plainText, "let string = \"👴🏻\" as NSString"), // syntax hightlighting doesn't like the emoji
            .sourceCode(.swift, "string.length // => 4"),
            .text(""),
            .sourceCode(.plainText, "👴 U+1F474 OLDER MAN => 0xD83D 0xDC74"),
            .sourceCode(.plainText, "🏻 U+1F3FB EMOJI MODIFIER FITZPATRICK TYPE-1-2 => 0xD83C 0xDFFB"),
        ]),
    ]),

    Page(title: "Modern Programming Language Standard Libraries", contents: [
        .text("Usually are (fully) compliant to Unicode"),
        .text("Provide APIs to manipulate code points"),
        .indent([
            .sourceCode(.plainText, "let string = \"👴🏻\""),
            .sourceCode(.plainText, "string.count // => 1"),
            .sourceCode(.plainText, "string.unicodeScalars // => ['\u{0001F474}', '\u{0001F3FB}']"),
            .sourceCode(.plainText, "// 👴 U+1F474 OLDER MAN"),
            .sourceCode(.plainText, "// 🏻 U+1F3FB EMOJI MODIFIER FITZPATRICK TYPE-1-2"),
        ]),
    ]),

    Page(title: "ICU - International Components for Unicode", contents: [
        .text("The \"reference\" implementation for the Unicode Standard"),
        .text("Open source"),
        .text("icu4c and icu4j, latest version 62.1"),
        .text("Used widely in the industry (Google, Apple, Microsoft)"),
        .text("Initial released in 1999 (original name: IBM Classes for Unicode)"),
        .text("github.com/unicode-org/icu"),
    ]),

    Page(title: "rust-unic", contents: [
        .text("Modern API"),
        .text("Modulized"),
        .text("Safe"),
        .text("🚧 Under development"),
        .text("github.com/open-i18n/rust-unic"),
    ]),

    // Books and Tools

    Page(title: "Books and Apps", subtitle: "📖 🔨"),

    Page(contents: [
        .image("images/unicode-explained.jpg"),
        .text("Chapter 4, 5, 6"),
    ]),

    Page(contents: [
        .image("images/unicode-checker.png"),
        .text("UnicodeChecker by earthlingsoft"),
    ]),

    Page(contents: [
        .image("images/cicero.jpg"),
        .text("Cicero: A Unicode® Tool by Codezerker"),
        .text(""),
        .text(""),
        .text(""),
        .text(""),
        .text(""),
        .text("❤️ FREE FOR SERATO PEEPS"),
        .text("Ask @yan for an App Store redemption code"),
    ]),

    Page(title: "Thank you!"),
])

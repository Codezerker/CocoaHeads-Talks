import TruffautSupport

let hello_world = """
fn main() {
    println!("Hello world!");
}
"""

let type_inference = """
let string = "hello world";

let mut vector = vec![];
vector.push(1);
"""

let unicode_name = """
/// unic::ucd::name::Name
#[derive(Copy, Clone, Debug, Eq, PartialEq, Hash)]
enum Name<'a> {
    NR1(char),
    NR2(&'a str, char),
    NR3(&'a [&'a str]),
}
"""

let ownership = """
struct Person { name: String, birth: i32 }

let mut composers = Vec::new();
composers.push(
    Person { name: "Palestrina".to_string(), birth: 1525 }
);
composers.push(
    Person { name: "Dowland".to_string(), birth: 1563 }
);
composers.push(
    Person { name: "Lully".to_string(), birth: 1632 }
);
"""

let borrowing_error = """
fn show(composers: Vec<Person>) { ... }

show(composers); // <----- ownership moved, 'composers' is now uninitialized!
println!("{}", composers.len()); // compile error!
"""

let borrowing = """
fn show(composers: &Vec<Person>) { ... }
fn sort_in_place(composers: &mut Vec<Person>) { ... }

sort_in_place(&mut composers); // <----- mutable borrow, 'composers' is still valid
show(&composers); // <----- borrow, 'composers' is still valid
println!("{}", composers.len());
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

let slides = Presentation(pages: [

   Page(title: "Introduction to Rust",
        subtitle: "Fast as C/C++, Safe as Swift"),

   Page(title: "You could have been using Rust already!", contents: [
       .text("The Servo Browser Engine"),
       .image("servo.png"),
       .text("Mozilla Firefox 57 Quantum and later"),
       .image("firefox.png"),
   ]),

   Page(title: "hello_world.rs", contents: [
       .sourceCode(.rust, hello_world),
   ]),

   Page(title: "Modern language features", contents: [
       .text("Type inference"),
       .indent([.sourceCode(.rust, type_inference)]),
       .text("Enum and pattern matching"),
       .text("Trait and generics"),
       .indent([.sourceCode(.rust, unicode_name)]),
       .text("Unicode comliant char/str types in std"),
       .indent([
           .text("Primitive Type 'char' is a Unicode scalar value"),
           .text("Primitive Type 'str' is a UTF-8 string slice"),
           .text("std::string::String is a UTF-8 encoded, growable string"),
       ]),
       .text("Error handling"),
       .text("Tuples"),
       .text("..."),
   ]),

   Page(title: "Memory safety at compile time", contents: [
       .text("When the owner is dropped, the owned value is dropped too"),
       .indent([
           .sourceCode(.rust, ownership),
           .text(""),
           .image("ownership-tree.png"),
       ]),
       .text("Using is moving"),
       .indent([.sourceCode(.rust, borrowing_error)]),
       .text("Referencing is borrowing"),
       .indent([.sourceCode(.rust, borrowing)]),
       .text("You can only mutable borrow a value to one borrower at a time!"),
       .indent([.sourceCode(.rust, over_borrowing)]),
   ]),

   Page(title: "Minimal runtime", contents: [
       .text("No runtime checks"),
       .text("Atomic operation happens only when necessary"),
       .text("Compile time generated generic"),
       .text("C ABI compatibility"),
   ]),

   Page(title: "Rust and Swift", contents: [
       .text("Use Rust to replace C/C++ as the high performance component"),
       .text("Use Swift to implement the program logic and call native APIs"),
       .text("Examples:"),
       .indent([
           .text("google/xi-editor"),
           .text("sindresorhus/gifski-app"),
       ]),
   ]),

   Page(title: "Thank you!", subtitle: "@eyeplum"),
])

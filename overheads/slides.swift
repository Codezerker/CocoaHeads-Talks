import TruffautSupport

let objc_static = """
// main.m

#import <Foundation/Foundation.h>

static const NSUInteger CONST_INTEGER = 1001;
static NSUInteger STATIC_INTEGER = 1002;

typedef struct MyStruct {
  NSUInteger a;
  NSUInteger b;
} MyStruct;

static const MyStruct CONST_STRUCT = { 1003, 1004 };
static MyStruct STATIC_STRUCT = { 1005, 1006 };

int main(int argc, char ** argv) {
  NSUInteger a = CONST_INTEGER;
  NSUInteger b = STATIC_INTEGER;
  MyStruct c = CONST_STRUCT;
  MyStruct d = STATIC_STRUCT;
  return 0;
}
"""

let objc_static_asm = """
## $ clang main.m -S

_main:                                ## @main
  pushq %rbp                          ## Pushes the stack frame
  movq  %rsp, %rbp                    ## Copy stack pointer to base pointer
  xorl  %eax, %eax                    ## Set return value to 0
  movl  $0, -4(%rbp)                  ## argc
  movl  %edi, -8(%rbp)                ## argv[0]
  movq  %rsi, -16(%rbp)               ## argv[1]
  movq  $1001, -24(%rbp)              ## a = CONST_INTEGER
  movq  _STATIC_INTEGER(%rip), %rsi   ## b = STATIC_INTEGER
  movq  %rsi, -32(%rbp)
  movq  _CONST_STRUCT(%rip), %rsi     ## c.a = CONST_STRUCT.a
  movq  %rsi, -48(%rbp)
  movq  _CONST_STRUCT+8(%rip), %rsi   ## c.b = CONST_STRUCT.b
  movq  %rsi, -40(%rbp)
  movq  _STATIC_STRUCT(%rip), %rsi    ## d.a = STATIC_STRUCT.a
  movq  %rsi, -64(%rbp)
  movq  _STATIC_STRUCT+8(%rip), %rsi  ## d.b = STATIC_STRUCT.b
  movq  %rsi, -56(%rbp)
  popq  %rbp                          ## Pop the stack frame
  retq
_STATIC_INTEGER:
  .quad 1002
_CONST_STRUCT:
  .quad 1003
  .quad 1004
_STATIC_STRUCT:
  .quad 1005
  .quad 1006
"""

let swift_static = """
// https://godbolt.org/z/-rXeWi

struct StaticWrapper {
    static let const_int: UInt = 1001
    static var static_int: UInt = 1002
}

func my_function() {
    let a = StaticWrapper.const_int
    let b = StaticWrapper.static_int
}
"""

let swift_static_asm = """
## ...

output.StaticWrapper.const_int.unsafeMutableAddressor : Swift.UInt:
        pushq   %rbp
        movq    %rsp, %rbp
        leaq    globalinit_33_60494E8B9C642A7C4A26F3A3B6CECEB9_token0(%rip), %rdi
        leaq    globalinit_33_60494E8B9C642A7C4A26F3A3B6CECEB9_func0(%rip), %rsi
        callq   swift_once@PLT
        leaq    (static output.StaticWrapper.const_int : Swift.UInt)(%rip), %rax
        popq    %rbp
        retq

## ...

output.StaticWrapper.static_int.unsafeMutableAddressor : Swift.UInt:
        pushq   %rbp
        movq    %rsp, %rbp
        leaq    globalinit_33_60494E8B9C642A7C4A26F3A3B6CECEB9_token1(%rip), %rdi
        leaq    globalinit_33_60494E8B9C642A7C4A26F3A3B6CECEB9_func1(%rip), %rsi
        callq   swift_once@PLT
        leaq    (static output.StaticWrapper.static_int : Swift.UInt)(%rip), %rax
        popq    %rbp
        retq

output.my_function() -> ():
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $64, %rsp

## let a = StaticWrapper.const_int
        callq   (output.StaticWrapper.const_int.unsafeMutableAddressor : Swift.UInt)

        movq    (%rax), %rax
        movq    %rax, %rcx
        movq    %rax, -32(%rbp)

## let b = StaticWrapper.static_int
        callq   (output.StaticWrapper.static_int.unsafeMutableAddressor : Swift.UInt)

        movl    $32, %edx
        xorl    %esi, %esi
        movl    %esi, %ecx
        leaq    -24(%rbp), %rdi
        movq    %rdi, -40(%rbp)
        movq    %rax, %rdi
        movq    -40(%rbp), %rsi
        movq    %rax, -48(%rbp)
        callq   swift_beginAccess@PLT
        movq    -48(%rbp), %rax
        movq    (%rax), %rcx
        movq    -40(%rbp), %rdi
        movq    %rcx, -56(%rbp)
        callq   swift_endAccess@PLT
        movq    -56(%rbp), %rax
        movq    -32(%rbp), %rax
        movq    -56(%rbp), %rcx
        addq    $64, %rsp
        popq    %rbp
        retq
"""

let objc_func_args = """
// https://godbolt.org/z/dHR9NR

#include <stdint.h>

uint64_t sum(
    uint8_t a,
    uint16_t b,
    uint32_t c,
    uint64_t d,
    uint64_t e,
    uint64_t f,
    uint64_t g
) {
    return a + b + c + d + e + f + g;
}
"""

let objc_func_args_asm = """
sum:                                    # @sum
        pushq   %rbp
        movq    %rsp, %rbp
        movw    %si, %ax
        movb    %dil, %r10b
        movq    16(%rbp), %r11
        movb    %r10b, -1(%rbp)         ## a
        movw    %ax, -4(%rbp)           ## b
        movl    %edx, -8(%rbp)          ## c
        movq    %rcx, -16(%rbp)         ## d
        movq    %r8, -24(%rbp)          ## e
        movq    %r9, -32(%rbp)          ## f
        movzbl  -1(%rbp), %edx
        movzwl  -4(%rbp), %esi
        addl    %esi, %edx
        addl    -8(%rbp), %edx
        movl    %edx, %edx
        movl    %edx, %ecx
        addq    -16(%rbp), %rcx
        addq    -24(%rbp), %rcx
        addq    -32(%rbp), %rcx
        addq    16(%rbp), %rcx          ## g
        movq    %rcx, %rax
        movq    %r11, -40(%rbp)         # 8-byte Spill
        popq    %rbp
        retq
"""

let swift_func_args = """
// https://godbolt.org/z/X8Jdpn

func sum(
    a: UInt8,
    b: UInt16,
    c: UInt32,
    d: UInt64,
    e: UInt64,
    f: UInt64,
    g: UInt64
) -> UInt64 {
    // return UInt64(a) + UInt64(b) + UInt64(c) + d + e + f + g
    return 0;
}
"""

let swift_func_args_asm = """
output.sum(a: Swift.UInt8, b: Swift.UInt16, c: Swift.UInt32, d: Swift.UInt64, e: Swift.UInt64, f: Swift.UInt64, g: Swift.UInt64) -> Swift.UInt64:
        pushq   %rbp
        movq    %rsp, %rbp
        movw    %si, %ax
        movb    %dil, %r10b
        movq    16(%rbp), %r11
        movb    $0, -8(%rbp)
        movw    $0, -16(%rbp)
        movl    $0, -24(%rbp)
        movq    $0, -32(%rbp)
        movq    $0, -40(%rbp)
        movq    $0, -48(%rbp)
        movq    $0, -56(%rbp)
        movb    %r10b, -8(%rbp)         ## a
        movw    %ax, -16(%rbp)          ## b
        movl    %edx, -24(%rbp)         ## c
        movq    %rcx, -32(%rbp)         ## d
        movq    %r8, -40(%rbp)          ## e
        movq    %r9, -48(%rbp)          ## f
        movq    %r11, -56(%rbp)         ## g
        xorl    %edx, %edx
        movl    %edx, %eax
        popq    %rbp
        retq
"""

let objc_stack_struct = """
// https://godbolt.org/z/RPszoq

#include <stdint.h>

typedef struct StructA {
    uint64_t a;
    uint64_t b;
} StructA;

typedef struct StructB {
    uint64_t a;
} StructB;

typedef struct StructAB {
    StructA a;
    StructB b;
} StructAB;

void my_function() {
    StructA s_a = { 1001, 1002 };
    StructB s_b = { 1003 };
    StructAB ab = { s_a, s_b };
}
"""

let objc_stack_struct_asm = """
my_function:                            # @my_function
        pushq   %rbp
        movq    %rsp, %rbp

## Struct s_a = { 1001, 1002 };
        movq    .L__const.my_function.s_a, %rax
        movq    %rax, -16(%rbp)        
        movq    .L__const.my_function.s_a+8, %rax
        movq    %rax, -8(%rbp)
        
## Struct s_b = { 1003 };        
        movq    .L__const.my_function.s_b, %rax
        movq    %rax, -24(%rbp)

## Struct ab = { s_a, s_b };
        movq    -16(%rbp), %rax         # ab
        movq    %rax, -48(%rbp)
        movq    -8(%rbp), %rax          # s_a
        movq    %rax, -40(%rbp)
        movq    -24(%rbp), %rax         # s_b
        movq    %rax, -32(%rbp)
        
        popq    %rbp
        retq
.L__const.my_function.s_a:
        .quad   1001                    # 0x3e9
        .quad   1002                    # 0x3ea

.L__const.my_function.s_b:
        .quad   1003                    # 0x3eb
"""

let swift_stack_struct = """
// https://godbolt.org/z/OaQssa

struct StructA {
    let a: UInt64
    let b: UInt64
}

struct StructB {
    let a: UInt64
}

struct StructAB {
    let a: StructA
    let b: StructB
}

func my_function() {
    let a = StructA(a: 1001, b: 1002)
    let b = StructB(a: 1003)
    _ = StructAB(a: a, b: b)
}
"""

let swift_stack_struct_asm = """
## ...

output.my_function() -> ():
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $64, %rsp
        xorps   %xmm0, %xmm0
        movaps  %xmm0, -16(%rbp)
        movl    $1001, %eax
        movl    %eax, %edi        # 1st args 1001
        movl    $1002, %eax
        movl    %eax, %esi        # 2nd args 1002
## let a = StructA(a: 1001, b: 1002)
        callq   (output.StructA.init(a: Swift.UInt64, b: Swift.UInt64) -> output.StructA)
        movq    %rax, -16(%rbp)   # save return value to -16(%rbp)
        movq    %rdx, -8(%rbp)
        movl    $1003, %ecx
        movl    %ecx, %edi        # 1st args 1003
        movq    %rax, -24(%rbp)   # save previous return value to -24(%rbp)
        movq    %rdx, -32(%rbp)
## let b = StructB(a: 1003)
        callq   (output.StructB.init(a: Swift.UInt64) -> output.StructB)
        movq    %rax, %rdx
        movq    -24(%rbp), %rdi   # 1st args read from -24(%rbp) -> a
        movq    -32(%rbp), %rsi   # 2nd args read from -32(%rbp) -> b
        movq    %rax, %rdx
        movq    %rax, -40(%rbp)
## _ = StructAB(a: a, b: b)
        callq   (output.StructAB.init(a: output.StructA, b: output.StructB) -> output.StructAB)
        movq    -40(%rbp), %rsi
        movq    %rax, -48(%rbp)
        movq    %rdx, -56(%rbp)
        movq    %rcx, -64(%rbp)
        addq    $64, %rsp
        popq    %rbp
        retq

## ...
"""

let swift_stack_enum = """
// https://godbolt.org/z/Pqs-1F

struct MyStruct {
    let a: UInt64
    let b: UInt64
}

enum MyEnum {
    case simple
    case withInt(UInt64)
    case withStruct(MyStruct)
}

func my_function() -> (MyEnum, MyEnum, MyEnum) {
    let a = MyEnum.simple
    let b = MyEnum.withInt(1001)
    let c = MyEnum.withStruct(MyStruct(a: 1002, b: 1003))
    return (a, b, c)
}
"""

let swift_stack_enum_asm = """
## ...

output.my_function() -> (output.MyEnum, output.MyEnum, output.MyEnum):
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $112, %rsp
        xorps   %xmm0, %xmm0
        movaps  %xmm0, -32(%rbp)
        movb    $0, -16(%rbp)
        movaps  %xmm0, -64(%rbp)
        movb    $0, -48(%rbp)
        movaps  %xmm0, -96(%rbp)
        movb    $0, -80(%rbp)
        movq    $0, -32(%rbp)
        movq    $0, -24(%rbp)
        movb    $2, -16(%rbp)
        movq    $1001, -64(%rbp)
        movq    $0, -56(%rbp)
        movb    $0, -48(%rbp)
        movl    $1002, %ecx
        movl    %ecx, %edi
        movl    $1003, %ecx
        movl    %ecx, %esi
        movq    %rax, -104(%rbp)
        callq   (output.MyStruct.init(a: Swift.UInt64, b: Swift.UInt64) -> output.MyStruct)
        movq    %rax, -96(%rbp)
        movq    %rdx, -88(%rbp)
        movb    $1, -80(%rbp)
        movq    -104(%rbp), %rsi
        movq    $0, (%rsi)
        movq    $0, 8(%rsi)
        movb    $2, 16(%rsi)
        movq    $1001, 24(%rsi)
        movq    $0, 32(%rsi)
        movb    $0, 40(%rsi)
        movq    %rax, 48(%rsi)
        movq    %rdx, 56(%rsi)
        movb    $1, 64(%rsi)
        addq    $112, %rsp
        popq    %rbp
        retq

## ...
"""

let objc_stack_array = """
// https://godbolt.org/z/hGP5Wd

#include <stdint.h>

void my_function() {
    int64_t int_array[4];
    int_array[0] = 1000;
    int_array[1] = 1001;
    int_array[2] = 1002;
    int_array[3] = 1003;
}
"""

let objc_stack_array_asm = """
my_function:                            # @my_function
        pushq   %rbp
        movq    %rsp, %rbp
        movq    $1000, -32(%rbp)        # imm = 0x3E8
        movq    $1001, -24(%rbp)        # imm = 0x3E9
        movq    $1002, -16(%rbp)        # imm = 0x3EA
        movq    $1003, -8(%rbp)         # imm = 0x3EB
        popq    %rbp
        retq
"""

let objc_heap_obj = """
#import <Foundation/Foundation.h>

@interface MyObject: NSObject
@end
@implementation MyObject
@end

MyObject* CreateMyObject() {
  return [[MyObject alloc] init];
}

int main(int argc, char ** argv) {
  @autoreleasepool {
    MyObject* obj = CreateMyObject();
  }
  return 0;
}
"""

let objc_heap_objc_asm = """
## ...

_CreateMyObject:                        ## @CreateMyObject
  .cfi_startproc
## %bb.0:
  pushq %rbp
  .cfi_def_cfa_offset 16
  .cfi_offset %rbp, -16
  movq  %rsp, %rbp
  .cfi_def_cfa_register %rbp
  subq  $16, %rsp
  movq  L_OBJC_CLASSLIST_REFERENCES_$_(%rip), %rdi      ## MyObject
  movq  L_OBJC_SELECTOR_REFERENCES_(%rip), %rsi         ## _cmd = @selector(alloc)
  movq  _objc_msgSend@GOTPCREL(%rip), %rax              ## %rax = &objc_msgSend()
  movq  %rax, -8(%rbp)          ## 8-byte Spill
  callq *%rax                                           ## objc_msgSend(self, _cmd)
  movq  L_OBJC_SELECTOR_REFERENCES_.2(%rip), %rsi       ## _cmd = @selector(init)
  movq  %rax, %rdi                                      ## self = $return_value_of_alloc
  movq  -8(%rbp), %rax          ## 8-byte Reload
  callq *%rax                                           ## objc_msgSend(self, _cmd)
  movq  %rax, %rdi
  addq  $16, %rsp
  popq  %rbp
  jmp _objc_autoreleaseReturnValue ## TAILCALL          ## objc_autoreleaseReturnValue(..)
  .cfi_endproc
                                        ## -- End function
  .globl  _main                   ## -- Begin function main
  .p2align  4, 0x90
_main:                                  ## @main
  .cfi_startproc
## %bb.0:
  pushq %rbp
  .cfi_def_cfa_offset 16
  .cfi_offset %rbp, -16
  movq  %rsp, %rbp
  .cfi_def_cfa_register %rbp
  subq  $32, %rsp
  movl  $0, -4(%rbp)
  movl  %edi, -8(%rbp)
  movq  %rsi, -16(%rbp)
  callq _objc_autoreleasePoolPush
  movq  %rax, -32(%rbp)         ## 8-byte Spill
  callq _CreateMyObject
  movq  %rax, %rdi
  callq _objc_retainAutoreleasedReturnValue             ## objc_retainAutoreleasedReturnValue(..)
  xorl  %ecx, %ecx
  movl  %ecx, %esi
  movq  %rax, -24(%rbp)
  leaq  -24(%rbp), %rax
  movq  %rax, %rdi
  callq _objc_storeStrong
  movq  -32(%rbp), %rdi         ## 8-byte Reload
  callq _objc_autoreleasePoolPop
  xorl  %eax, %eax
  addq  $32, %rsp
  popq  %rbp
  retq
  .cfi_endproc

## ...
"""

let swift_heap_obj = """
// https://godbolt.org/z/6sYk0s

class MyClass {}

func create_my_class() -> MyClass {
    return MyClass()
}

func use_my_class(obj: MyClass) {}

func my_function() {
    var obj = create_my_class()
    use_my_class(obj: obj)

    let const_obj = create_my_class()
    use_my_class(obj: const_obj)
}
"""

let swift_heap_obj_asm = """
## ...

output.create_my_class() -> output.MyClass:
        pushq   %rbp
        movq    %rsp, %rbp
        pushq   %r13
        pushq   %rax
        xorl    %eax, %eax
        movl    %eax, %edi
        callq   (type metadata accessor for output.MyClass)
        movq    %rax, %r13
        movq    %rdx, -16(%rbp)
        callq   (output.MyClass.__allocating_init() -> output.MyClass)
        addq    $8, %rsp
        popq    %r13
        popq    %rbp
        retq

## ...

output.my_function() -> ():
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $32, %rsp
        movq    $0, -8(%rbp)

## var obj = create_my_class()
        callq   (output.create_my_class() -> output.MyClass)
        movq    %rax, -8(%rbp)

## swift_retain(obj)
        movq    %rax, %rdi
        movq    %rax, -16(%rbp)
        callq   swift_retain@PLT

## use_my_class(obj: obj)
        movq    -16(%rbp), %rdi
        movq    %rax, -24(%rbp)
        callq   (output.use_my_class(obj: output.MyClass) -> ())

## swift_release(obj)
        movq    -16(%rbp), %rdi
        callq   swift_release@PLT

## let const_obj = create_my_class()
        callq   (output.create_my_class() -> output.MyClass)
        
## use_my_class(obj: const_obj)
        movq    %rax, %rdi
        ## InlineAsm Start
        ## InlineAsm End
        movq    %rax, %rdi        ## 🤔
        movq    %rax, -32(%rbp)
        callq   (output.use_my_class(obj: output.MyClass) -> ())

## swift_release(const_obj)
        movq    -32(%rbp), %rdi
        callq   swift_release@PLT

## swift_release(obj)
        movq    -8(%rbp), %rdi
        callq   swift_release@PLT

## the return value of my_function() will be 
## the return value of use_my_class(obj: const_obj)
        movq    -32(%rbp), %rax

        addq    $32, %rsp
        popq    %rbp
        retq

## ...
"""

let cpp_heap_obj = """
// https://godbolt.org/z/-Llayj

#include <memory>

struct MyStruct {};

void my_function() {
    auto ptr = std::make_shared<MyStruct>();
    auto ptr_copy = ptr;
    auto ptr_move = std::move( ptr );
}
"""

let cpp_heap_obj_asm = """
my_function():                       # @my_function()
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $48, %rsp
        leaq    -16(%rbp), %rdi
        callq   std::shared_ptr<MyStruct> std::make_shared<MyStruct>()
        leaq    -32(%rbp), %rdi
        leaq    -16(%rbp), %rsi
        callq   std::shared_ptr<MyStruct>::shared_ptr(std::shared_ptr<MyStruct> const&)
        leaq    -16(%rbp), %rdi
        callq   std::remove_reference<std::shared_ptr<MyStruct>&>::type&& std::move<std::shared_ptr<MyStruct>&>(std::shared_ptr<MyStruct>&)
        leaq    -48(%rbp), %rdi
        movq    %rax, %rsi
        callq   std::shared_ptr<MyStruct>::shared_ptr(std::shared_ptr<MyStruct>&&)
        leaq    -48(%rbp), %rdi
        callq   std::shared_ptr<MyStruct>::~shared_ptr() [base object destructor]
        leaq    -32(%rbp), %rdi
        callq   std::shared_ptr<MyStruct>::~shared_ptr() [base object destructor]
        leaq    -16(%rbp), %rdi
        callq   std::shared_ptr<MyStruct>::~shared_ptr() [base object destructor]
        addq    $48, %rsp
        popq    %rbp
        retq

## ...
"""

let swift_functions = """
// https://godbolt.org/z/s3idsZ

import Foundation

protocol MyProtocol {
    func myProtocolFunction()
}

extension MyProtocol {
    func myProtocolFunction() {}
}

struct MyStruct {
    func structFunction() {}
}

struct MyStructWithProtocol: MyProtocol {}

class MyClass {
    func myFunction() {}
    dynamic func myDynamicFunction() {}
}
class MyNSClass: NSObject {
    func myNSFunction() {}
}

func my_function() {
    MyStruct().structFunction()
    MyStructWithProtocol().myProtocolFunction()
    MyClass().myFunction()
    MyClass().myDynamicFunction()
    MyNSClass().myNSFunction()
}
"""

let swift_functions_asm = """
## ..

## MyStruct.structFunction()
        callq   (output.MyStruct.init() -> output.MyStruct)
        callq   (output.MyStruct.structFunction() -> ())

## MyStructWithProtocol().myProtocolFunction()
        callq   (output.MyStructWithProtocol.init() -> output.MyStructWithProtocol)
        leaq    (full type metadata for output.MyStructWithProtocol)+8(%rip), %rdi
        leaq    (protocol witness table for output.MyStructWithProtocol : output.MyProtocol in output)(%rip), %rsi
        callq   ((extension in output):output.MyProtocol.myProtocolFunction() -> ())
        xorl    %eax, %eax
        movl    %eax, %esi

## MyClass().myFunction()
        movq    %rsi, %rdi
        movq    %rsi, -16(%rbp)
        callq   (type metadata accessor for output.MyClass)
        movq    %rax, %r13
        movq    %rax, -24(%rbp)
        movq    %rdx, -32(%rbp)
        callq   (output.MyClass.__allocating_init() -> output.MyClass)
        movq    (%rax), %rdx
        movq    80(%rdx), %rdx
        movq    %rax, %r13
        movq    %rax, -40(%rbp)
        callq   *%rdx
        movq    -40(%rbp), %rdi
        callq   swift_release@PLT

## MyClass().myDynamicFunction()
        movq    -24(%rbp), %r13
        callq   (output.MyClass.__allocating_init() -> output.MyClass)
        movq    (%rax), %rdx
        movq    88(%rdx), %rdx
        movq    %rax, %r13
        movq    %rax, -48(%rbp)
        callq   *%rdx
        movq    -48(%rbp), %rdi
        callq   swift_release@PLT

## MyNSClass().myNSFunction()
        movq    -16(%rbp), %rdi
        callq   (type metadata accessor for output.MyNSClass)
        movq    %rax, %r13
        movq    %rdx, -56(%rbp)
        callq   (output.MyNSClass.__allocating_init() -> output.MyNSClass)
        movq    (%rax), %rdx
        movq    208(%rdx), %rdx
        movq    %rax, %r13
        movq    %rax, -64(%rbp)
        callq   *%rdx

## ...
"""

let presentation = Presentation(pages: [
  Page(title: "Overhead of Data Types and Function Calls", subtitle: "With Examples in  C;  C++;  [Obj c];  .swift"),

  Page(contents: [
    .image("onepage_x86-64.png"),
    .text("x86_64 One Pager"),
  ]),

  Page(title: "Static Memory"),

  Page(title: "Static Memory (C;)", contents: [
    .sourceCode(.c, objc_static),
    .text(""),
    .sourceCode(.plainText, objc_static_asm),
  ]),
  Page(title: "Static Memory (.swift)", contents: [
    .sourceCode(.swift, swift_static),
    .text(""),
    .sourceCode(.plainText, swift_static_asm),
  ]),

  Page(title: "Runtime Memory"),

  Page(title: "Stack Memory and Heap Allocation", contents: [
    .text("Stack Memory: Memory on the current stack frame"),
    .indent([
      .text("Size must be known at compile time"),
      .text("Fast"),
      .text("The same area gets repurposed when stack frame gets popped"),
    ]),
    .text("Heap Allocation: Memory are allocated on the heap"),
    .indent([
      .text("Size can be arbitrary"),
      .text("Slow"),
      .text("Allocated area needs to be managed (e.g. marked as freed when no longer in use)"),
    ]),
  ]),

  Page(title: "On the Stack"),

  Page(title: "Function Arguments (C;)", contents: [
    .sourceCode(.c, objc_func_args),
    .text(""),
    .sourceCode(.plainText, objc_func_args_asm),
  ]),
  Page(title: "Function Arguments (.swift)", contents: [
    .sourceCode(.swift, swift_func_args),
    .text(""),
    .sourceCode(.plainText, swift_func_args_asm),
  ]),

  Page(title: "Stack Structs (C;)", contents: [
    .sourceCode(.c, objc_stack_struct),
    .text(""),
    .sourceCode(.plainText, objc_stack_struct_asm),
  ]),
  Page(title: "Stack Structs (.swift)", contents: [
    .sourceCode(.swift, swift_stack_struct),
    .text(""),
    .sourceCode(.plainText, swift_stack_struct_asm),
  ]),

  Page(title: "Stack Enums (.swift)", contents: [
    .sourceCode(.swift, swift_stack_enum),
    .text(""),
    .sourceCode(.plainText, swift_stack_enum_asm),
  ]),

  Page(title: "Stack Optionals", contents: [
    .text("No optionals in C"),
    .text("nullable is only an annotation supported by the compiler in Obj-C"),
    .text("std::optional in C++ is a templated class"),
    .text("std::option::Option in Rust is an enum"),
    .text("Swift.Optional is an enum"),
  ]),

  Page(title: "Stack Arrays (C;)", contents: [
    .sourceCode(.c, objc_stack_array),
    .text(""),
    .sourceCode(.plainText, objc_stack_array_asm),
  ]),

  Page(title: "Stack Arrays (.swift)", contents: [
    .text("Not possible"),
  ]),

  Page(title: "Heap Allocations"),

  Page(title: "Referencing Heap Allocated Objects ([Obj c];)", contents: [
    .sourceCode(.objc, objc_heap_obj),
    .text(""),
    .sourceCode(.plainText, objc_heap_objc_asm),
  ]),
  Page(title: "Referencing Heap Allocated Objects (.swift)", contents: [
    .sourceCode(.swift, swift_heap_obj),
    .text(""),
    .sourceCode(.plainText, swift_heap_obj_asm),
  ]),
  Page(title: "std::shared_ptr (C++;)", contents: [
    .sourceCode(.cpp, cpp_heap_obj),
    .text(""),
    .sourceCode(.plainText, cpp_heap_obj_asm),
  ]),

  Page(title: "Standard Libraries", contents: [
    .text("Most useful data types in Standard Libraries are heap allocated"),
    .indent([
      .text("Dynamic Array (Vector)"),
      .text("Hash Map (Dictionary)"),
      .text("String"),
      .text("..."),
    ]),
    .text("Move semantics reduces a lot of work"),
    .text("RAII (Resource Acquisition Is Initialization)"),
  ]),

  Page(title: "Functions"),

  Page(title: "Static Function Call and Runtime Dispatch", contents: [
    .text("Static Function Call"),
    .indent([
      .text("The function address is known at compile time"),
      .text("Single instruction: call fn"),
      .text("Fast"),
    ]),
    .text("Runtime Dispatch"),
    .indent([
      .text("The function address is resolved at runtime"),
      .text("vtable / fat pointers"),
      .text("Can be slower"),
    ]),
  ]),

  Page(title: "Function Calls (.swift)", contents: [
    .sourceCode(.swift, swift_functions),
    .text(""),
    .sourceCode(.plainText, swift_functions_asm),
  ]),

  Page(title: "OK..."),

  Page(title: "What Have We Learned", contents: [
    .text("Constness is good"),
    .text("Move is good"),
    .text("Swift wraps static variables in a \"dispatch_once\""),
    .text("Swift struct has a smaller overhead compared to class"),
    .text("Swift enum/optional/tuple have very small overhead"),
    .text("Obj-C/Swift class is always heap allocated and uses dynamic dispatch (except final?)"),
    .text("Assembly generated by Swift compiler can be quite confusing"),
  ]),

  Page(title: "A Few Things We Didn't Cover", contents: [
      .text("CPU Cache"),
      .text("Anonymous Functions (Block / Lambda / Closure)"),
      .text("Generics / C++ Templates"),
      .text("Allocations in Rust"),
      .indent([
        .text("https://speice.io/2019/02/understanding-allocations-in-rust.html"),
      ]),
  ]),

  Page(title: "Questions?", subtitle: "@eyeplum"),
])

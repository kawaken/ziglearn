const std = @import("std");

pub fn assignment() void {
    const constant: i32 = 5; // 定数
    var variable: u32 = 5000; // 変数

    std.log.info("constant {}, variable {}", .{ constant, variable });

    // 変数なので再代入可能
    variable = 10000;
    std.log.info("variable can be changed {}", .{variable});

    // @as(type, value) で代入することもできる
    const inferred_constant = @as(i32, 5);
    var inferred_variable = @as(u32, 5000);

    std.log.info("inferred, constant {}, variable {}", .{ inferred_constant, inferred_variable });

    // 型推論される場合 type は省略可能
    var inferred = variable;
    std.log.info("inferred variable {}", .{inferred});

    // typeを指定している場合には `undefined` を代入することが可能
    var a: i32 = undefined;
    std.log.info("a {}", .{a}); // 何かしらの値にはなるっぽい

    // 未使用の変数はコンパイルエラーになる
    // var unused: i32 = 0;
    // src/main.zig:24:9: error: unused local variable
    //     var unused: i32 = 0;
    //         ^
}

pub fn arrays() void {
    // a の type は配列リテラルから推論される
    const a = [5]u8{ 'h', 'e', 'l', 'l', 'o' };

    // length は配列リテラルから推論される
    const b = [_]u8{ 'w', 'o', 'r', 'l', 'd' };

    std.log.info("{} {}", .{ a.len, b.len });

    // 変数の type を記述していても配列リテラルのtypeは指定しないと行けないっぽい
    var c: [3]i32 = [_]i32{ 1, 2, 3 };
    // こう書くとコンパイルエラー
    //var c: [3]i32 = { 1, 2, 3 };
    // これもコンパイルエラー
    //var c: [_]i32 = [_]i32{ 1, 2, 3 };

    c[1] = 10;

    // 要素へのアクセスは 0 オリジン
    std.log.info("{} {} {}", .{ c[0], c[1], c[2] });

    // 要素数が異なる代入はできない
    // var d: [4]i32 = c;
    // std.log.info("{}", .{d.len});
    // ./src/main.zig:53:21: error: expected type '[4]i32', found '[3]i32'
    //     var d: [4]i32 = c;
    //                     ^
}

pub fn if_() void {
    const a = true;
    if (a) {
        std.log.info("true", .{});
    }

    const b = false;
    if (!b) {
        std.log.info("not false", .{});
    }

    const i = 1;
    if (i == 0) {
        // unreached
    } else if (i == 1) {
        std.log.info("else if", .{});
    } else {
        // unreached
    }

    // if は式なので値を返すことができる
    const j = if (i == 0) 10 else 20;
    std.log.info("{}", .{j});
}

pub fn main() anyerror!void {
    //assignment();
    //arrays();
    if_();
}

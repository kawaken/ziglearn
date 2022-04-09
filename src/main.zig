const std = @import("std");

pub fn assignment() void {
    const constant: i32 = 5;    // 定数
    var variable: u32 = 5000;   // 変数

    std.log.info("constant {}, variable {}", .{constant, variable});

    // 変数なので再代入可能
    variable = 10000;
    std.log.info("variable can be changed {}", .{variable});

    // @as(type, value) で代入することもできる
    const inferred_constant = @as(i32, 5);
    var inferred_variable = @as(u32, 5000);

    std.log.info("inferred, constant {}, variable {}", .{inferred_constant, inferred_variable});

    // typeを指定している場合には `undefined` を代入することが可能
    var  a: i32 = undefined;
    std.log.info("a {}", .{a}); // 何かしらの値にはなるっぽい

    // 未使用の変数はコンパイルエラーになる
    // var unused: i32 = 0;
    // src/main.zig:24:9: error: unused local variable
    //     var unused: i32 = 0;
    //         ^
}

pub fn main() anyerror!void {
    assignment();
}
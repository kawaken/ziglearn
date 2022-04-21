const std = @import("std");

fn assignment() void {
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

fn arrays() void {
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

fn if_() void {
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

fn while_() void {
    var i: u8 = 2;

    // 100を超えるまで2倍になっていくので、i = 64 の時には実行される
    while (i < 100) {
        // 最後は 64 * 2 なので 128 となる
        i *= 2;
    }
    std.log.info("i: {}", .{i}); // i: 128

    var sum: u8 = 0;
    var j: u8 = 1;
    
    // continue expression はブロックを抜ける際に実行される
    while (j <= 10) : (j += 1) {
        // 1, 2 (1 + 1), 3 (2 + 1), ..., 10 まで表示される
        std.log.info("j: {}", .{j});
        sum += j;
    }
    std.log.info("sum: {}", .{sum}); // 55

    while (j < 1) : (sum += 100) {
        // do nothing
    }
    // 今回の continue expression は実行されないので 55 のまま
    std.log.info("sum: {}", .{sum}); // 55

    var k: u8 = 0;
    while (k <= 3) : (k += 1) {
        if (k == 1) continue;
        if (k == 3) break;
        std.log.info("k: {}", .{k}); // 0, 2
    }
}

fn for_() void {
    const nums = [_]u8{10, 20, 30};

    // 要素、インデックスの順で記述する
    for (nums) |number, index| {
        std.log.info("{} : {}", .{number, index});
    }

    // 単体だと要素になる
    for (nums) |number| {
        std.log.info("{}", .{number});
    }

    // _ を使用して利用しない値を無視できる
    for (nums) |_, index| {
        std.log.info("{}", .{index});

        // もちろん対象は配列なのでインデックスで参照可能
        std.log.info("{}", .{nums[index]});
    }
}

fn add(x: u32, y: u32) u32 {
    // 引数はイミュータブルなので再代入できない
    // コンパイルエラーになる
    // x = 10;
    // ./src/main.zig:147:9: error: cannot assign to constant
    //     x = 10;
    return x + y;
}

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

fn function() void {
    const a = add(1, 2);
    std.log.info("a: {}", .{a});

    // 戻値を無視するときは明示的に記述する
    _ = add(100, 200);

    // コンパイルエラーになる
    // add(100, 200);
    // ./src/main.zig:158:8: error: expression value is ignored
    //     add(100, 200);

    // 再帰呼び出しはオーバーフローが発生する可能性があるのでunsafe
    const x = fibonacci(24);
    std.log.info("x: {}", .{x});

    // コンパイルエラーではない
    //const y = fibonacci(25);
    //std.log.info("y: {}", .{y});

    // 25 以降は u16 を超えるため panic が発生する
    // thread 1118951 panic: integer overflow
}

pub fn main() anyerror!void {
    //assignment();
    //arrays();
    //if_();
    //while_();
    //for_();
    function();
}

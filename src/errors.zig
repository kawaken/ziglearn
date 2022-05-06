const std = @import("std");

// Enumのように定義する
const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

// 関数の戻値を error union として定義できる
fn failingFunction() error{Oops}!void {
    return error.Oops;
}

fn catchError() void {
    failingFunction() catch |err| {
        std.log.info("Oops: {}", .{err == error.Oops});
        // catch のブロックから return は関数自体の return になる
        return;
    };

    // ここには到達しない
    std.log.info("unreached", .{});
}

fn tryError() error{Oops}!i32 {
    // try は catch したエラーをそのまま返す syntax sugar
    // failingFunction() catch |err| { return err; };
    try failingFunction();

    // ↑ error.Oops を返しているのでここは到達しない
    return 12;
}

var problem: u32 = 98;
// ! の前の error の型は返される型から推論される
fn errorDefer() !u32 {
    errdefer problem += 1;
    try failingFunction();

    // ↑ error.Oops を返しているのでここは到達しない
    return 1;
}

pub fn errors() void {
    const AllocationError = error{OutOfMemory};
    // FileOpenError ⊇ AllocationError として扱われる
    const err: FileOpenError = AllocationError.OutOfMemory;

    // どちらの `OutOfMemory` も同じ
    std.log.info("Same error: {}", .{err == FileOpenError.OutOfMemory});
    std.log.info("Same error: {}", .{FileOpenError.OutOfMemory == AllocationError.OutOfMemory});

    // AllocationError か u16 のどちらかという型（error union型）
    var mayby_error: AllocationError!u16 = 10;

    // errorとのユニオン型は catch を用いて unwrap する
    // catch の後にエラーだった際の値を指定する
    const no_error = mayby_error catch 0;

    // エラーではないので 10
    std.log.info("no_error: {}", .{no_error});

    // errorを代入する
    mayby_error = AllocationError.OutOfMemory;
    const catched_error = mayby_error catch 100;

    // エラーだったので catch で指定された 100
    std.log.info("no_error: {}", .{catched_error});

    // err はすでに const で定義済みなので再代入できずコンパイルエラーになる
    // _ = mayby_error catch |err| {
    //     std.log.info("error: {}", .{err});
    // };

    _ = mayby_error catch |captured_err| {
        std.log.info("error: {}", .{captured_err});
        // info: error: error.OutOfMemory
    };

    // captured_err は2回目だが catch でスコープが閉じているため再利用できる
    _ = mayby_error catch |captured_err| {
        std.log.info("error（2回目）: {}", .{captured_err});
        // info: error: error.OutOfMemory
    };

    catchError();

    // catch label: { break :lable value } で値を返すことができる
    const returned_value = mayby_error catch |captured_err| blk: {
        std.log.info("error（3回目）: {}", .{captured_err});
        break :blk 1000;
    };
    std.log.info("returned_value: {}", .{returned_value});
    // info: returned_value: 1000

    // tryError は error{Oops}!i32 なので値を受け取る必要がある
    _ = tryError() catch |terr| {
        std.log.info("Oops: {}", .{terr == error.Oops});
    };

    const t: anyerror!u8 = 10;
    // try は xcath |err| return err なのでエラーで無ければ通常の値となる
    const v = try t;
    std.log.info("v: {}", .{v});
    // info: v: 10

    // if を使用して unwrap できる
    const try_error = blk: {
        if (tryError()) |num| {
            // unreachable
            std.log.info("num: {}", .{num});
            break :blk num;
        } else |terr| {
            std.log.info("Oops: {}", .{terr == error.Oops});
            break :blk 10;
        }
    };

    std.log.info("try_error: {}", .{try_error});

    _ = errorDefer() catch blk: {
        // errodefer で +1 されているので 99 になる
        std.log.info("problem: {}", .{problem});
        break :blk 100;
    };

    // Error sets はマージできる
    const A = error{Boo, Foo};
    const B = error{Woo};
    const C = A || B;

    std.log.info("C: {}, {}, {}", .{C.Boo, C.Foo, C.Woo});
}

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

    catchError();

    // tryError は error{Oops}!i32 なので値を受け取る必要がある
    // ここでは ignore している
    _ = tryError() catch |terr| {
        std.log.info("Oops: {}", .{terr == error.Oops});
    };

    // catch ブロックを利用して値を返す、というのがまだわからない
}

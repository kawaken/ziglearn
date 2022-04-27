const std = @import("std");

pub fn check() void {
    const a: i8 = 5;

    // これもコンパイルエラーになる？？？ バグ？
    // switch (a) {
    //     0...4 => std.log.info("0 以上 4 以下", .{}),
    //     5 => std.log.info("5", .{})
    // }

    // これはOK
    switch (a) {
        0...4 => std.log.info("0 以上 4 以下", .{}),
        5...6 => std.log.info("5", .{})
    }

    // これもOK
    switch (a) {
        0...3 => std.log.info("0 以上 4 以下", .{}),
        4...5 => std.log.info("4 以上 5 以下", .{})
    }

    // これはNG
    // switch (a) {
    //     0...3 => std.log.info("0 以上 4 以下", .{}),
    //     4 => std.log.info("4", .{}),
    //     5 => std.log.info("5", .{})
    // }

    // これもNG
    // switch (a) {
    //     0 => std.log.info("0", .{}),
    //     1 => std.log.info("1", .{}),
    //     2 => std.log.info("2", .{}),
    //     3 => std.log.info("3", .{}),
    //     4 => std.log.info("4", .{}),
    //     5 => std.log.info("5", .{}),
    // }

    // これはOK
    switch (a) {
        0 => std.log.info("0", .{}),
        1 => std.log.info("1", .{}),
        2 => std.log.info("2", .{}),
        3 => std.log.info("3", .{}),
        4 => std.log.info("4", .{}),
        5...6 => std.log.info("5...6", .{}),
    }
}
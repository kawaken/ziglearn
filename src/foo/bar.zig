const std = @import("std");

pub const public = "public";
const private = "private";

pub fn hello() void {
    std.log.info("hello", .{});
}
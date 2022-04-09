const std = @import("std");

pub fn assignment() void {
    const constant: i32 = 5;
    var variable: u32 = 5000;

    std.log.info("constant {}, variable {}", .{constant, variable});

    variable = 10000;
    std.log.info("variable can be changed {}", .{variable});

    const inferred_constant = @as(i32, 5);
    var inferred_variable = @as(u32, 5000);

    std.log.info("inferred, constant {}, variable {}", .{inferred_constant, inferred_variable});

}

pub fn main() anyerror!void {
    assignment();
}
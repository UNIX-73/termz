pub const zterm = @import("src/termz/termz.zig");
pub const anzi = @import("src/anzi/anzi.zig");

const std = @import("std");

pub fn main() void {
    const old_config = zterm.mode.set_raw_mode() catch return;

    var buf: [40]u8 = undefined;
    const code = anzi.sgr.color.bg_rgb_code(0, 0, 0, &buf) catch {
        std.debug.print("Error1", .{});
        return;
    };

    var buf2: [80]u8 = undefined;
    zterm.io.write(anzi.sgr.wrap_sgr_code(code, &buf2) catch {
        return;
    });

    zterm.mode.set_term_mode(old_config) catch return;
}

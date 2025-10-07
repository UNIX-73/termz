pub const zterm = @import("src/termz/termz.zig");
pub const anzi = @import("src/anzi/anzi.zig");

const std = @import("std");

pub fn main() void {
    const old_config = zterm.mode.set_raw_mode() catch return;

    const anzi_color = anzi.sgr.color;

    const bg_color = anzi_color.bg_rgb(255, 255, 255);
    const fg_color = anzi_color.fg_rgb(0, 0, 0);

    var bg_buf: [18]u8 = undefined;
    var fg_buf: [18]u8 = undefined;

    const bg_slice = bg_color.get_formatted_code(&bg_buf) catch return;
    const fg_slice = fg_color.get_formatted_code(&fg_buf) catch return;

    var fmt_buf: [500]u8 = undefined;

    // Creamos un array fijo de slices constantes
    var codes_array: [2][]const u8 = .{ bg_slice, fg_slice };
    const codes: [][]const u8 = codes_array[0..];

    const fmt: []u8 = fmt_buf[0..];

    const combined = anzi.sgr.wrap_combine_sgr_codes(codes, fmt) catch return;

    zterm.io.write(combined);

    zterm.mode.set_term_mode(old_config) catch return;
}

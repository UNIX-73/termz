pub const termz = @import("src/termz/termz.zig");
pub const anzi = @import("src/anzi/anzi.zig");

const std = @import("std");

pub fn main() void {
    const old_config = termz.mode.set_raw_mode() catch return;

    const anzi_color = anzi.sgr.color;
    const anzi_style = anzi.sgr.style;

    const bg_color = anzi_color.enum_bg_rgb(255, 255, 255);
    const fg_color = anzi_color.enum_fg_rgb(0, 0, 0);

    var bg_buf: [19]u8 = undefined;
    var fg_buf: [19]u8 = undefined;

    const bg_slice = bg_color.get_formatted_code(&bg_buf) catch return;
    const fg_slice = fg_color.get_formatted_code(&fg_buf) catch return;

    var fmt_buf: [500]u8 = undefined;

    // Creamos un array fijo de slices constantes
    var codes_array: [2][]const u8 = .{ bg_slice, fg_slice };

    const combined = anzi.sgr.wrap_combine_sgr_codes(&codes_array, &fmt_buf) catch return;

    termz.io.write(combined);

    termz.io.write("asaaaaaa\n");

    const nc = anzi_color.codes.RESET_CODE;
    var buf2: [19]u8 = undefined;
    const reset = anzi.sgr.wrap_sgr_code(nc, &buf2) catch return;

    termz.mode.set_term_mode(old_config) catch return;

    anzi_color.set_fg_rgb_color(255, 0, 0);

    termz.io.write(reset);

    anzi_style.test_style_codes();
    anzi_style.StyleCodeEnum.Reset.send();
    anzi_style.StyleCodeEnum.Blink_Slow.send();
}

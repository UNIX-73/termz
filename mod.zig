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

    const bg_slice = bg_color.as_code(&bg_buf) catch return;
    const fg_slice = fg_color.as_code(&fg_buf) catch return;

    var fmt_buf: [500]u8 = undefined;

    // Creamos un array fijo de slices constantes
    var codes_array: [2][]const u8 = .{ bg_slice, fg_slice };

    const combined = anzi.sgr.wrap_combine_sgr_slices(&codes_array, &fmt_buf) catch return;

    const t = anzi.cursor_control.CursorControlEnum{ .CURSOR_HOME = {} };
    std.debug.print("{d}", .{t.get_required_buf_size()});

    termz.io.write(combined);

    termz.io.write("asaaaaaa\n");

    const nc = anzi_color.codes.RESET_CODE;
    var buf2: [19]u8 = undefined;
    const reset = anzi.sgr.wrap_sgr_code(nc, &buf2) catch return;

    anzi_color.set_fg_rgb_color(255, 0, 0);

    termz.io.write(reset);

    var buf: [200]u8 = undefined;

    const v1 = anzi_color.enum_fg_rgb(0, 255, 0);
    const v2 = anzi_color.enum_bg_theme(.Blue);

    const result = anzi.sgr.wrap_combine_sgr_codes(
        &.{
            anzi.sgr.SgrEnum{ .ColorCode = v1 },
            anzi.sgr.SgrEnum{ .ColorCode = v2 },
            anzi.sgr.SgrEnum{ .StyleCode = .DoubleUnderline },
        },
        &buf,
    ) catch {
        std.debug.print("wrap combine failed", .{});
        return;
    };

    termz.io.write(result);
    termz.io.write("\njdsa\n");

    anzi.sgr.send_combine_sgr_codes(&.{
        anzi.sgr.SgrEnum{ .ColorCode = anzi_color.enum_fg_theme(.Blue) },
        anzi.sgr.SgrEnum{ .ColorCode = anzi_color.enum_bg_theme(.BrightMagenta) },
        anzi.sgr.SgrEnum{ .StyleCode = .DoubleUnderline },
        anzi.sgr.SgrEnum{ .StyleCode = .Blink_Slow },
        anzi.sgr.SgrEnum{ .StyleCode = .Overlined },
    });

    termz.io.write("\nsdaskd 222\n");

    t.send();

    anzi_style.StyleCodeEnum.Reset.send();

    const win_size = termz.window.get_term_size() catch return;

    std.debug.print("win_size: {d}x{d}", .{
        win_size.ws_col,
        win_size.ws_row,
    });

    anzi.erase_functions.EraseFunctionEnum.ERASE_DISPLAY.send();

    (anzi.screen_mode.ScreenModeEnum{ .SET_MODE = .MODE_19 }).send();

    anzi.private_mode.PrivateModeEnum.ALT_BUFFER_ENABLE.send();

    termz.mode.set_term_mode(old_config) catch return;

    
}

const fmt = @import("std").fmt;

const types = @import("types.zig");
pub const codes = @import("codes.zig");
pub const ThemeColors = types.ThemeColors;
pub const RgbColor = types.RgbColor;

pub const ColorCodes = union(enum) {
    FG_THEME: ThemeColors,
    BG_THEME: ThemeColors,
    FG_8BIT: u8,
    BG_8BIT: u8,
    FG_RGB: RgbColor,
    BG_RGB: RgbColor,
    FG_DEFAULT,
    BG_DEFAULT,
    RESET,

    pub fn get_formatted_code(self: ColorCodes, buf: []u8) ![]const u8 {
        return switch (self) {
            .FG_THEME => |v| {
                return try fmt.bufPrint(buf, codes.FG_THEME_CODE, .{v.as_fg_code()});
            },
            .BG_THEME => |v| {
                return try fmt.bufPrint(buf, codes.BG_THEME_CODE, .{v.as_bg_code()});
            },
            .FG_8BIT => |v| {
                return try fmt.bufPrint(buf, codes.FG_8BIT_CODE, .{v});
            },
            .BG_8BIT => |v| {
                return try fmt.bufPrint(buf, codes.BG_8BIT_CODE, .{v});
            },
            .FG_RGB => |v| {
                return try fmt.bufPrint(buf, codes.FG_RGB_CODE, .{ v.r, v.g, v.b });
            },
            .BG_RGB => |v| {
                return try fmt.bufPrint(buf, codes.BG_RGB_CODE, .{ v.r, v.g, v.b });
            },
            .FG_DEFAULT => codes.FG_DEFAULT_CODE[0..],
            .BG_DEFAULT => codes.BG_DEFAULT_CODE[0..],
            .RESET => codes.RESET_CODE[0..],
        };
    }
};

pub fn fg_theme(theme: ThemeColors) ColorCodes {
    return .{ .FG_THEME = theme };
}
pub fn bg_theme(theme: ThemeColors) ColorCodes {
    return .{ .BG_THEME = theme };
}
pub fn fg_8bit(val: u8) ColorCodes {
    return .{ .FG_8BIT = val };
}
pub fn bg_8bit(val: u8) ColorCodes {
    return .{ .BG_8BIT = val };
}
pub fn fg_rgb(r: u8, g: u8, b: u8) ColorCodes {
    return .{ .FG_RGB = .{ .r = r, .g = g, .b = b } };
}
pub fn bg_rgb(r: u8, g: u8, b: u8) ColorCodes {
    return .{ .BG_RGB = .{ .r = r, .g = g, .b = b } };
}

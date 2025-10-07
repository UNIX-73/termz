const fmt = @import("std").fmt;

const types = @import("types.zig");
pub const ThemeColors = types.ThemeColors;

pub const ColorCodes = enum {
    THEME,
    FG_8BIT,
    BG_8BIT,
    FG_RGB,
    BG_RGB,
    FG_DEFAULT,
    BG_DEFAULT,
    RESET,

    pub fn get_code(self: ColorCodes) []const u8 {
        return switch (self) {
            .THEME => "{d}",
            .FG_8BIT => "38;5;{d}",
            .BG_8BIT => "48;5;{d}",
            .FG_RGB => "38;2;{d};{d};{d}",
            .BG_RGB => "48;2;{d};{d};{d}",
            .FG_DEFAULT => "39",
            .BG_DEFAULT => "49",
            .RESET => "0",
        };
    }
};

pub fn fg_theme_code(theme: ThemeColors, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        ColorCodes.THEME.get_code(),
        .{theme.as_fg_code()},
    );
}

pub fn bg_theme_code(theme: ThemeColors, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        ColorCodes.THEME.get_code(),
        .{theme.as_bg_code()},
    );
}

pub fn fg_8bit_code(color: u8, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        ColorCodes.FG_8BIT.get_code(),
        .{color},
    );
}

pub fn bg_8bit_code(color: u8, buf: []u8) !u8 {
    return try fmt.bufPrint(
        buf,
        ColorCodes.BG_8BIT.get_code(),
        .{color},
    );
}

pub fn fg_rgb_code(r: u8, g: u8, b: u8, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        ColorCodes.FG_RGB.get_code(),
        .{ r, g, b },
    );
}

pub fn bg_rgb_code(r: u8, g: u8, b: u8, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        ColorCodes.BG_RGB.get_code(),
        .{ r, g, b },
    );
}

const types = @import("types.zig");

const buf_print = @import("std").fmt.bufPrint;
const stdout_write = @import("../../../termz/termz.zig").io.write;

pub const codes = @import("codes.zig");

pub const ThemeColorEnum = types.ThemeColorEnum;
pub const RgbColor = types.RgbColor;

// SGR Color enum for building multiple instruction ansi codes
pub const ColorCodeEnum = union(enum) {
    FG_THEME: ThemeColorEnum,
    BG_THEME: ThemeColorEnum,
    FG_8BIT: u8,
    BG_8BIT: u8,
    FG_RGB: RgbColor,
    BG_RGB: RgbColor,
    FG_DEFAULT,
    BG_DEFAULT,

    pub fn get_formatted_code(self: ColorCodeEnum, buf: []u8) ![]const u8 {
        return switch (self) {
            .FG_THEME => |v| {
                return try buf_print(buf, codes.FG_THEME_CODE, .{v.as_fg_code()});
            },
            .BG_THEME => |v| {
                return try buf_print(buf, codes.BG_THEME_CODE, .{v.as_bg_code()});
            },
            .FG_8BIT => |v| {
                return try buf_print(buf, codes.FG_8BIT_CODE, .{v});
            },
            .BG_8BIT => |v| {
                return try buf_print(buf, codes.BG_8BIT_CODE, .{v});
            },
            .FG_RGB => |v| {
                return try buf_print(buf, codes.FG_RGB_CODE, .{ v.r, v.g, v.b });
            },
            .BG_RGB => |v| {
                return try buf_print(buf, codes.BG_RGB_CODE, .{ v.r, v.g, v.b });
            },
            .FG_DEFAULT => codes.FG_DEFAULT_COLOR_CODE[0..],
            .BG_DEFAULT => codes.BG_DEFAULT_COLOR_CODE[0..],
        };
    }
};

// Enum union builders
pub fn enum_fg_theme(theme: ThemeColorEnum) ColorCodeEnum {
    return .{ .FG_THEME = theme };
}
pub fn enum_bg_theme(theme: ThemeColorEnum) ColorCodeEnum {
    return .{ .BG_THEME = theme };
}
pub fn enum_fg_8bit(val: u8) ColorCodeEnum {
    return .{ .FG_8BIT = val };
}
pub fn enum_bg_8bit(val: u8) ColorCodeEnum {
    return .{ .BG_8BIT = val };
}
pub fn enum_fg_rgb(r: u8, g: u8, b: u8) ColorCodeEnum {
    return .{ .FG_RGB = .{ .r = r, .g = g, .b = b } };
}
pub fn enum_bg_rgb(r: u8, g: u8, b: u8) ColorCodeEnum {
    return .{ .BG_RGB = .{ .r = r, .g = g, .b = b } };
}
pub fn enum_fg_default() ColorCodeEnum {
    return .FG_DEFAULT;
}
pub fn enum_bg_default() ColorCodeEnum {
    return .BG_DEFAULT;
}

// Single instruction ansi code senders
pub fn set_fg_theme_color(theme: ThemeColorEnum) void {
    const buf: u8[6] = undefined;
    const fmt = buf_print(
        &buf,
        codes.comptmime_wrap_sgr_code(codes.FG_THEME_CODE),
        .{theme.as_fg_code()},
    ) catch return;
    stdout_write(fmt);
}

pub fn set_bg_theme_color(theme: ThemeColorEnum) void {
    const buf: u8[6] = undefined;
    const fmt = buf_print(
        &buf,
        codes.comptmime_wrap_sgr_code(codes.FG_THEME_CODE),
        .{theme.as_bg_code()},
    ) catch return;
    stdout_write(fmt);
}

pub fn set_fg_8bit_color(color: u8) void {
    const buf: u8[12] = undefined;
    const fmt = buf_print(
        &buf,
        codes.comptmime_wrap_sgr_code(codes.FG_8BIT_CODE),
        .{color},
    ) catch return;
    stdout_write(fmt);
}

pub fn set_bg_8bit_color(color: u8) void {
    const buf: u8[12] = undefined;
    const fmt = buf_print(
        &buf,
        codes.comptmime_wrap_sgr_code(codes.BG_8BIT_CODE),
        .{color},
    ) catch return;
    stdout_write(fmt);
}

pub fn set_fg_rgb_color(r: u8, g: u8, b: u8) void {
    var buf: [19]u8 = undefined;
    const fmt = buf_print(
        &buf,
        codes.comptmime_wrap_sgr_code(codes.FG_RGB_CODE),
        .{ r, g, b },
    ) catch return;
    stdout_write(fmt);
}

pub fn set_bg_rgb_color(r: u8, g: u8, b: u8) void {
    var buf: [19]u8 = undefined;
    const fmt = buf_print(
        &buf,
        codes.comptmime_wrap_sgr_code(codes.BG_RGB_CODE),
        .{ r, g, b },
    ) catch return;
    stdout_write(fmt);
}

pub fn set_fg_default_color() void {
    stdout_write(
        codes.comptmime_wrap_sgr_code(codes.FG_DEFAULT_COLOR_CODE),
    );
}

pub fn set_bg_default_color() void {
    stdout_write(
        codes.comptmime_wrap_sgr_code(codes.BG_DEFAULT_COLOR_CODE),
    );
}

const fmt = @import("std").fmt;

pub const color = @import("color.zig");

pub const SgrCodes = union(enum) {
    ColorCodes: color.ColorCodes,

    pub fn get_code(self: SgrCodes) []const u8 {
        return switch (self) {
            .ColorCodes => |col| col.get_code(),
        };
    }
};

pub fn wrap_sgr_code(code: []u8, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        "\x1b[{s}m",
        .{code},
    );
}

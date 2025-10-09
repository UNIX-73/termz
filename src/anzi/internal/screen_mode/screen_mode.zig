const u = @import("../utils.zig");
pub const codes = @import("./codes.zig");

pub const ScreenModeValueEnum = codes.ScreenModeValueEnum;

pub const ScreenModeEnum = union(enum) {
    SET_MODE: ScreenModeValueEnum,
    RESET_MODE: ScreenModeValueEnum,

    pub fn get_required_buf_size() usize {
        return 6;
    }

    pub fn get_code(self: ScreenModeEnum, buf: []u8) ![]const u8 {
        return switch (self) {
            .SET_MODE => |v| try u.buf_fmt(
                buf,
                codes.SET_MODE_CODE,
                .{@intFromEnum(v)},
            ),
            .RESET_MODE => |v| try u.buf_fmt(
                buf,
                codes.RESET_MODE_CODE,
                .{@intFromEnum(v)},
            ),
        };
    }

    pub fn send(self: ScreenModeEnum) void {
        var buf: [6]u8 = undefined;
        const code = self.get_code(&buf) catch return;
        u.io.write(code);
    }
};

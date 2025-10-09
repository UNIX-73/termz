const u = @import("../utils.zig");
pub const codes = @import("./codes.zig");

pub const EraseFunctionEnum = enum {
    ERASE_DISPLAY,
    ERASE_DISPLAY_FROM_CURSOR,
    ERASE_DISPLAY_TO_CURSOR,
    ERASE_DISPLAY_ENTIRE,
    ERASE_DISPLAY_SAVED_LINES,
    ERASE_LINE,
    ERASE_LINE_FROM_CURSOR,
    ERASE_LINE_TO_CURSOR,
    ERASE_LINE_ENTIRE,

    pub fn get_code(comptime self: EraseFunctionEnum) []const u8 {
        return comptime switch (self) {
            .ERASE_DISPLAY => codes.ERASE_DISPLAY_CODE,
            .ERASE_DISPLAY_FROM_CURSOR => codes.ERASE_DISPLAY_FROM_CURSOR_CODE,
            .ERASE_DISPLAY_TO_CURSOR => codes.ERASE_DISPLAY_TO_CURSOR_CODE,
            .ERASE_DISPLAY_ENTIRE => codes.ERASE_DISPLAY_ENTIRE_CODE,
            .ERASE_DISPLAY_SAVED_LINES => codes.ERASE_DISPLAY_SAVED_LINES_CODE,
            .ERASE_LINE => codes.ERASE_LINE_CODE,
            .ERASE_LINE_FROM_CURSOR => codes.ERASE_LINE_FROM_CURSOR_CODE,
            .ERASE_LINE_TO_CURSOR => codes.ERASE_LINE_TO_CURSOR_CODE,
            .ERASE_LINE_ENTIRE => codes.ERASE_LINE_ENTIRE_CODE,
        };
    }

    pub fn send(comptime self: EraseFunctionEnum) void {
        u.io.write(self.get_code());
    }
};

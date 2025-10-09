const u = @import("../utils.zig");
pub const codes = @import("./codes.zig");

pub const PrivateModeEnum = enum(u8) {
    /// Makes the cursor invisible.
    CURSOR_INVISIBLE,

    /// Makes the cursor visible.
    CURSOR_VISIBLE,

    /// Saves the current screen.
    SCREEN_SAVE,

    /// Restores the saved screen.
    SCREEN_RESTORE,

    /// Enables the alternative screen buffer (used by programs like vim, less...).
    ALT_BUFFER_ENABLE,

    /// Disables the alternative screen buffer and restores the main screen.
    ALT_BUFFER_DISABLE,

    pub fn get_code(comptime self: PrivateModeEnum) []const u8 {
        return switch (self) {
            .CURSOR_INVISIBLE => codes.CURSOR_INVISIBLE_CODE,
            .CURSOR_VISIBLE => codes.CURSOR_VISIBLE_CODE,
            .SCREEN_SAVE => codes.SCREEN_SAVE_CODE,
            .SCREEN_RESTORE => codes.SCREEN_RESTORE_CODE,
            .ALT_BUFFER_ENABLE => codes.ALT_BUFFER_ENABLE_CODE,
            .ALT_BUFFER_DISABLE => codes.ALT_BUFFER_DISABLE_CODE,
        };
    }

    pub fn get_required_buf_size(comptime self: PrivateModeEnum) usize {
        return get_code(self).len;
    }

    pub fn send(comptime self: PrivateModeEnum) void {
        u.io.write(self.get_code());
    }
};

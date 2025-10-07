pub const ThemeColors = enum(u8) {
    Black = 0,
    Red = 1,
    Green = 2,
    Yellow = 3,
    Blue = 4,
    Magenta = 5,
    Cyan = 6,
    White = 7,

    BrightBlack = 8,
    BrightRed = 9,
    BrightGreen = 10,
    BrightYellow = 11,
    BrightBlue = 12,
    BrightMagenta = 13,
    BrightCyan = 14,
    BrightWhite = 15,

    pub fn as_fg_code(self: ThemeColors) u8 {
        const c = @intFromEnum(self);

        if (c < 8) return 30 + c;
        return 90 + (c - 8);
    }

    pub fn as_bg_code(self: ThemeColors) u8 {
        const c = @intFromEnum(self);

        if (c < 8) return 40 + c;
        return 100 + (c - 8);
    }
};

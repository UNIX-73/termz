// =========================================================
// Set / Reset Mode (DEC Private Mode)
// =========================================================

/// Sets the terminal display mode to the specified value.
/// Example: `\x1b[={d}h`
pub const SET_MODE_CODE = "\x1b[={d}h";

/// Resets the terminal display mode to the specified value.
/// Example: `\x1b[={d}l`
pub const RESET_MODE_CODE = "\x1b[={d}l";

/// Represents the DEC display modes used with `SET_MODE_CODE` and `RESET_MODE_CODE`.
pub const ScreenModeValueEnum = enum(u8) {
    /// 40 x 25 monochrome (text)
    MODE_0 = 0,

    /// 40 x 25 color (text)
    MODE_1 = 1,

    /// 80 x 25 monochrome (text)
    MODE_2 = 2,

    /// 80 x 25 color (text)
    MODE_3 = 3,

    /// 320 x 200 4-color (graphics)
    MODE_4 = 4,

    /// 320 x 200 monochrome (graphics)
    MODE_5 = 5,

    /// 640 x 200 monochrome (graphics)
    MODE_6 = 6,

    /// Enables line wrapping
    MODE_7 = 7,

    /// 320 x 200 color (graphics)
    MODE_13 = 13,

    /// 640 x 200 color (16-color graphics)
    MODE_14 = 14,

    /// 640 x 350 monochrome (2-color graphics)
    MODE_15 = 15,

    /// 640 x 350 color (16-color graphics)
    MODE_16 = 16,

    /// 640 x 480 monochrome (2-color graphics)
    MODE_17 = 17,

    /// 640 x 480 color (16-color graphics)
    MODE_18 = 18,

    /// 320 x 200 color (256-color graphics)
    MODE_19 = 19,
};

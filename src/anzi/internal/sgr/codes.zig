// Foreground / Background — 8-bit y RGB
pub const FG_8BIT_CODE = "38;5;{d}";
pub const BG_8BIT_CODE = "48;5;{d}";
pub const FG_RGB_CODE = "38;2;{d};{d};{d}";
pub const BG_RGB_CODE = "48;2;{d};{d};{d}";

// Defaults
pub const FG_DEFAULT_COLOR_CODE = "39";
pub const BG_DEFAULT_COLOR_CODE = "49";

// Reset
pub const RESET_CODE = "0";

// Basic text styles
pub const BOLD_CODE = "1";
pub const FAINT_CODE = "2";
pub const ITALIC_CODE = "3";
pub const UNDERLINE_CODE = "4";
pub const BLINK_CODE = "5";
pub const INVERSE_CODE = "7";
pub const HIDDEN_CODE = "8";
pub const STRIKETHROUGH_CODE = "9";

// Style resets
pub const BOLD_OFF_CODE = "22"; // reset bold/faint
pub const ITALIC_OFF_CODE = "23";
pub const UNDERLINE_OFF_CODE = "24";
pub const BLINK_OFF_CODE = "25";
pub const INVERSE_OFF_CODE = "27";
pub const HIDDEN_OFF_CODE = "28";
pub const STRIKETHROUGH_OFF_CODE = "29";

// Theme-based
pub const FG_THEME_CODE = "{d}";
pub const BG_THEME_CODE = "{d}";

pub fn comptmime_wrap_sgr_code(comptime code: []const u8) []const u8 {
    return "\x1b[" ++ code ++ "m";
}

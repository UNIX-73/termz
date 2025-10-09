/// Erase in display (same as ESC[0J])
pub const ERASE_DISPLAY_CODE = "\x1b[J";

/// Erase from cursor until end of screen
pub const ERASE_DISPLAY_FROM_CURSOR_CODE = "\x1b[0J";

/// Erase from cursor to beginning of screen
pub const ERASE_DISPLAY_TO_CURSOR_CODE = "\x1b[1J";

/// Erase entire screen
pub const ERASE_DISPLAY_ENTIRE_CODE = "\x1b[2J";

/// Erase saved lines
pub const ERASE_DISPLAY_SAVED_LINES_CODE = "\x1b[3J";

/// Erase in line (same as ESC[0K])
pub const ERASE_LINE_CODE = "\x1b[K";

/// Erase from cursor to end of line
pub const ERASE_LINE_FROM_CURSOR_CODE = "\x1b[0K";

/// Erase start of line to the cursor
pub const ERASE_LINE_TO_CURSOR_CODE = "\x1b[1K";

/// Erase the entire line
pub const ERASE_LINE_ENTIRE_CODE = "\x1b[2K";

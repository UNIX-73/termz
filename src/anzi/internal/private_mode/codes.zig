/// Makes the cursor invisible.
pub const CURSOR_INVISIBLE_CODE = "\x1b[?25l";

/// Makes the cursor visible.
pub const CURSOR_VISIBLE_CODE = "\x1b[?25h";

/// Restores the screen from the saved state.
pub const SCREEN_RESTORE_CODE = "\x1b[?47l";

/// Saves the current screen content.
pub const SCREEN_SAVE_CODE = "\x1b[?47h";

/// Enables the alternative screen buffer (used by apps like vim).
pub const ALT_BUFFER_ENABLE_CODE = "\x1b[?1049h";

/// Disables the alternative screen buffer and restores the main one.
pub const ALT_BUFFER_DISABLE_CODE = "\x1b[?1049l";

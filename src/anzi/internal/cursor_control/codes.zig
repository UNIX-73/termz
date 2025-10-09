/// Moves the cursor to the home position (0, 0).
pub const CURSOR_HOME_CODE = "\x1b[H";

/// Moves the cursor to the specified line and column.
pub const CURSOR_POSITION_CODE = "\x1b[{d};{d}H";

/// Moves the cursor to the specified line and column (alternative form).
pub const CURSOR_POSITION_F_CODE = "\x1b[{d};{d}f";

/// Moves the cursor up {d} lines.
pub const CURSOR_UP_CODE = "\x1b[{d}A";

/// Moves the cursor down {d} lines.
pub const CURSOR_DOWN_CODE = "\x1b[{d}B";

/// Moves the cursor right {d} columns.
pub const CURSOR_RIGHT_CODE = "\x1b[{d}C";

/// Moves the cursor left {d} columns.
pub const CURSOR_LEFT_CODE = "\x1b[{d}D";

/// Moves the cursor to the beginning of the next line, {d} lines down.
pub const CURSOR_NEXT_LINE_CODE = "\x1b[{d}E";

/// Moves the cursor to the beginning of the previous line, {d} lines up.
pub const CURSOR_PREVIOUS_LINE_CODE = "\x1b[{d}F";

/// Moves the cursor to the specified column {d}.
pub const CURSOR_COLUMN_CODE = "\x1b[{d}G";

/// Requests the cursor position; terminal reports back as ESC[{d};{d}R.
pub const CURSOR_POSITION_REPORT_CODE = "\x1b[6n";

/// Moves the cursor one line up, scrolling if needed.
pub const CURSOR_REVERSE_INDEX_CODE = "\x1bM";

/// Saves the current cursor position (DEC private mode).
pub const CURSOR_SAVE_DEC_CODE = "\x1b7";

/// Restores the cursor to the last saved position (DEC private mode).
pub const CURSOR_RESTORE_DEC_CODE = "\x1b8";

/// Saves the current cursor position (SCO mode).
pub const CURSOR_SAVE_SCO_CODE = "\x1b[s";

/// Restores the cursor to the last saved position (SCO mode).
pub const CURSOR_RESTORE_SCO_CODE = "\x1b[u";

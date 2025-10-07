const std = @import("std");

const c_termios = @cImport({
    @cInclude("termios.h");
});
const c_unistd = @cImport({
    @cInclude("unistd.h");
});

pub fn set_term_mode(mode: c_termios.struct_termios) !void {
    if (c_termios.tcsetattr(c_unistd.STDIN_FILENO, c_termios.TCSAFLUSH, &mode) == -1) {
        return error.tcsetattr_err;
    }
}

/// read_wait_time en decimas de s
pub fn set_raw_mode() !c_termios.struct_termios {
    var old_config: c_termios.struct_termios = undefined;
    var raw: c_termios.struct_termios = undefined;

    if (c_termios.tcgetattr(c_unistd.STDIN_FILENO, &old_config) == -1) {
        std.debug.print("tcgetattr failed", .{});
        return error.tcgetattr_err;
    }

    raw = old_config;

    raw.c_iflag &= ~(@as(c_uint, (c_termios.BRKINT | c_termios.ICRNL | c_termios.INPCK | c_termios.ISTRIP | c_termios.IXON)));

    // Flags de salida
    raw.c_oflag &= ~(@as(c_uint, c_termios.OPOST));

    // Flags de control
    raw.c_cflag |= @as(c_uint, c_termios.CS8);

    // Flags de modo local
    raw.c_lflag &= ~(@as(c_uint, (c_termios.ECHO | c_termios.ICANON | c_termios.IEXTEN | c_termios.ISIG)));

    raw.c_cc[c_termios.VMIN] = 0; // número mínimo de bytes
    raw.c_cc[c_termios.VTIME] = 0; // timeout en décimas de segundo

    if (c_termios.tcsetattr(c_unistd.STDIN_FILENO, c_termios.TCSAFLUSH, &raw) == -1) {
        return error.tcsetattr_err;
    }

    return old_config;
}

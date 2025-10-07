const fs = @import("std").fs.File;
const c_unistd = @cImport({
    @cInclude("unistd.h");
});

const stdout = fs.stdout();
const stderr = fs.stderr();

pub inline fn read(buf: *u8) isize {
    return c_unistd.read(c_unistd.STDIN_FILENO, buf, 1);
}

pub fn write(bytes: []const u8) void {
    _ = stdout.write(bytes) catch {
        _ = stderr.write("Error writing stdout\n") catch {};
    };
}

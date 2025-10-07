const fmt = @import("std").fmt;

pub const color = @import("color.zig");

pub fn wrap_sgr_code(code: []const u8, buf: []u8) ![]u8 {
    return try fmt.bufPrint(
        buf,
        "\x1b[{s}m",
        .{code},
    );
}

pub fn combine_sgr_codes(codes: [][]const u8, buf: []u8) ![]u8 {
    var idx: usize = 0;
    for (codes, 0..) |code, code_idx| {
        var extra: usize = 0;
        if (code_idx + 1 != codes.len) {
            extra = 1;
        }
        if (idx + code.len + extra > buf.len) {
            return error.NoSpaceLeft;
        }

        @memcpy(buf[idx .. idx + code.len], code);

        if (code_idx + 1 != codes.len) {
            buf[idx + code.len] = ';';
            idx += code.len + 1;
        } else {
            idx += code.len;
        }
    }
    return buf[0..idx];
}

pub fn wrap_combine_sgr_codes(codes: [][]const u8, buf: []u8) ![]u8 {
    // Minus 1 because the last code does not use ; for combining
    // and the following for loop adds 1 each iteration
    var len: usize = 3 - 1;

    for (codes) |code|
        len += code.len + 1;

    if (len > buf.len) return error.NoSpaceLeft;

    buf[0] = '\x1b';
    buf[1] = '[';

    const slice = try combine_sgr_codes(codes, buf[2..]);

    buf[slice.len + 2] = 'm';

    return buf[0 .. slice.len + 3];
}

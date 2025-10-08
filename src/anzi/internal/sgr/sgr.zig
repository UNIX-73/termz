const fmt = @import("std").fmt;

pub const color = @import("color.zig");
pub const style = @import("style.zig");
const stdout_write = @import("../../../termz/termz.zig").io.write;
const allocator = @import("std").heap.page_allocator;

pub const SgrCodeEnum = union(enum) {
    ColorCode: color.ColorCodeEnum,
    StyleCode: style.StyleCodeEnum,

    pub fn code_len(self: SgrCodeEnum) usize {
        var len: usize = 0;
        switch (self) {
            .ColorCode => |val| {
                var temp: [19]u8 = undefined;
                const code = val.as_code(&temp) catch return 0;
                len += code.len;
            },
            .StyleCode => |val| {
                len += val.as_code().len;
            },
        }
        return len;
    }
};

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

pub fn wrap_combine_sgr_slices(codes: [][]const u8, buf: []u8) ![]u8 {
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

pub fn wrap_combine_sgr_codes(codes: []const SgrCodeEnum, buf: []u8) ![]u8 {
    // Check buffer overflow
    var overflow_len: usize = 3;

    // Add all the codes
    var idx: usize = 2;
    var temp: [19]u8 = undefined; // Max possible buffer needed
    for (0.., codes) |i, code_enum| {
        var code: []const u8 = undefined;
        switch (code_enum) {
            .ColorCode => |val| code = try val.as_code(&temp),
            .StyleCode => |val| code = val.as_code(),
        }

        // Overflow check
        overflow_len += code.len;
        if (overflow_len > buf.len)
            return error.NoSpaceLeft;

        @memcpy(buf[idx .. idx + code.len], code);

        if (i != codes.len - 1) {
            buf[idx + code.len] = ';';
            idx += code.len + 1;
        } else {
            // Last iter
            idx += code.len;
        }
    }

    buf[0] = '\x1b';
    buf[1] = '[';
    buf[idx] = 'm';

    return buf[0 .. idx + 1];
}

pub fn send_combine_sgr_codes(codes: []const SgrCodeEnum) void {
    var len = 3 + (codes.len - 1); // 3( \x1b + [ + m ) + the commas
    for (codes) |code| {
        len += code.code_len();
    }

    const buf: []u8 = allocator.alloc(u8, len) catch {
        return;
    };

    const slice = wrap_combine_sgr_codes(codes, buf) catch return;
    stdout_write(slice);

    allocator.free(buf);
}

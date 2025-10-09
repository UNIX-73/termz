pub const buf_fmt = @import("std").fmt.bufPrint;
pub const io = @import("../../termz/termz.zig").io;
pub const allocator = @import("std").heap.page_allocator;

pub fn get_number_ascii_len(n: usize) usize {
    var num = n;
    var len: usize = 1;
    while (num >= 10) {
        num /= 10;
        len += 1;
    }
    return len;
}

pub fn strip_fmt_len_u16(str: []const u8) usize {
    var len: usize = 0;
    var i: usize = 0;

    while (i < str.len) {
        if (i + 2 < str.len and str[i] == '{' and str[i + 1] == 'd' and str[i + 2] == '}') {
            len += 5; // 65535 is the max u16 digit and has 5 characters
            i += 3;
            continue;
        }
        len += 1;
        i += 1;
    }

    return len;
}

pub fn getUnionTagIndex(comptime T: type, tag: anytype) comptime_int {
    const info = @typeInfo(T);
    const fields = info.@"union".fields;

    inline for (fields, 0..) |field, i| {
        if (@field(info.@"union".tag_type.?, field.name) == tag) {
            return i;
        }
    }

    @compileError("Unknown tag for union type");
}

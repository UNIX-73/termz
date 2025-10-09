const u = @import("../utils.zig");
pub const codes = @import("./codes.zig");

pub const CursorControlEnum = union(enum) {
    CURSOR_HOME,
    CURSOR_POSITION: struct { line: u16, column: u16 },
    CURSOR_POSITION_F: struct { line: u16, column: u16 },
    CURSOR_UP: u16,
    CURSOR_DOWN: u16,
    CURSOR_RIGHT: u16,
    CURSOR_LEFT: u16,
    CURSOR_NEXT_LINE: u16,
    CURSOR_PREVIOUS_LINE: u16,
    CURSOR_COLUMN: u16,
    CURSOR_POSITION_REPORT,
    CURSOR_REVERSE_INDEX,
    CURSOR_SAVE_DEC,
    CURSOR_RESTORE_DEC,
    CURSOR_SAVE_SCO,
    CURSOR_RESTORE_SCO,

    pub fn get_required_buf_size(comptime self: CursorControlEnum) usize {
        const idx = u.getUnionTagIndex(CursorControlEnum, self);
        return @intCast(MAX_CODE_BUF_LENGHTS[idx]);
    }

    pub fn get_code(self: CursorControlEnum, buf: []u8) ![]const u8 {
        return switch (self) {
            .CURSOR_POSITION => |v| try u.buf_fmt(buf, codes.CURSOR_POSITION_CODE, .{ v.column, v.line }),
            .CURSOR_POSITION_F => |v| try u.buf_fmt(buf, codes.CURSOR_POSITION_F_CODE, .{ v.column, v.line }),
            .CURSOR_UP => |v| try u.buf_fmt(buf, codes.CURSOR_UP_CODE, .{v}),
            .CURSOR_DOWN => |v| try u.buf_fmt(buf, codes.CURSOR_DOWN_CODE, .{v}),
            .CURSOR_RIGHT => |v| try u.buf_fmt(buf, codes.CURSOR_RIGHT_CODE, .{v}),
            .CURSOR_LEFT => |v| try u.buf_fmt(buf, codes.CURSOR_LEFT_CODE, .{v}),
            .CURSOR_NEXT_LINE => |v| try u.buf_fmt(buf, codes.CURSOR_NEXT_LINE_CODE, .{v}),
            .CURSOR_PREVIOUS_LINE => |v| try u.buf_fmt(buf, codes.CURSOR_PREVIOUS_LINE_CODE, .{v}),
            .CURSOR_COLUMN => |v| try u.buf_fmt(buf, codes.CURSOR_COLUMN_CODE, .{v}),
            .CURSOR_HOME => codes.CURSOR_HOME_CODE,
            .CURSOR_POSITION_REPORT => codes.CURSOR_POSITION_REPORT_CODE,
            .CURSOR_REVERSE_INDEX => codes.CURSOR_REVERSE_INDEX_CODE,
            .CURSOR_SAVE_DEC => codes.CURSOR_SAVE_DEC_CODE,
            .CURSOR_RESTORE_DEC => codes.CURSOR_RESTORE_DEC_CODE,
            .CURSOR_SAVE_SCO => codes.CURSOR_SAVE_SCO_CODE,
            .CURSOR_RESTORE_SCO => codes.CURSOR_RESTORE_SCO_CODE,
        };
    }

    pub fn send(self: CursorControlEnum) void {
        var buf: [14]u8 = undefined;
        const code = self.get_code(&buf) catch return;
        u.io.write(code);
    }
};

// Internal
const MAX_CODE_BUF_LENGHTS = init_code_lengths: {
    const enum_info = @typeInfo(CursorControlEnum);
    const fields = enum_info.@"union".fields;

    var arr: [fields.len]u8 = undefined;

    for (fields, 0..) |field_info, i| {
        // Creamos una instancia del union con ese tag
        const value = @unionInit(CursorControlEnum, field_info.name, undefined);

        const code = const_code(value);
        const max_buf_len = u.strip_fmt_len_u16(code);
        arr[i] = max_buf_len;
    }

    break :init_code_lengths arr;
};

fn const_code(cc: CursorControlEnum) []const u8 {
    return switch (cc) {
        .CURSOR_POSITION => codes.CURSOR_POSITION_CODE,
        .CURSOR_POSITION_F => codes.CURSOR_POSITION_F_CODE,
        .CURSOR_UP => codes.CURSOR_UP_CODE,
        .CURSOR_DOWN => codes.CURSOR_DOWN_CODE,
        .CURSOR_RIGHT => codes.CURSOR_RIGHT_CODE,
        .CURSOR_LEFT => codes.CURSOR_LEFT_CODE,
        .CURSOR_NEXT_LINE => codes.CURSOR_NEXT_LINE_CODE,
        .CURSOR_PREVIOUS_LINE => codes.CURSOR_PREVIOUS_LINE_CODE,
        .CURSOR_COLUMN => codes.CURSOR_COLUMN_CODE,
        .CURSOR_HOME => codes.CURSOR_HOME_CODE,
        .CURSOR_POSITION_REPORT => codes.CURSOR_POSITION_REPORT_CODE,
        .CURSOR_REVERSE_INDEX => codes.CURSOR_REVERSE_INDEX_CODE,
        .CURSOR_SAVE_DEC => codes.CURSOR_SAVE_DEC_CODE,
        .CURSOR_RESTORE_DEC => codes.CURSOR_RESTORE_DEC_CODE,
        .CURSOR_SAVE_SCO => codes.CURSOR_SAVE_SCO_CODE,
        .CURSOR_RESTORE_SCO => codes.CURSOR_RESTORE_SCO_CODE,
    };
}

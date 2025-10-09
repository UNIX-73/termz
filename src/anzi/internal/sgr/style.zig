const types = @import("types.zig");
const u = @import("../utils.zig");

const comptime_print = @import("std").fmt.comptimePrint;

const STYLE_CODES: [77][]const u8 = init_style_codes: {
    var arr: [77][]const u8 = undefined;

    for (0..arr.len) |i| {
        if (i <= 9) {
            arr[i] = &.{i + '0'};
            continue;
        }

        arr[i] = &.{ (i / 10) + '0', (i % 10) + '0' };
    }

    break :init_style_codes arr;
};

/// Standard SGR (Select Graphic Rendition) style codes.
/// These control text styles (bold, italic, underline, blink, etc.)
/// and do NOT include color codes (30–49, 90–107, 38/48;2;..., etc.).
pub const StyleCodeEnum = enum(u8) {
    /// Reset all attributes (same as `\x1b[0m`)
    Reset = 0,

    /// Increased intensity (bold)
    Bold = 1,

    /// Decreased intensity (dim or faint)
    Faint = 2,

    /// Italic text
    Italic = 3,

    /// Single underline
    Underline = 4,

    /// Slow blink (< 150 per minute)
    Blink_Slow = 5,

    /// Fast blink (> 150 per minute)
    Blink_Fast = 6,

    /// Swap foreground and background colors
    Inverse = 7,

    /// Conceal text (hidden)
    Hidden = 8,

    /// Crossed-out text (strikethrough)
    Strikethrough = 9,

    /// Primary (default) font
    FontDefault = 10,

    /// Alternate font 1
    Font1 = 11,
    /// Alternate font 2
    Font2 = 12,
    /// Alternate font 3
    Font3 = 13,
    /// Alternate font 4
    Font4 = 14,
    /// Alternate font 5
    Font5 = 15,
    /// Alternate font 6
    Font6 = 16,
    /// Alternate font 7
    Font7 = 17,
    /// Alternate font 8
    Font8 = 18,
    /// Alternate font 9
    Font9 = 19,

    /// Fraktur (rarely supported gothic style)
    Fraktur = 20,

    /// Double underline (or "bold off" in some terminals)
    DoubleUnderline = 21,

    /// Reset bold/faint to normal intensity
    NormalIntensity = 22,

    /// Reset italic/fraktur
    ItalicOff = 23,

    /// Reset underline
    UnderlineOff = 24,

    /// Reset blink
    BlinkOff = 25,

    /// Reserved (26) — no standard meaning
    _Reserved26 = 26,

    /// Reset inverse
    InverseOff = 27,

    /// Reset conceal (hidden)
    HiddenOff = 28,

    /// Reset crossed-out (strikethrough)
    StrikethroughOff = 29,

    /// Framed text
    Framed = 51,

    /// Encircled text
    Encircled = 52,

    /// Overlined text
    Overlined = 53,

    /// Reset framed/encircled
    FramedOff = 54,

    /// Reset overlined
    OverlinedOff = 55,

    /// Ideogram underline (used in East Asian terminals)
    IdeogramUnderline = 60,

    /// Double ideogram underline
    IdeogramDoubleUnderline = 61,

    /// Ideogram overline
    IdeogramOverline = 62,

    /// Double ideogram overline
    IdeogramDoubleOverline = 63,

    /// Ideogram stress marking
    IdeogramStressMark = 64,

    /// Reset all ideogram attributes
    IdeogramAttrOff = 65,

    /// Superscript text (xterm extension)
    Superscript = 73,

    /// Subscript text (xterm extension)
    Subscript = 74,

    /// Reset superscript/subscript
    SuperscriptOff = 75,

    /// Alternative reset superscript/subscript (alias)
    SubscriptOff = 76,

    pub fn as_code(self: StyleCodeEnum) []const u8 {
        return STYLE_CODES[@intFromEnum(self)];
    }

    pub fn send(self: StyleCodeEnum) void {
        var buf: [5]u8 = undefined;
        buf[0] = '\x1b';
        buf[1] = '[';

        const slice = self.as_code();

        if (slice.len < 2) {
            buf[2] = slice[0];
            buf[3] = 'm';
            u.io.write(buf[0..4]);
        } else {
            buf[2] = slice[0];
            buf[3] = slice[1];
            buf[4] = 'm';
            u.io.write(buf[0..5]);
        }
    }
};

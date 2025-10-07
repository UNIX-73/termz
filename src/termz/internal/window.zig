const c_ioctl = @cImport({
    @cInclude("sys/ioctl.h");
});
const c_unistd = @cImport({
    @cInclude("unistd.h");
});

pub fn get_term_size() !c_ioctl.struct_winsize {
    var w: c_ioctl.struct_winsize = undefined;
    if (c_ioctl.ioctl(c_unistd.STDOUT_FILENO, c_ioctl.TIOCGWINSZ, &w) == -1) {
        return error.get_size_err;
    }

    return w;
}

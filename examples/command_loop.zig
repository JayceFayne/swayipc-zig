const swayipc = @import("swayipc");
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    var socket = try swayipc.Socket.connect(allocator);
    defer socket.disconnect();

    var stdin_raw = std.io.getStdIn();
    var stdin_buf = std.io.bufferedReader(stdin_raw.reader());
    var stdin = stdin_buf.reader();

    const stdout = std.io.getStdOut().writer();

    var msg_buf: [4096]u8 = undefined;

    while (true) {
        try stdout.print(">>> ", .{});
        if (try stdin.readUntilDelimiterOrEof(&msg_buf, '\n')) |m| {
            if (std.mem.eql(u8, m, "q")) break;
            if (socket.runCommand(m)) {
                try stdout.print("success\n", .{});
            } else |err| {
                try stdout.print("failure: {}\n", .{err});
            }
        }
    }
}

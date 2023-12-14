const swayipc = @import("swayipc");
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    var socket = try swayipc.Socket.connect(allocator);
    defer socket.disconnect();
    var events = try socket.subscribe("[\"workspace\", \"mode\", \"window\", \"input\"]");
    const stdout = std.io.getStdOut().writer();
    while (events.next()) |event| {
        defer event.deinit();
        try stdout.print("{any}\n", .{event.value});
    } else |err| {
        return err;
    }
}

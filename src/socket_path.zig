const std = @import("std");
const os = std.os;
const Allocator = std.mem.Allocator;
const Child = std.process.Child;

pub fn fromEnv() ?[]const u8 {
    return if (os.getenv("SWAYSOCK")) |path| path else if (os.getenv("I3SOCK")) |path| path else null;
}

fn trySpawn(wm: [:0]const u8, allocator: Allocator) ![]const u8 {
    const args = [_][]const u8{ wm, "--get-socketpath" };
    var process = Child.init(&args, allocator);
    process.stdout_behavior = .Pipe;
    try process.spawn();
    const path = try process.stdout.?.reader().readAllAlloc(allocator, std.math.maxInt(usize));
    errdefer allocator.free(path);
    _ = try process.wait();
    return path;
}

fn spawn(wm: [:0]const u8, allocator: Allocator) ?[]const u8 {
    return trySpawn(wm, allocator) catch null;
}

pub fn fromWM(allocator: Allocator) ?[]const u8 {
    return if (spawn("sway", allocator)) |path| path else if (spawn("i3", allocator)) |path| path else null;
}

test "get socket" {
    const allocator = std.testing.allocator;
    const log = std.log;

    const wm_path = fromWM(allocator) orelse unreachable;
    defer allocator.free(wm_path);
    log.info("{s}", .{wm_path});
    const env_path = fromEnv() orelse unreachable;
    log.info("{s}", .{env_path});
}

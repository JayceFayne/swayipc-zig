const std = @import("std");
const socket_path = @import("socket_path.zig");
const Stream = std.net.Stream;
const Allocator = std.mem.Allocator;
const readInt = std.mem.readInt;
const writeInt = std.mem.writeInt;
const Buffer = std.ArrayList(u8);
const native_endian = @import("builtin").cpu.arch.endian();

pub const Reply = struct {
    type: u32,
    payload: []u8,
};

pub const Socket = struct {
    stream: Stream,
    buf: Buffer,

    const MAGIC = "i3-ipc";
    const HEADER_SIZE = MAGIC.len + @sizeOf(u32) + @sizeOf(u32);
    const Self = @This();

    pub fn from_stream(stream: Stream, allocator: Allocator) !Self {
        var buf = Buffer.init(allocator);
        try buf.resize(HEADER_SIZE);
        return Self{
            .stream = stream,
            .buf = buf,
        };
    }

    pub fn connect(allocator: Allocator) !Self {
        if (socket_path.fromEnv()) |s| {
            const stream = try std.net.connectUnixSocket(s);
            return Self.from_stream(stream, allocator);
        } else if (socket_path.fromWM(allocator)) |s| {
            const stream = try std.net.connectUnixSocket(s);
            allocator.free(s);
            return Self.from_stream(stream, allocator);
        } else return error.UnableToDetermineSocketPath;
    }

    pub fn send(self: *Self, command: u32, payload: ?[]const u8) !void {
        const writer = self.stream.writer();
        const payload_size = if (payload) |p| p.len else 0;
        if (payload_size > std.math.maxInt(u32)) return error.PayloadTooBig;
        var header = self.buf.items[0..HEADER_SIZE];
        @memcpy(header[0..MAGIC.len], MAGIC);
        writeInt(u32, header[MAGIC.len .. MAGIC.len + @sizeOf(u32)], @as(u32, @truncate(payload_size)), native_endian);
        writeInt(u32, header[MAGIC.len + @sizeOf(u32) .. header.len], command, native_endian);
        try writer.writeAll(header);
        if (payload) |p| try writer.writeAll(p);
    }

    pub fn recv(self: *Self) !Reply {
        const reader = self.stream.reader();
        var header = self.buf.items[0..HEADER_SIZE];
        try reader.readNoEof(self.buf.items[0..HEADER_SIZE]);
        if (!std.mem.eql(u8, header[0..MAGIC.len], MAGIC)) return error.InvalidMagic;
        const payload_size = readInt(u32, header[MAGIC.len .. MAGIC.len + @sizeOf(u32)], native_endian);
        const reply_type = readInt(u32, header[MAGIC.len + @sizeOf(u32) .. header.len], native_endian);
        try self.buf.resize(payload_size);
        const payload = self.buf.items[0..payload_size];
        try reader.readNoEof(payload);
        return Reply{
            .type = reply_type,
            .payload = payload,
        };
    }

    pub fn roundtrip(self: *Self, command: u32, payload: ?[]const u8) ![]u8 {
        try self.send(command, payload);
        const data = try self.recv();
        return if (data.type == command) data.payload else error.ReplyTypeMissMatch;
    }

    pub fn disconnect(self: Self) void {
        self.buf.deinit();
        self.stream.close();
    }
};

test "roundtrip" {
    var socket = try Socket.connect(std.testing.allocator);
    defer socket.disconnect();
    const data = try socket.roundtrip(4, null);
    std.log.info("{s}", .{data});
}

const std = @import("std");
const types = @import("types.zig");
const raw = @import("raw_socket.zig");
const EventStream = @import("event_stream.zig").EventStream;
const json = @import("json.zig");
const Stream = std.net.Stream;
const Allocator = std.mem.Allocator;
const log = std.log;

pub const Socket = struct {
    allocator: Allocator,
    socket: raw.Socket,

    const Self = @This();

    pub fn from_stream(stream: Stream, allocator: Allocator) !Self {
        return Self{
            .allocator = allocator,
            .socket = try raw.Socket.from_stream(stream, allocator),
        };
    }

    pub fn connect(allocator: Allocator) !Self {
        return Self{
            .allocator = allocator,
            .socket = try raw.Socket.connect(allocator),
        };
    }

    fn roundtrip(self: *Self, comptime T: type, command_type: types.CommandType, payload: ?[]const u8) !json.Parsed(T) {
        const data = try self.socket.roundtrip(@intFromEnum(command_type), payload);
        return json.parse(T, self.allocator, data);
    }

    pub fn runCommand(self: *Self, command: []const u8) !void {
        const command_outcome = try self.roundtrip([]types.CommandOutcome, .run_command, command);
        defer command_outcome.deinit();
        for (command_outcome.value) |c| {
            if (!c.success) {
                return if (c.parse_error.?) error.ParsingCommandFailed else error.ExecutingCommandFailed;
            }
        }
    }

    pub fn getWorkspaces(self: *Self) !json.Parsed([]types.Workspace) {
        return self.roundtrip([]types.Workspace, .get_workspaces, null);
    }

    pub fn subscribe(self: *Self, events: []const u8) !EventStream {
        const status = try self.roundtrip(types.Success, .subscribe, events);
        defer status.deinit();
        return if (status.value.success) EventStream{ .socket = self.socket, .allocator = self.allocator } else error.EventSubscriptionFailed;
    }

    pub fn getOutputs(self: *Self) !json.Parsed([]types.Output) {
        return self.roundtrip([]types.Output, .get_outputs, null);
    }

    pub fn getTree(self: *Self) !json.Parsed(types.Node) {
        return self.roundtrip(types.Node, .get_tree, null);
    }

    pub fn getMarks(self: *Self) !json.Parsed([]const []const u8) {
        return self.roundtrip([]const []const u8, .get_marks, null);
    }

    pub fn getBarIds(self: *Self) !json.Parsed([]const []const u8) {
        return self.roundtrip([]const []const u8, .get_bar_config, null);
    }

    pub fn getBarConfig(self: *Self) !json.Parsed(types.BarConfig) {
        return self.roundtrip(types.BarConfig, .get_bar_config, null);
    }

    pub fn getVersion(self: *Self) !json.Parsed(types.Version) {
        return self.roundtrip(types.Version, .get_version, null);
    }

    pub fn getBindingModes(self: *Self) !json.Parsed([]const []const u8) {
        return self.roundtrip([]const []const u8, .get_binding_modes, null);
    }

    pub fn getConfig(self: *Self) !json.Parsed(types.Config) {
        return self.roundtrip(types.Config, .get_config, null);
    }

    pub fn sendTick(self: *Self) !bool {
        return self.roundtrip(types.Success, .send_tick, null).success;
    }

    pub fn sync(self: *Self) !bool {
        return self.roundtrip(types.Success, .sync, null).success;
    }

    pub fn getBindingState(self: *Self) !json.Parsed([]const u8) {
        return self.roundtrip([]const u8, .get_binding_state, null);
    }

    pub fn getInputs(self: *Self) !json.Parsed([]types.Input) {
        return self.roundtrip([]types.Input, .get_inputs, null);
    }

    pub fn getSeats(self: *Self) !json.Parsed([]types.Seat) {
        return self.roundtrip([]types.Seat, .get_seats, null);
    }

    pub fn disconnect(self: Self) void {
        self.socket.disconnect();
    }
};

const testing = std.testing;

test "run command empty string" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    try swayipc.runCommand("");
}

test "run command 'exec /bin/true'" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    try swayipc.runCommand("exec /bin/true");
}

test "run command 'exec /bin/false'" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    try swayipc.runCommand("exec /bin/false");
}

test "run command 'somerandomcommand'" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    try testing.expectError(error.ParsingCommandFailed, swayipc.runCommand("somerandomcommand"));
}

test "get workspaces" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getWorkspaces();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

test "subscribe" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    _ = try swayipc.subscribe("[\"workspace\"]");
}

test "get outputs" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getOutputs();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

test "get tree" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getTree();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

test "get version" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getVersion();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

test "get config" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getConfig();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

test "get inputs" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getInputs();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

test "get seats" {
    var swayipc = try Socket.connect(testing.allocator);
    defer swayipc.disconnect();
    const reply = try swayipc.getSeats();
    defer reply.deinit();
    log.info("{any}", .{reply.value});
}

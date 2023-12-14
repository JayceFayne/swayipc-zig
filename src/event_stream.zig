const std = @import("std");
const types = @import("types.zig");
const raw = @import("raw_socket.zig");
const json = @import("json.zig");
const log = std.log;
const mem = std.mem;
const meta = std.meta;
const Allocator = std.mem.Allocator;

pub const EventStream = struct {
    allocator: Allocator,
    socket: raw.Socket,

    const Self = @This();

    fn new_event(
        self: *Self,
        comptime event_type: types.EventType,
        payload: []u8,
    ) !json.Parsed(types.Event) {
        const field_name = @tagName(event_type);
        const field_type = meta.TagPayloadByName(types.Event, field_name);
        const parsed_event = try json.parse(field_type, self.allocator, payload);
        const event = @unionInit(types.Event, field_name, parsed_event.value);
        return json.Parsed(types.Event){
            .arena = parsed_event.arena,
            .value = event,
        };
    }

    pub fn next(self: *Self) !json.Parsed(types.Event) {
        const event = try self.socket.recv();
        return switch ((event.type << 1) >> 1) {
            0 => self.new_event(.workspace, event.payload),
            1 => self.new_event(.output, event.payload),
            2 => self.new_event(.mode, event.payload),
            3 => self.new_event(.window, event.payload),
            4 => self.new_event(.barconfig_upate, event.payload),
            5 => self.new_event(.binding, event.payload),
            6 => self.new_event(.shutdown, event.payload),
            7 => self.new_event(.tick, event.payload),
            20 => self.new_event(.bar_state_update, event.payload),
            21 => self.new_event(.input, event.payload),
            else => error.ReceivedUnimplementedEvent,
        };
    }
};

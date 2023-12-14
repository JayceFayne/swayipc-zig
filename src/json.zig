const std = @import("std");
const json = std.json;
const Allocator = std.mem.Allocator;

pub const Parsed = json.Parsed;

pub const parse_options = json.ParseOptions{
    .ignore_unknown_fields = true,
    .allocate = .alloc_always,
};

pub fn parse(
    comptime T: type,
    allocator: Allocator,
    s: []const u8,
) json.ParseError(json.Scanner)!Parsed(T) {
    return json.parseFromSlice(T, allocator, s, parse_options);
}

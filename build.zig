const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const swayipc = b.addModule("swayipc", .{ .source_file = .{ .path = "src/lib.zig" } });

    inline for ([_][]const u8{ "event_printer", "command_loop" }) |example| {
        const exe = b.addExecutable(.{
            .name = example,
            .root_source_file = .{ .path = "examples/" ++ example ++ ".zig" },
            .target = target,
            .optimize = optimize,
        });

        exe.addModule("swayipc", swayipc);

        b.installArtifact(exe);
    }

    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/lib.zig" },
        .target = target,
    });

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_tests.step);
}

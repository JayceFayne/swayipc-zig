# swayipc-zig

A Zig 0.13 library for controlling swaywm through its [IPC interface](https://github.com/swaywm/sway/blob/master/sway/sway-ipc.7.scd).

## Usage

Examples of how to use the library can be found [here](examples).
Add [swayipc](https://github.com/JayceFayne/swayipc-zig) as dependency by modifying your `build.zig.zon` and `build.zig` files respectively:

```zig
.{
    .name = "app",
    .version = "0.2.0",
    .dependencies = .{
        .swayipc = .{
            .url = "https://github.com/JayceFayne/swayipc-zig/archive/<COMMIT_HASH>.tar.gz",
        },
    },
}
```

```zig
exe.addModule("swayipc", b.dependency("swayipc", .{}).module("swayipc"));
```

## i3 compatibility

[i3](https://github.com/i3/i3) compatibility is kept if possible even though this library primarily targets sway.

## Versioning

This library targets the latest stable release of [sway](https://github.com/swaywm/sway) and the latest release of [zig](https://github.com/ziglang/zig)

## Contributing

If you find any errors in swayipc-zig or just want to add a new feature feel free to [submit a PR](https://github.com/jaycefayne/swayipc-zig/pulls).

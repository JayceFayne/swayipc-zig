pub const CommandType = enum(u8) {
    run_command = 0,
    get_workspaces = 1,
    subscribe = 2,
    get_outputs = 3,
    get_tree = 4,
    get_marks = 5,
    get_bar_config = 6,
    get_version = 7,
    get_binding_modes = 8,
    get_config = 9,
    send_tick = 10,
    sync = 11,
    get_binding_state = 12,
    get_inputs = 100,
    get_seats = 101,
    _,
};

pub const Success = struct {
    /// A boolean value indicating whether the operation was successful or not.
    success: bool,
};

pub const Rect = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,
};

pub const Config = struct {
    /// A single string property containing the contents of the config.
    config: []const u8,
};

pub const Gaps = struct {
    top: i32,
    bottom: i32,
    right: i32,
    left: i32,
};

pub const Position = enum {
    bottom,
    top,
};

pub const Version = struct {
    /// The major version of the sway process.
    major: i32,
    /// The minor version of the sway process.
    minor: i32,
    /// The patch version of the sway process.
    patch: i32,
    /// A human readable version string that will likely contain more useful
    /// information such as the git commit short hash and git branch.
    human_readable: []const u8,
    /// The path to the loaded config file.
    loaded_config_file_name: []const u8,
};

pub const CommandOutcome = struct {
    success: bool,
    parse_error: ?bool = null,
    @"error": ?[]const u8 = null,
};

pub const NodeType = enum {
    root,
    output,
    workspace,
    con,
    floating_con,
    /// i3-specific
    dockarea,
};

pub const Orientation = enum {
    vertical,
    horizontal,
    none,
};

pub const Layout = enum {
    splith,
    splitv,
    stacked,
    tabbed,
    /// i3-specific
    dockarena,
    /// only on outputs
    output,
    none,
};

pub const WindowType = enum {
    normal,
    dialog,
    utility,
    splash,
    menu,
    dropdown_menu,
    popup_menu,
    tooltip,
    notification,
    toolbar,
};

pub const UserIdleInhibitType = enum {
    focus,
    fullscreen,
    open,
    visible,
};

pub const AdaptiveSyncStatus = enum {
    enabled,
    disabled,
};

pub const ApplicationIdleInhibitType = enum {
    enabled,
    none,
};

pub const ContentType = enum {
    photo,
    video,
    game,
    none,
};

pub const Border = enum {
    normal,
    pixel,
    csd,
    none,
};

pub const Workspace = struct {
    id: i64,
    /// The workspace number or -1 for workspaces that do not start with a number.
    num: i32,
    /// The name of the workspace.
    name: []const u8,
    layout: Layout,
    /// Whether the workspace is currently visible on any output.
    visible: bool,
    /// Whether the workspace is currently focused by the default seat (seat0).
    focused: bool,
    /// Whether a view on the workspace has the urgent flag set.
    urgent: bool,
    representation: ?[]const u8,
    orientation: Orientation,
    /// The bounds of the workspace. It consists of x, y, width, and height.
    rect: Rect,
    /// The name of the output that the workspace is on.
    output: []const u8,
    focus: []i64,
};

pub const Mode = struct {
    width: i32,
    height: i32,
    refresh: i32,
};

pub const Output = struct {
    // Sway doesn't give disabled outputs ids
    id: ?i64,
    /// The name of the output. On DRM, this is the connector.
    name: []const u8,
    /// The make of the output.
    make: []const u8,
    /// The model of the output.
    model: []const u8,
    /// The output's serial number as a hexa‐ decimal string.
    serial: []const u8,
    /// Whether this output is active/enabled.
    active: bool,
    /// Whether this output is on/off (via DPMS).
    dpms: bool,
    /// For i3 compatibility, this will be false. It does not make sense in
    /// Wayland.
    primary: bool,
    /// The scale currently in use on the output or -1 for disabled outputs.
    scale: ?f64,
    /// The subpixel hinting current in use on the output. This can be rgb, bgr,
    /// vrgb, vbgr, or none.
    subpixel_hinting: ?[]const u8,
    /// The transform currently in use for the output. This can be normal, 90,
    /// 180, 270, flipped-90, flipped-180, or flipped-270.
    transform: ?[]const u8,
    /// The workspace currently visible on the output or null for disabled
    /// outputs.
    current_workspace: ?[]const u8,
    /// An array of supported mode objects. Each object contains width, height,
    /// and refresh.
    modes: ?[]Mode = null,
    /// An object representing the current mode containing width, height, and
    /// refresh.
    current_mode: ?Mode,
    /// The bounds for the output consisting of x, y, width, and height.
    rect: Rect,
    focus: ?[]i64 = null,
    focused: bool = false,
};

pub const ColorableBarPart = struct {
    /// The color to use for the bar background on unfocused outputs.
    background: []const u8,
    /// The color to use for the status line text on unfocused outputs.
    statusline: []const u8,
    /// The color to use for the separator text on unfocused outputs.
    separator: []const u8,
    /// The color to use for the background of the bar on the focused output.
    focused_background: []const u8,
    /// The color to use for the status line text on the focused output.
    focused_statusline: []const u8,
    /// The color to use for the separator text on the focused output.
    focused_separator: []const u8,
    /// The color to use for the text of the focused workspace button.
    focused_workspace_text: []const u8,
    /// The color to use for the background of the focused workspace button.
    focused_workspace_bg: []const u8,
    /// The color to use for the border of the focused workspace button.
    focused_workspace_border: []const u8,
    /// The color to use for the text of the workspace buttons for the visible
    /// workspaces on unfocused outputs.
    active_workspace_text: []const u8,
    /// The color to use for the background of the workspace buttons for the
    /// visible workspaces on unfocused outputs.
    active_workspace_bg: []const u8,
    /// The color to use for the border of the workspace buttons for the visible
    /// workspaces on unfocused outputs.
    active_workspace_border: []const u8,
    /// The color to use for the text of the workspace buttons for workspaces
    /// that are not visible.
    inactive_workspace_text: []const u8,
    /// The color to use for the background of the workspace buttons for
    /// workspaces that are not visible.
    inactive_workspace_bg: []const u8,
    /// The color to use for the border of the workspace buttons for workspaces
    /// that are not visible.
    inactive_workspace_border: []const u8,
    /// The color to use for the text of the workspace buttons for workspaces
    /// that contain an urgent view.
    urgent_workspace_text: []const u8,
    /// The color to use for the background of the workspace buttons for
    /// workspaces that contain an urgent view.
    urgent_workspace_bg: []const u8,
    /// The color to use for the border of the workspace buttons for workspaces
    /// that contain an urgent view.
    urgent_workspace_border: []const u8,
    /// The color to use for the text of the binding mode indicator.
    binding_mode_text: []const u8,
    /// The color to use for the background of the binding mode indicator.
    binding_mode_bg: []const u8,
    /// The color to use for the border of the binding mode indicator.
    binding_mode_border: []const u8,
};

pub const BarMode = enum {
    dock,
    hide,
    invisible,
};

pub const ShellType = enum {
    xdg_shell,
    xwayland,
    unknown,
};

pub const WindowProperties = struct {
    title: ?[]const u8 = null,
    instance: ?[]const u8 = null,
    class: ?[]const u8 = null,
    window_role: ?[]const u8 = null,
    window_type: ?[]const u8 = null,
    transient_for: ?i32 = null,
};

pub const IdleInhibitors = struct {
    application: ApplicationIdleInhibitType,
    user: UserIdleInhibitType,
};

pub const Node = struct {
    /// The internal unique ID for this node.
    id: i64,
    /// The name of the node such as the output name or window title. For the
    /// scratchpad, this will be __i3_scratch for compatibility with i3.
    name: ?[]const u8 = null,
    /// The node type. It can be root, output, workspace, con, or floating_con.
    type: NodeType,
    /// The border style for the node. It can be normal, none, pixel, or csd.
    border: Border,
    /// Number of pixels used for the border width.
    current_border_width: i32,
    /// The node's layout.  It can either be splith, splitv, stacked, tabbed, or
    /// output.
    layout: Layout,
    /// The percentage of the node's parent that it takes up or null for the
    /// root and other special nodes such as the scratchpad.
    percent: ?f64 = null,
    /// The absolute geometry of the node.  The window decorations are excluded
    /// from this, but borders are included.
    rect: Rect,
    /// The geometry of the contents inside the node. The window decorations are
    /// excluded from this calculation, but borders are included.
    window_rect: Rect,
    /// The geometry of the decorations for the node relative to the parent
    /// node.
    deco_rect: Rect,
    /// The natural geometry of the contents if it were to size itself.
    geometry: Rect,
    /// Whether the node or any of its descendants has the urgent hint set.
    /// Note: This may not exist when compiled without xwayland support.
    urgent: bool,
    /// Whether the node is currently focused by the default seat (seat0).
    focused: bool,
    /// Array of child node IDs in the current focus order.
    focus: []i64,
    nodes: []Node,
    /// The floating children nodes for the node.
    floating_nodes: []Node,
    /// Whether the node is sticky (shows on all workspaces).
    sticky: bool,
    /// (Only workspaces) A string representation of the layout of the workspace
    /// that can be used as an aid in submitting reproduction steps for bug
    /// reports.
    representation: ?[]const u8 = null,
    /// (Only containers and views) The fullscreen mode of the node. 0 means
    /// none, 1 means full workspace, and 2 means global fullscreen.
    fullscreen_mode: ?u8 = null,
    /// (Only views) For an xdg-shell view, the name of the application, if set.
    /// Otherwise, null.
    app_id: ?[]const u8 = null,
};

pub const EnabledOrDisabled = enum {
    enabled,
    disabled,
};

pub const SendEvents = enum {
    enabled,
    eisabled,
    disabled_on_external_mouse,
};

pub const ButtonMapping = enum {
    LMR,
    LRM,
};

pub const ScrollMethod = enum {
    two_finger,
    edge,
    on_button_down,
    none,
};

pub const ClickMethod = enum {
    button_areas,
    clickfinger,
    none,
};

pub const Libinput = struct {
    /// Whether events are being sent by the device. It can be enabled,
    /// disabled, or disabled_on_external_mouse.
    send_events: ?SendEvents = null,
    /// Whether tap to click is enabled. It can be enabled or disabled.
    tap: ?EnabledOrDisabled = null,
    /// The finger to button mapping in use. It can be lmr or lrm.
    tap_button_mapping: ?ButtonMapping = null,
    /// Whether tap-and-drag is enabled. It can be enabled or disabled.
    tap_drag: ?EnabledOrDisabled = null,
    /// Whether drag-lock is enabled. It can be enabled or disabled.
    tap_drag_lock: ?EnabledOrDisabled = null,
    /// The pointer-acceleration in use.
    accel_speed: ?f64 = null,
    /// Whether natural scrolling is enabled. It can be enabled or disabled.
    natural_scroll: ?EnabledOrDisabled = null,
    /// Whether left-handed mode is enabled. It can be enabled or disabled.
    left_handed: ?EnabledOrDisabled = null,
    /// The click method in use. It can be none, button_areas, or clickfinger.
    click_method: ?ClickMethod = null,
    /// Whether middle emulation is enabled. It can be enabled or disabled.
    middle_emulation: ?EnabledOrDisabled = null,
    /// The scroll method in use. It can be none, two_finger, edge, or
    /// on_button_down.
    scroll_method: ?ScrollMethod = null,
    /// The scroll button to use when scroll_method is on_button_down.  This
    /// will be given as an input event code.
    scroll_button: ?i32 = null,
    /// Whether disable-while-typing is enabled. It can be enabled or disabled.
    dwt: ?EnabledOrDisabled = null,
    /// An array of 6 floats representing the calibration matrix for absolute
    /// devices such as touchscreens.
    calibration_matrix: ?[6]f32 = null,
};

pub const Input = struct {
    /// The identifier for the input device.
    identifier: []const u8,
    /// The human readable name for the device.
    name: []const u8,
    /// The vendor code for the input device.
    vendor: i32,
    /// The product code for the input device.
    product: i32,
    /// The device type. Currently this can be keyboard, pointer, touch,
    /// tablet_tool, tablet_pad, or switch.
    type: []const u8,
    /// (Only pointer)
    scroll_factor: ?f32 = null,
    /// (Only keyboards)
    repeat_delay: ?i32 = null,
    /// (Only keyboards)
    repeat_rate: ?i32 = null,
    /// (Only keyboards) The name of the active keyboard layout in use.
    xkb_active_layout_name: ?[]const u8 = null,
    /// (Only keyboards) A list a layout names configured for the keyboard.
    xkb_layout_names: ?[]const []const u8 = null,
    /// (Only keyboards) The index of the active keyboard layout in use.
    xkb_active_layout_index: ?i32 = null,
    /// (Only libinput devices) An object describing the current device
    /// settings. See below for more information.
    libinput: ?Libinput = null,
};

pub const Seat = struct {
    /// The unique name for the seat.
    name: []const u8,
    /// The number of capabilities that the seat has.
    capabilities: i32,
    /// The id of the node currently focused by the seat or 0 when the seat is
    /// not currently focused by a node (i.e. a surface layer or xwayland
    /// unmanaged has focus).
    focus: i64,
    /// An array of input devices that are attached to the seat. Currently, this
    /// is an array of objects that are identical to those returned by
    /// GET_INPUTS.
    devices: ?[]Input = null,
};

pub const EventType = enum(u32) {
    /// Sent whenever an event involving a workspace occurs such as
    /// initialization of a new workspace or a different workspace gains focus.
    workspace = 0,
    /// Sent whenever an output is added, removed, or its configuration is changed.
    output = 1,
    /// Sent whenever the binding mode changes.
    mode = 2,
    /// Sent whenever an event involving a view occurs such as being reparented,
    /// focused, or closed.
    window = 3,
    /// Sent whenever a bar config changes.
    barconfig_upate = 4,
    /// Sent when a configured binding is executed.
    binding = 5,
    /// Sent when the ipc shuts down because sway is exiting.
    shutdown = 6,
    /// Sent when an ipc client sends a SEND_TICK message.
    tick = 7,
    /// Sent when the visibility of a bar should change due to a modifier.
    bar_state_update = 20,
    /// Sent when something related to input devices changes.
    input = 21,
};

pub const WorkspaceChange = enum {
    /// The workspace was created.
    init,
    /// The workspace is empty and is being destroyed since it is not visible.
    empty,
    /// The workspace was focused. See the old property for the previous focus.
    focus,
    /// The workspace was moved to a different output.
    move,
    /// The workspace was renamed.
    rename,
    /// A view on the workspace has had their urgency hint set or all urgency
    /// hints for views on the workspace have been cleared.
    urgent,
    /// The configuration file has been reloaded.
    reload,
};

pub const WorkspaceEvent = struct {
    /// The type of change that occurred.
    change: WorkspaceChange,
    /// An object representing the workspace effected or null for WorkspaceChange::reload
    current: ?Node,
    /// For a focus change, this will be an object representing the workspace
    /// being switched from. Otherwise, it is null.
    old: ?Node,
};

pub const OutputChange = enum {
    /// We don't know what exactly changed.
    Unspecified,
};

pub const OutputEvent = struct {
    /// The type of change that occurred.
    change: OutputChange,
};

pub const ModeEvent = struct {
    /// The binding mode that became active.
    change: []const u8,
    /// Whether the mode should be parsed as pango markup.
    pango_markup: bool,
};

pub const WindowChange = enum {
    /// The view was created.
    new,
    /// The view was closed.
    close,
    /// The view was focused.
    focus,
    /// The view's title has changed.
    title,
    /// The view's fullscreen mode has changed.
    fullscreen_mode,
    /// The view has been reparented in the tree.
    move,
    /// The view has become floating or is no longer floating.
    floating,
    /// The view's urgency hint has changed status.
    urgent,
    /// A mark has been added or.
    mark,
};

pub const WindowEvent = struct {
    /// The type of change that occurred.
    change: WindowChange,
    /// An object representing the view effected.
    container: Node,
};

pub const BarConfig = struct {
    /// The bar ID.
    id: []const u8,
    /// The mode for the bar. It can be dock, hide, or invisible.
    mode: BarMode,
    /// The bar's position. It can currently either be bottom or top.
    position: Position,
    /// The command which should be run to generate the status line.
    status_command: []const u8,
    /// The font to use for the text on the bar.
    font: []const u8,
    /// Whether to display the workspace buttons on the bar.
    workspace_buttons: bool,
    /// Whether to display the current binding mode on the bar.
    binding_mode_indicator: bool,
    /// For i3 compatibility, this will be the boolean value false.
    verbose: bool,
    /// An object containing the #RRGGBBAA colors to use for the bar.
    colors: ColorableBarPart,
    /// An object representing the gaps for the bar consisting of top, right,
    /// bottom, and left.
    gaps: Gaps,
    /// The absolute height to use for the bar or 0 to automatically size based
    /// on the font.
    bar_height: i32,
    /// The vertical padding to use for the status line.
    status_padding: i32,
    /// The horizontal padding to use for the status line when at the end of an
    /// output.
    status_edge_padding: i32,
};

pub const BindingChange = enum {
    run,
};

pub const InputType = enum {
    keyboard,
    mouse,
};

pub const BindingEventOps = struct {
    /// The command associated with the binding.
    command: []const u8,
    /// An array of strings that correspond to each modifier key for the
    /// binding.
    event_state_mask: ?[]const []const u8 = null,
    /// For keyboard bindcodes, this is the key code for the binding.
    /// For mouse bindings, this is the X11 button number, if there is an equivalent.
    /// In all other cases, this will be 0.
    input_code: u8,
    /// For keyboard bindsyms, this is the bindsym for the binding.
    /// Otherwise, this will be null.
    symbol: ?[]const u8,
    /// The input type that triggered the binding.
    /// This is either keyboard or mouse.
    input_type: InputType,
};

pub const BindingEvent = struct {
    /// The change that occurred for the binding.
    /// Currently this will only be run.
    change: BindingChange,
    /// Details about the binding event.
    binding: BindingEventOps,
};

pub const ShutdownChange = enum {
    exit,
};

pub const ShutdownEvent = struct {
    /// The reason for the shutdown.
    change: ShutdownChange,
};

pub const TickEvent = struct {
    /// Whether this event was triggered by subscribing to the tick events.
    first: bool,
    /// The payload given with a SEND_TICK message, if any.
    /// Otherwise, an empty string.
    payload: []const u8,
};

pub const BarStateUpdateEvent = struct {
    /// The bar ID effected.
    id: []const u8,
    /// Whether the bar should be made visible due to a modifier being pressed.
    visible_by_modifier: bool,
};

pub const InputChange = enum {
    /// The input device became available.
    added,
    /// The input device is no longer available.
    removed,
    /// (Keyboards only) The keymap for the keyboard has changed.
    xkb_keymap,
    /// (Keyboards only) The effective layout in the keymap has changed.
    xkb_layout,
    /// (libinput device only) A libinput config option for the device changed.
    libinput_config,
};

pub const InputEvent = struct {
    /// What has changed.
    change: InputChange,
    /// An object representing the input that is identical the ones GET_INPUTS
    /// gives.
    input: Input,
};

pub const Event = union(EventType) {
    /// Sent whenever an event involving a workspace occurs such as
    /// initialization of a new workspace or a different workspace gains focus.
    workspace: WorkspaceEvent,
    /// Sent whenever an output is added, removed, or its configuration is changed.
    output: OutputEvent,
    /// Sent whenever the binding mode changes.
    mode: ModeEvent,
    /// Sent whenever an event involving a view occurs such as being reparented,
    /// focused, or closed.
    window: WindowEvent,
    /// Sent whenever a bar config changes.
    barconfig_upate: BarConfig,
    /// Sent when a configured binding is executed.
    binding: BindingEvent,
    /// Sent when the ipc shuts down because sway is exiting.
    shutdown: ShutdownEvent,
    /// Sent when an ipc client sends a SEND_TICK message.
    tick: TickEvent,
    /// Sent when the visibility of a bar should change due to a modifier.
    bar_state_update: BarStateUpdateEvent,
    /// Sent when something related to input devices changes.
    input: InputEvent,
};

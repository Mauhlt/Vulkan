//! Publishes the Vulkan bindings as module "Vulkan". The bindings (vk.zig)
//! are generated at build time by the TranslateVulkan dependency from the
//! Khronos registry it pins; this package only names them.
//!
//!   zig build test     every declaration compiles, plus a few API checks
//!   zig build pin      re-pin TranslateVulkan to the latest commit on main
const std = @import("std");

const translate_vulkan_url = "git+https://github.com/Mauhlt/TranslateVulkan#main";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // No arguments: the generator runs on the host, so one TranslateVulkan
    // instance (one vk.zig) serves every target and optimize mode.
    const vk_zig = b.dependency("TranslateVulkan", .{}).namedLazyPath("vk.zig");
    const mod = b.addModule("Vulkan", .{
        .root_source_file = vk_zig,
        .target = target,
        .optimize = optimize,
    });

    // zig build test: every declaration in the bindings compiles.
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "Vulkan", .module = mod }},
    }) });
    b.step("test", "Compile every declaration").dependOn(&b.addRunArtifact(tests).step);

    // zig build pin
    const pin = b.addSystemCommand(&.{ b.graph.zig_exe, "fetch", "--save=TranslateVulkan", translate_vulkan_url });
    pin.setCwd(b.path("."));
    b.step("pin", "Re-pin TranslateVulkan (the generator) to the latest commit on main").dependOn(&pin.step);
}

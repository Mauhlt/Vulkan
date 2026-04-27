const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mod = b.addModule("Vulkan", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });
    const mod_tests = b.addTest(.{
        .root_module = mod,
    });
    // imports
    const libraries = [_][]const u8{
        "Windows",
        // "PackedEnumSet",
        "ExternEnumSet",
    };
    for (libraries) |library| {
        const dep = b.dependency(library, .{});
        dep.addImport(library, dep.module(library));
    }
    // create tests
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}

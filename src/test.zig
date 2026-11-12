const std = @import("std");
const vk = @import("Vulkan");

test "every declaration compiles" {
    @setEvalBranchQuota(100_000);
    std.testing.refAllDecls(vk);
}

test "flag sets and errors" {
    const usage: vk.ImageUsageFlags = .initMany(&.{ .color_attachment_bit, .transfer_dst_bit });
    try std.testing.expect(usage.contains(.transfer_dst_bit));
    try std.testing.expect(!usage.contains(.sampled_bit));
    try std.testing.expectError(error.OutOfDateKHR, vk.Result.error_out_of_date_khr.check());
    try std.testing.expectEqual(vk.Result.suboptimal_khr, try vk.Result.suboptimal_khr.check());
}

test "loader candidates: system loader first, MoltenVK on Apple targets" {
    const win = vk.libraryCandidates(.windows);
    try std.testing.expectEqualStrings("vulkan-1.dll", win[0].path);
    try std.testing.expectEqual(1, win.len);
    try std.testing.expectEqualStrings("libvulkan.so.1", vk.libraryCandidates(.linux)[0].path);
    const mac = vk.libraryCandidates(.macos);
    try std.testing.expectEqual(vk.LibraryKind.loader, mac[0].kind);
    try std.testing.expectEqual(vk.LibraryKind.moltenvk, mac[mac.len - 1].kind);
    const ios = vk.libraryCandidates(.ios);
    try std.testing.expectEqualStrings("@executable_path/Frameworks/libMoltenVK.dylib", ios[0].path);
    try std.testing.expectEqual(vk.LibraryKind.moltenvk, ios[0].kind);
    try std.testing.expectEqual(vk.LibraryKind.none, vk.libraryKind());
    try std.testing.expectEqualStrings("VK_KHR_portability_enumeration", vk.portability.instance_extension);
    try std.testing.expectEqualStrings("VK_KHR_portability_subset", vk.portability.device_extension);
    try std.testing.expectEqual(@as(u32, 1), @intFromEnum(vk.portability.instance_flag));
}

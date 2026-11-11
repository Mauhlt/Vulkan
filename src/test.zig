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

# Vulkan
- Contains list of vulkan commands, data structures, errors, enums, unions, and memory for easy integration in zig
- Created using TranslateVulkan repository + has VulkanErrors

## To Add To Build File:

1. Copy + Paste this command into terminal at root of zig project.
```zig
zig fetch --save git+https://github.com/Mauhlt/Vulkan.git
```

2. Add within the build.zig, within the build fn, these lines:
```zig
const Vulkan = b.dependency("Vulkan", .{});
exe.root_module.addImport("Vulkan", Vulkan.module("Vulkan"));
```

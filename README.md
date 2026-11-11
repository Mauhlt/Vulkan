# Vulkan

Vulkan bindings for Zig, as one self-contained file: `src/root.zig`.

`src/root.zig` is **generated** by [TranslateVulkan](https://github.com/Mauhlt/TranslateVulkan)
from the Khronos registry (vk.xml + video.xml). Don't edit it by hand. To update it, run
`zig build update && zig build test snapshot compat` in TranslateVulkan, then copy
`generated/vk.zig` here.

No `vulkan-1.lib` or C headers are needed: `vk.loadLibrary()` opens the system loader
at runtime.

## Add to a project

```sh
zig fetch --save git+https://github.com/Mauhlt/Vulkan.git
```

```zig
const vulkan = b.dependency("Vulkan", .{});
exe.root_module.addImport("Vulkan", vulkan.module("Vulkan"));
```

## Use

```zig
const vk = @import("Vulkan");

try vk.loadLibrary();
const app: vk.ApplicationInfo = .{ .p_application_name = "demo", .api_version = vk.api_version_1_3 };
var instance: vk.Instance = .null;
try vk.createInstance(&.{ .p_application_info = &app }, null, &instance);
vk.loadInstance(instance); // instance + device commands
defer vk.destroyInstance(instance, null);
```

Naming: `VkInstanceCreateInfo` → `vk.InstanceCreateInfo`, `vkCreateInstance` →
`vk.createInstance`, `VK_FORMAT_R8G8B8A8_UNORM` → `vk.Format.r8g8b8a8_unorm`,
`VK_ERROR_OUT_OF_DATE_KHR` → `error.OutOfDateKHR`. The full table is in the
TranslateVulkan README.

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

## Loader and MoltenVK (macOS / iOS)

`vk.loadLibrary()` tries `vk.libraryCandidates(builtin.os.tag)` in order:

| OS | Tried |
|---|---|
| Windows | `vulkan-1.dll` |
| Linux | `libvulkan.so.1`, `libvulkan.so` |
| macOS | the Khronos loader first (`libvulkan.1.dylib`: dyld search path, the app's `Contents/Frameworks`, `/usr/local/lib`, `/opt/homebrew/lib`), then MoltenVK directly (`libMoltenVK.dylib`, same places, or `MoltenVK.framework`) |
| iOS | MoltenVK embedded in the app bundle, as Apple requires: `@executable_path/Frameworks/libMoltenVK.dylib`, then `.../MoltenVK.framework/MoltenVK`, `@rpath/...`, then a bundled `libvulkan.1.dylib` |

`vk.loadLibraryFrom(candidates)` takes an app-chosen list instead, and
`vk.libraryKind()` says whether a loader or MoltenVK itself was opened.

MoltenVK is a portability implementation. `vk.portability` names what an
application enables when the implementation offers it:
`VK_KHR_portability_enumeration` + `InstanceCreateFlags.enumerate_portability_bit_khr`
on the instance (with `VK_KHR_get_physical_device_properties2`), and
`VK_KHR_portability_subset` on the device; `VK_EXT_metal_surface` for a
`CAMetalLayer`.

This loader code is TranslateVulkan's hand-written preamble
(`src/preamble.zig`, spliced into `src/root.zig`): a regeneration keeps it.

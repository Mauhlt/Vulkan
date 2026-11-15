# Third-party material

This repository's own code (build.zig, src/test.zig, the README) is under the MIT
licence in [LICENSE](LICENSE). The material below is not, and keeps its own terms.

## Khronos Vulkan API Registry (vk.xml, video.xml)

- What: the bindings published as module `Vulkan` (vk.zig) are generated at build
  time from the Khronos Vulkan API Registry, `registry/vk.xml` and
  `registry/video.xml`. vk.zig is a derived work of the registry.
- Where it comes from: nothing generated or vendored is committed here. The
  generator, [TranslateVulkan](https://github.com/Mauhlt/TranslateVulkan) (a
  dependency pinned in build.zig.zon), pins
  [KhronosGroup/Vulkan-Headers](https://github.com/KhronosGroup/Vulkan-Headers) by
  commit and reads the registry from it.
- Copyright: Copyright 2015-2026 The Khronos Group Inc. (vk.xml); Copyright
  2021-2026 The Khronos Group Inc. (video.xml).
- Licence: `SPDX-License-Identifier: Apache-2.0 OR MIT`, as stated in both files'
  headers and in Vulkan-Headers' LICENSE.md. The generated bindings carry those
  terms; they are not relicensed by this repository.
- Licence texts: Apache-2.0 <https://opensource.org/licenses/Apache-2.0>, MIT
  <https://opensource.org/licenses/MIT>.

The Vulkan loader (`vulkan-1.dll`, `libvulkan`) and MoltenVK are opened at run
time; neither is distributed with this package.

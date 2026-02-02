# FORGE

**GPU-driven 3D scene renderer for Zig**

FORGE is a GPU-driven 3D scene renderer built on BLAZE. It implements modern rendering techniques: meshlets, GPU culling, indirect rendering, and material batching.

## Target Use Cases

- WoW-style game rendering (many objects, stylized art, performance over realism)
- Structural engineering visualization (CAD-like, interactive manipulation)
- General 3D applications

## Key Features

- **Comptime Scene Configuration** - Define what your scene supports at compile time. No runtime feature checks in hot paths.
- **Data-Oriented Entity Storage** - Struct of Arrays for cache efficiency during culling.
- **Meshlet-Based Rendering** - Small mesh chunks that can be independently GPU-culled.
- **GPU Culling** - Frustum and occlculling in compute shaders.
- **Material Batching** - Minimal draw calls via indirect rendering.

## Design Principles

1. Comptime over runtime
2. Explicit over implicit
3. Data-oriented design
4. Zero-cost abstractions
5. Incremental complexity

## Dependencies

- [BLAZE](https://github.com/hotschmoe/blaze) - GPU abstraction layer

## Status

🚧 **Work in Progress** - Not ready for production use.

## License

MIT © hotschmoe

---

*Part of the [zig-graphics](https://github.com/hotschmoe/zig-graphics) stack: BLAZE → FORGE → FLUX*

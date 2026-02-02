//! FORGE Conformance Test Suite - Render Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.render",
    .tests = &.{
        .{ .name = "RND-001_clear_color", .run = clearColor, .requires_gpu = true, .golden_test = true },
        .{ .name = "RND-002_draw_triangle", .run = drawTriangle, .requires_gpu = true, .golden_test = true },
        .{ .name = "RND-003_draw_indexed", .run = drawIndexed, .requires_gpu = true },
        .{ .name = "RND-004_draw_instanced", .run = drawInstanced, .requires_gpu = true },
        .{ .name = "RND-005_depth_test", .run = depthTest, .requires_gpu = true, .golden_test = true },
        .{ .name = "RND-006_alpha_blend", .run = alphaBlend, .requires_gpu = true, .golden_test = true },
        .{ .name = "RND-007_scissor_test", .run = scissorTest, .requires_gpu = true },
        .{ .name = "RND-008_viewport", .run = viewport, .requires_gpu = true },
        .{ .name = "RND-009_render_target", .run = renderTarget, .requires_gpu = true },
        .{ .name = "RND-010_msaa", .run = msaa, .requires_gpu = true, .golden_test = true },
        .{ .name = "RND-011_wireframe", .run = wireframe, .requires_gpu = true },
        .{ .name = "RND-012_draw_order", .run = drawOrder, .requires_gpu = true },
        .{ .name = "RND-013_batch_rendering", .run = batchRendering, .requires_gpu = true },
        .{ .name = "RND-014_texture_sampling", .run = textureSampling, .requires_gpu = true, .golden_test = true },
        .{ .name = "RND-015_mipmap", .run = mipmap, .requires_gpu = true },
        .{ .name = "RND-016_pbr_shading", .run = pbrShading, .requires_gpu = true, .golden_test = true },
    },
};

fn clearColor() framework.TestError!void {
    return error.NotImplemented;
}

fn drawTriangle() framework.TestError!void {
    return error.NotImplemented;
}

fn drawIndexed() framework.TestError!void {
    return error.NotImplemented;
}

fn drawInstanced() framework.TestError!void {
    return error.NotImplemented;
}

fn depthTest() framework.TestError!void {
    return error.NotImplemented;
}

fn alphaBlend() framework.TestError!void {
    return error.NotImplemented;
}

fn scissorTest() framework.TestError!void {
    return error.NotImplemented;
}

fn viewport() framework.TestError!void {
    return error.NotImplemented;
}

fn renderTarget() framework.TestError!void {
    return error.NotImplemented;
}

fn msaa() framework.TestError!void {
    return error.NotImplemented;
}

fn wireframe() framework.TestError!void {
    return error.NotImplemented;
}

fn drawOrder() framework.TestError!void {
    return error.NotImplemented;
}

fn batchRendering() framework.TestError!void {
    return error.NotImplemented;
}

fn textureSampling() framework.TestError!void {
    return error.NotImplemented;
}

fn mipmap() framework.TestError!void {
    return error.NotImplemented;
}

fn pbrShading() framework.TestError!void {
    return error.NotImplemented;
}

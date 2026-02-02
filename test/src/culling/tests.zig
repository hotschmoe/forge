//! FORGE Conformance Test Suite - Culling Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.culling",
    .tests = &.{
        .{ .name = "CUL-001_frustum_planes", .run = frustumPlanes },
        .{ .name = "CUL-002_point_in_frustum", .run = pointInFrustum },
        .{ .name = "CUL-003_sphere_frustum", .run = sphereFrustum },
        .{ .name = "CUL-004_aabb_frustum", .run = aabbFrustum },
        .{ .name = "CUL-005_obb_frustum", .run = obbFrustum },
        .{ .name = "CUL-006_batch_culling", .run = batchCulling },
        .{ .name = "CUL-007_backface_culling", .run = backfaceCulling },
        .{ .name = "CUL-008_distance_culling", .run = distanceCulling },
        .{ .name = "CUL-009_occlusion_query", .run = occlusionQuery, .requires_gpu = true },
        .{ .name = "CUL-010_hierarchical_culling", .run = hierarchicalCulling },
        .{ .name = "CUL-011_portal_culling", .run = portalCulling },
        .{ .name = "CUL-012_screen_size_culling", .run = screenSizeCulling },
    },
};

fn frustumPlanes() framework.TestError!void {
    return error.NotImplemented;
}

fn pointInFrustum() framework.TestError!void {
    return error.NotImplemented;
}

fn sphereFrustum() framework.TestError!void {
    return error.NotImplemented;
}

fn aabbFrustum() framework.TestError!void {
    return error.NotImplemented;
}

fn obbFrustum() framework.TestError!void {
    return error.NotImplemented;
}

fn batchCulling() framework.TestError!void {
    return error.NotImplemented;
}

fn backfaceCulling() framework.TestError!void {
    return error.NotImplemented;
}

fn distanceCulling() framework.TestError!void {
    return error.NotImplemented;
}

fn occlusionQuery() framework.TestError!void {
    return error.NotImplemented;
}

fn hierarchicalCulling() framework.TestError!void {
    return error.NotImplemented;
}

fn portalCulling() framework.TestError!void {
    return error.NotImplemented;
}

fn screenSizeCulling() framework.TestError!void {
    return error.NotImplemented;
}

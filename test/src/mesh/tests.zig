//! FORGE Conformance Test Suite - Mesh Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.mesh",
    .tests = &.{
        .{ .name = "MSH-001_create_empty_mesh", .run = createEmptyMesh },
        .{ .name = "MSH-002_create_triangle", .run = createTriangle },
        .{ .name = "MSH-003_create_quad", .run = createQuad },
        .{ .name = "MSH-004_create_cube", .run = createCube },
        .{ .name = "MSH-005_create_sphere", .run = createSphere },
        .{ .name = "MSH-006_create_cylinder", .run = createCylinder },
        .{ .name = "MSH-007_create_plane", .run = createPlane },
        .{ .name = "MSH-008_vertex_attributes", .run = vertexAttributes },
        .{ .name = "MSH-009_index_buffer", .run = indexBuffer },
        .{ .name = "MSH-010_mesh_bounds", .run = meshBounds },
        .{ .name = "MSH-011_mesh_transform", .run = meshTransform },
        .{ .name = "MSH-012_mesh_merge", .run = meshMerge },
        .{ .name = "MSH-013_normal_generation", .run = normalGeneration },
        .{ .name = "MSH-014_tangent_generation", .run = tangentGeneration },
        .{ .name = "MSH-015_uv_generation", .run = uvGeneration },
        .{ .name = "MSH-016_mesh_validation", .run = meshValidation },
    },
};

fn createEmptyMesh() framework.TestError!void {
    return error.NotImplemented;
}

fn createTriangle() framework.TestError!void {
    return error.NotImplemented;
}

fn createQuad() framework.TestError!void {
    return error.NotImplemented;
}

fn createCube() framework.TestError!void {
    return error.NotImplemented;
}

fn createSphere() framework.TestError!void {
    return error.NotImplemented;
}

fn createCylinder() framework.TestError!void {
    return error.NotImplemented;
}

fn createPlane() framework.TestError!void {
    return error.NotImplemented;
}

fn vertexAttributes() framework.TestError!void {
    return error.NotImplemented;
}

fn indexBuffer() framework.TestError!void {
    return error.NotImplemented;
}

fn meshBounds() framework.TestError!void {
    return error.NotImplemented;
}

fn meshTransform() framework.TestError!void {
    return error.NotImplemented;
}

fn meshMerge() framework.TestError!void {
    return error.NotImplemented;
}

fn normalGeneration() framework.TestError!void {
    return error.NotImplemented;
}

fn tangentGeneration() framework.TestError!void {
    return error.NotImplemented;
}

fn uvGeneration() framework.TestError!void {
    return error.NotImplemented;
}

fn meshValidation() framework.TestError!void {
    return error.NotImplemented;
}

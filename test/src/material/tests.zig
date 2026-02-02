//! FORGE Conformance Test Suite - Material Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.material",
    .tests = &.{
        .{ .name = "MAT-001_create_material", .run = createMaterial },
        .{ .name = "MAT-002_pbr_material", .run = pbrMaterial },
        .{ .name = "MAT-003_unlit_material", .run = unlitMaterial },
        .{ .name = "MAT-004_albedo_color", .run = albedoColor },
        .{ .name = "MAT-005_albedo_texture", .run = albedoTexture },
        .{ .name = "MAT-006_normal_map", .run = normalMap },
        .{ .name = "MAT-007_metallic_roughness", .run = metallicRoughness },
        .{ .name = "MAT-008_emissive", .run = emissive },
        .{ .name = "MAT-009_transparency", .run = transparency },
        .{ .name = "MAT-010_double_sided", .run = doubleSided },
        .{ .name = "MAT-011_material_instance", .run = materialInstance },
        .{ .name = "MAT-012_shader_binding", .run = shaderBinding },
    },
};

fn createMaterial() framework.TestError!void {
    return error.NotImplemented;
}

fn pbrMaterial() framework.TestError!void {
    return error.NotImplemented;
}

fn unlitMaterial() framework.TestError!void {
    return error.NotImplemented;
}

fn albedoColor() framework.TestError!void {
    return error.NotImplemented;
}

fn albedoTexture() framework.TestError!void {
    return error.NotImplemented;
}

fn normalMap() framework.TestError!void {
    return error.NotImplemented;
}

fn metallicRoughness() framework.TestError!void {
    return error.NotImplemented;
}

fn emissive() framework.TestError!void {
    return error.NotImplemented;
}

fn transparency() framework.TestError!void {
    return error.NotImplemented;
}

fn doubleSided() framework.TestError!void {
    return error.NotImplemented;
}

fn materialInstance() framework.TestError!void {
    return error.NotImplemented;
}

fn shaderBinding() framework.TestError!void {
    return error.NotImplemented;
}

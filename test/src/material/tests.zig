//! FORGE Conformance Test Suite - Material Tests
//!
//! Tests for material creation, properties, and shader binding.

const std = @import("std");
const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.material",
    .tests = &.{
        .{ .name = "MAT-001_create_material", .run = createMaterial, .description = "Create a default material" },
        .{ .name = "MAT-002_pbr_material", .run = pbrMaterial, .description = "Create a PBR material" },
        .{ .name = "MAT-003_unlit_material", .run = unlitMaterial, .description = "Create an unlit material" },
        .{ .name = "MAT-004_albedo_color", .run = albedoColor, .description = "Set material albedo color" },
        .{ .name = "MAT-005_albedo_texture", .run = albedoTexture, .description = "Set material albedo texture" },
        .{ .name = "MAT-006_normal_map", .run = normalMap, .description = "Set material normal map" },
        .{ .name = "MAT-007_metallic_roughness", .run = metallicRoughness, .description = "Set metallic/roughness properties" },
        .{ .name = "MAT-008_emissive", .run = emissive, .description = "Set emissive properties" },
        .{ .name = "MAT-009_transparency", .run = transparency, .description = "Set material transparency" },
        .{ .name = "MAT-010_double_sided", .run = doubleSided, .description = "Enable double-sided rendering" },
        .{ .name = "MAT-011_material_instance", .run = materialInstance, .description = "Create material instances" },
        .{ .name = "MAT-012_shader_binding", .run = shaderBinding, .description = "Verify shader uniform binding" },
    },
};

fn createMaterial() framework.TestError!void {
    // TODO: Implement
    // const material = forge.Material.create(.{});
    // defer material.deinit();
    // try framework.expect(material.isValid());
    return error.NotImplemented;
}

fn pbrMaterial() framework.TestError!void {
    // TODO: Implement
    // const material = forge.Material.pbr(.{
    //     .albedo = .{ 1.0, 0.0, 0.0, 1.0 },
    //     .metallic = 0.0,
    //     .roughness = 0.5,
    // });
    return error.NotImplemented;
}

fn unlitMaterial() framework.TestError!void {
    // TODO: Implement
    // const material = forge.Material.unlit(.{
    //     .color = .{ 1.0, 1.0, 1.0, 1.0 },
    // });
    return error.NotImplemented;
}

fn albedoColor() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn albedoTexture() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn normalMap() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn metallicRoughness() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn emissive() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn transparency() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn doubleSided() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn materialInstance() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn shaderBinding() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

test "material tests compile" {
    _ = suite;
}

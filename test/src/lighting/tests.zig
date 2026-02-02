//! FORGE Conformance Test Suite - Lighting Tests
//!
//! Tests for lighting calculations, shadow mapping, and global illumination.

const std = @import("std");
const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.lighting",
    .tests = &.{
        .{ .name = "LIT-001_directional_light", .run = directionalLight, .description = "Create directional light" },
        .{ .name = "LIT-002_point_light", .run = pointLight, .description = "Create point light" },
        .{ .name = "LIT-003_spot_light", .run = spotLight, .description = "Create spot light" },
        .{ .name = "LIT-004_ambient_light", .run = ambientLight, .description = "Set ambient lighting" },
        .{ .name = "LIT-005_light_color", .run = lightColor, .description = "Set light color and intensity" },
        .{ .name = "LIT-006_light_attenuation", .run = lightAttenuation, .description = "Configure light attenuation" },
        .{ .name = "LIT-007_shadow_mapping", .run = shadowMapping, .description = "Basic shadow mapping", .requires_gpu = true, .golden_test = true },
        .{ .name = "LIT-008_cascaded_shadows", .run = cascadedShadows, .description = "Cascaded shadow maps", .requires_gpu = true },
        .{ .name = "LIT-009_soft_shadows", .run = softShadows, .description = "Soft shadow filtering", .requires_gpu = true },
        .{ .name = "LIT-010_multiple_lights", .run = multipleLights, .description = "Multiple light sources", .requires_gpu = true },
        .{ .name = "LIT-011_light_culling", .run = lightCulling, .description = "Light volume culling" },
        .{ .name = "LIT-012_ibl", .run = ibl, .description = "Image-based lighting", .requires_gpu = true },
    },
};

fn directionalLight() framework.TestError!void {
    // TODO: Implement
    // const light = forge.Light.directional(.{
    //     .direction = .{ 0, -1, 0 },
    //     .color = .{ 1, 1, 1 },
    //     .intensity = 1.0,
    // });
    return error.NotImplemented;
}

fn pointLight() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn spotLight() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn ambientLight() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn lightColor() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn lightAttenuation() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn shadowMapping() framework.TestError!void {
    // TODO: Implement
    // Render scene with shadows and compare to golden image
    return error.NotImplemented;
}

fn cascadedShadows() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn softShadows() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn multipleLights() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn lightCulling() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

fn ibl() framework.TestError!void {
    // TODO: Implement
    return error.NotImplemented;
}

test "lighting tests compile" {
    _ = suite;
}

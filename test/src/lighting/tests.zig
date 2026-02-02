//! FORGE Conformance Test Suite - Lighting Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.lighting",
    .tests = &.{
        .{ .name = "LIT-001_directional_light", .run = directionalLight },
        .{ .name = "LIT-002_point_light", .run = pointLight },
        .{ .name = "LIT-003_spot_light", .run = spotLight },
        .{ .name = "LIT-004_ambient_light", .run = ambientLight },
        .{ .name = "LIT-005_light_color", .run = lightColor },
        .{ .name = "LIT-006_light_attenuation", .run = lightAttenuation },
        .{ .name = "LIT-007_shadow_mapping", .run = shadowMapping, .requires_gpu = true, .golden_test = true },
        .{ .name = "LIT-008_cascaded_shadows", .run = cascadedShadows, .requires_gpu = true },
        .{ .name = "LIT-009_soft_shadows", .run = softShadows, .requires_gpu = true },
        .{ .name = "LIT-010_multiple_lights", .run = multipleLights, .requires_gpu = true },
        .{ .name = "LIT-011_light_culling", .run = lightCulling },
        .{ .name = "LIT-012_ibl", .run = ibl, .requires_gpu = true },
    },
};

fn directionalLight() framework.TestError!void {
    return error.NotImplemented;
}

fn pointLight() framework.TestError!void {
    return error.NotImplemented;
}

fn spotLight() framework.TestError!void {
    return error.NotImplemented;
}

fn ambientLight() framework.TestError!void {
    return error.NotImplemented;
}

fn lightColor() framework.TestError!void {
    return error.NotImplemented;
}

fn lightAttenuation() framework.TestError!void {
    return error.NotImplemented;
}

fn shadowMapping() framework.TestError!void {
    return error.NotImplemented;
}

fn cascadedShadows() framework.TestError!void {
    return error.NotImplemented;
}

fn softShadows() framework.TestError!void {
    return error.NotImplemented;
}

fn multipleLights() framework.TestError!void {
    return error.NotImplemented;
}

fn lightCulling() framework.TestError!void {
    return error.NotImplemented;
}

fn ibl() framework.TestError!void {
    return error.NotImplemented;
}

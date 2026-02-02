//! FORGE Conformance Test Suite - Camera Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.camera",
    .tests = &.{
        .{ .name = "CAM-001_perspective_projection", .run = perspectiveProjection },
        .{ .name = "CAM-002_orthographic_projection", .run = orthographicProjection },
        .{ .name = "CAM-003_view_matrix", .run = viewMatrix },
        .{ .name = "CAM-004_look_at", .run = lookAt },
        .{ .name = "CAM-005_orbit_camera", .run = orbitCamera },
        .{ .name = "CAM-006_fps_camera", .run = fpsCamera },
        .{ .name = "CAM-007_zoom", .run = zoom },
        .{ .name = "CAM-008_pan", .run = pan },
        .{ .name = "CAM-009_screen_to_world", .run = screenToWorld },
        .{ .name = "CAM-010_world_to_screen", .run = worldToScreen },
        .{ .name = "CAM-011_aspect_ratio", .run = aspectRatio },
        .{ .name = "CAM-012_near_far_planes", .run = nearFarPlanes },
    },
};

fn perspectiveProjection() framework.TestError!void {
    return error.NotImplemented;
}

fn orthographicProjection() framework.TestError!void {
    return error.NotImplemented;
}

fn viewMatrix() framework.TestError!void {
    return error.NotImplemented;
}

fn lookAt() framework.TestError!void {
    return error.NotImplemented;
}

fn orbitCamera() framework.TestError!void {
    return error.NotImplemented;
}

fn fpsCamera() framework.TestError!void {
    return error.NotImplemented;
}

fn zoom() framework.TestError!void {
    return error.NotImplemented;
}

fn pan() framework.TestError!void {
    return error.NotImplemented;
}

fn screenToWorld() framework.TestError!void {
    return error.NotImplemented;
}

fn worldToScreen() framework.TestError!void {
    return error.NotImplemented;
}

fn aspectRatio() framework.TestError!void {
    return error.NotImplemented;
}

fn nearFarPlanes() framework.TestError!void {
    return error.NotImplemented;
}

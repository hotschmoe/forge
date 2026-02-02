//! FORGE Conformance Test Suite - Scene Tests

const framework = @import("../framework.zig");

pub const suite = framework.TestSuite{
    .name = "forge.scene",
    .tests = &.{
        .{ .name = "SCN-001_create_scene", .run = createScene },
        .{ .name = "SCN-002_create_configured", .run = createConfigured },
        .{ .name = "SCN-003_add_object", .run = addObject },
        .{ .name = "SCN-004_add_many_objects", .run = addManyObjects },
        .{ .name = "SCN-005_remove_object", .run = removeObject },
        .{ .name = "SCN-006_clear_scene", .run = clearScene },
        .{ .name = "SCN-007_scene_bounds", .run = sceneBounds },
        .{ .name = "SCN-008_object_lookup", .run = objectLookup },
        .{ .name = "SCN-009_object_iteration", .run = objectIteration },
        .{ .name = "SCN-010_nested_scenes", .run = nestedScenes },
        .{ .name = "SCN-011_scene_serialization", .run = sceneSerialization },
        .{ .name = "SCN-012_scene_clone", .run = sceneClone },
    },
};

fn createScene() framework.TestError!void {
    return error.NotImplemented;
}

fn createConfigured() framework.TestError!void {
    return error.NotImplemented;
}

fn addObject() framework.TestError!void {
    return error.NotImplemented;
}

fn addManyObjects() framework.TestError!void {
    return error.NotImplemented;
}

fn removeObject() framework.TestError!void {
    return error.NotImplemented;
}

fn clearScene() framework.TestError!void {
    return error.NotImplemented;
}

fn sceneBounds() framework.TestError!void {
    return error.NotImplemented;
}

fn objectLookup() framework.TestError!void {
    return error.NotImplemented;
}

fn objectIteration() framework.TestError!void {
    return error.NotImplemented;
}

fn nestedScenes() framework.TestError!void {
    return error.NotImplemented;
}

fn sceneSerialization() framework.TestError!void {
    return error.NotImplemented;
}

fn sceneClone() framework.TestError!void {
    return error.NotImplemented;
}

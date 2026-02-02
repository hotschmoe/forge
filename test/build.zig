//! FORGE Conformance Test Suite - Build Configuration

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const runner_exe = b.addExecutable(.{
        .name = "forge-cts",
        .root_source_file = b.path("src/runner.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(runner_exe);

    // Run the test suite
    const run_cmd = b.addRunArtifact(runner_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const run_step = b.step("test-cts", "Run the FORGE conformance test suite");
    run_step.dependOn(&run_cmd.step);

    // Unit tests for the test framework itself
    const framework_tests = b.addTest(.{
        .root_source_file = b.path("src/framework.zig"),
        .target = target,
        .optimize = optimize,
    });
    const golden_tests = b.addTest(.{
        .root_source_file = b.path("src/golden.zig"),
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run framework unit tests");
    test_step.dependOn(&b.addRunArtifact(framework_tests).step);
    test_step.dependOn(&b.addRunArtifact(golden_tests).step);

    // Convenience steps
    const update_golden_cmd = b.addRunArtifact(runner_exe);
    update_golden_cmd.addArg("--update-golden");
    b.step("update-golden", "Update golden reference images").dependOn(&update_golden_cmd.step);

    const list_cmd = b.addRunArtifact(runner_exe);
    list_cmd.addArg("--list");
    b.step("list-tests", "List all available conformance tests").dependOn(&list_cmd.step);
}

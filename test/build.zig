//! FORGE Conformance Test Suite - Build Configuration
//!
//! Build script for compiling and running FORGE conformance tests.

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Attempt to get forge module from parent build, or create a stub
    const forge_module = b.dependency("forge", .{
        .target = target,
        .optimize = optimize,
    }).module("forge") catch null;

    // Build the test runner executable
    const runner_exe = b.addExecutable(.{
        .name = "forge-cts",
        .root_source_file = b.path("src/runner.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add forge module if available
    if (forge_module) |mod| {
        runner_exe.root_module.addImport("forge", mod);
    }

    b.installArtifact(runner_exe);

    // Run the test suite
    const run_cmd = b.addRunArtifact(runner_exe);
    run_cmd.step.dependOn(b.getInstallStep());

    // Pass command line arguments to runner
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

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

    const run_framework_tests = b.addRunArtifact(framework_tests);
    const run_golden_tests = b.addRunArtifact(golden_tests);

    const test_step = b.step("test", "Run framework unit tests");
    test_step.dependOn(&run_framework_tests.step);
    test_step.dependOn(&run_golden_tests.step);

    // Golden image update step
    const update_golden_cmd = b.addRunArtifact(runner_exe);
    update_golden_cmd.addArg("--update-golden");

    const update_golden_step = b.step("update-golden", "Update golden reference images");
    update_golden_step.dependOn(&update_golden_cmd.step);

    // List tests step
    const list_cmd = b.addRunArtifact(runner_exe);
    list_cmd.addArg("--list");

    const list_step = b.step("list-tests", "List all available conformance tests");
    list_step.dependOn(&list_cmd.step);
}

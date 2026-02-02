//! FORGE Conformance Test Suite - Test Runner
//!
//! Main entry point for running FORGE conformance tests.

const std = @import("std");
const framework = @import("framework.zig");

const scene_tests = @import("scene/tests.zig");
const mesh_tests = @import("mesh/tests.zig");
const material_tests = @import("material/tests.zig");
const culling_tests = @import("culling/tests.zig");
const camera_tests = @import("camera/tests.zig");
const lighting_tests = @import("lighting/tests.zig");
const render_tests = @import("render/tests.zig");

const all_suites = [_]*const framework.TestSuite{
    &scene_tests.suite,
    &mesh_tests.suite,
    &material_tests.suite,
    &culling_tests.suite,
    &camera_tests.suite,
    &lighting_tests.suite,
    &render_tests.suite,
};

const OutputFormat = enum { text, json, junit };

const Options = struct {
    filter: ?[]const u8 = null,
    suite: ?[]const u8 = null,
    update_golden: bool = false,
    verbose: bool = false,
    skip_gpu: bool = false,
    help: bool = false,
    list: bool = false,
    format: OutputFormat = .text,
};

const RunnerResults = struct {
    total_passed: u32 = 0,
    total_failed: u32 = 0,
    total_skipped: u32 = 0,
    total_not_implemented: u32 = 0,
    suite_results: std.ArrayList(framework.SuiteResults),
    start_time: i64,
    end_time: i64 = 0,

    fn init(allocator: std.mem.Allocator) RunnerResults {
        return .{ .suite_results = std.ArrayList(framework.SuiteResults).init(allocator), .start_time = std.time.milliTimestamp() };
    }

    fn deinit(self: *RunnerResults) void {
        for (self.suite_results.items) |*result| result.deinit();
        self.suite_results.deinit();
    }

    fn total(self: RunnerResults) u32 {
        return self.total_passed + self.total_failed + self.total_skipped + self.total_not_implemented;
    }

    fn durationMs(self: RunnerResults) i64 {
        return self.end_time - self.start_time;
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const options = parseArgs() catch |err| {
        std.debug.print("Error parsing arguments: {}\n", .{err});
        printUsage();
        return;
    };

    if (options.help) {
        printUsage();
        return;
    }

    if (options.list) {
        listTests();
        return;
    }

    // Run tests
    var results = try runAllTests(allocator, options);
    defer results.deinit();

    // Output results
    switch (options.format) {
        .text => outputText(results, options.verbose),
        .json => outputJson(results),
        .junit => outputJunit(results),
    }

    // Exit with appropriate code
    if (results.total_failed > 0) {
        std.process.exit(1);
    }
}

fn parseArgs() !Options {
    var options = Options{};
    var args = std.process.args();
    _ = args.skip();

    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            options.help = true;
        } else if (std.mem.eql(u8, arg, "--list") or std.mem.eql(u8, arg, "-l")) {
            options.list = true;
        } else if (std.mem.eql(u8, arg, "--verbose") or std.mem.eql(u8, arg, "-v")) {
            options.verbose = true;
        } else if (std.mem.eql(u8, arg, "--update-golden")) {
            options.update_golden = true;
        } else if (std.mem.eql(u8, arg, "--skip-gpu")) {
            options.skip_gpu = true;
        } else if (std.mem.startsWith(u8, arg, "--filter=")) {
            options.filter = arg[9..];
        } else if (std.mem.startsWith(u8, arg, "--suite=")) {
            options.suite = arg[8..];
        } else if (std.mem.startsWith(u8, arg, "--format=")) {
            const fmt = arg[9..];
            options.format = if (std.mem.eql(u8, fmt, "json")) .json else if (std.mem.eql(u8, fmt, "junit")) .junit else .text;
        }
    }

    return options;
}

fn printUsage() void {
    std.debug.print(
        \\FORGE Conformance Test Suite Runner
        \\
        \\Usage: forge-cts [OPTIONS]
        \\
        \\Options:
        \\  -h, --help           Show this help message
        \\  -l, --list           List all available tests
        \\  -v, --verbose        Enable verbose output
        \\  --filter=PATTERN     Run only tests matching PATTERN
        \\  --suite=NAME         Run only the specified test suite
        \\  --update-golden      Update golden images instead of comparing
        \\  --skip-gpu           Skip tests requiring GPU access
        \\  --format=FORMAT      Output format: text, json, junit (default: text)
        \\
        \\Examples:
        \\  forge-cts --filter=SCN       Run all scene tests
        \\  forge-cts --suite=mesh -v    Run mesh tests with verbose output
        \\  forge-cts --update-golden    Update all golden reference images
        \\
    , .{});
}

fn listTests() void {
    std.debug.print("Available FORGE Conformance Tests:\n\n", .{});

    for (all_suites) |suite| {
        std.debug.print("{s}:\n", .{suite.name});
        for (suite.tests) |test_case| {
            const gpu_marker = if (test_case.requires_gpu) " [GPU]" else "";
            const golden_marker = if (test_case.golden_test) " [GOLDEN]" else "";
            std.debug.print("  {s}{s}{s}\n", .{ test_case.name, gpu_marker, golden_marker });
        }
        std.debug.print("\n", .{});
    }
}

fn runAllTests(allocator: std.mem.Allocator, options: Options) !RunnerResults {
    var results = RunnerResults.init(allocator);

    const config = framework.TestConfig{
        .allocator = allocator,
        .update_golden = options.update_golden,
        .run_gpu_tests = !options.skip_gpu,
        .filter = options.filter,
        .verbose = options.verbose,
    };

    for (all_suites) |suite| {
        if (options.suite) |suite_filter| {
            if (!std.mem.eql(u8, suite.name, suite_filter)) continue;
        }

        if (options.verbose) std.debug.print("\nRunning suite: {s}\n", .{suite.name});

        const suite_results = try framework.runSuite(suite, config);
        try results.suite_results.append(suite_results);

        results.total_passed += suite_results.passed;
        results.total_failed += suite_results.failed;
        results.total_skipped += suite_results.skipped;
        results.total_not_implemented += suite_results.not_implemented;
    }

    results.end_time = std.time.milliTimestamp();
    return results;
}

fn outputText(results: RunnerResults, verbose: bool) void {
    std.debug.print("\n", .{});
    std.debug.print("=" ** 60 ++ "\n", .{});
    std.debug.print("FORGE Conformance Test Suite Results\n", .{});
    std.debug.print("=" ** 60 ++ "\n\n", .{});

    for (results.suite_results.items) |suite_result| {
        std.debug.print("{s}: ", .{suite_result.suite_name});

        if (suite_result.suite_error) |err| {
            std.debug.print("SUITE ERROR: {}\n", .{err});
            continue;
        }

        std.debug.print("{d} passed", .{suite_result.passed});
        if (suite_result.failed > 0) {
            std.debug.print(", {d} FAILED", .{suite_result.failed});
        }
        if (suite_result.skipped > 0) {
            std.debug.print(", {d} skipped", .{suite_result.skipped});
        }
        if (suite_result.not_implemented > 0) {
            std.debug.print(", {d} not implemented", .{suite_result.not_implemented});
        }
        std.debug.print("\n", .{});

        if (verbose) {
            for (suite_result.test_results.items) |test_result| {
                const status = switch (test_result.result) {
                    .pass => "[PASS]",
                    .fail => "[FAIL]",
                    .skip => "[SKIP]",
                    .not_implemented => "[TODO]",
                };
                std.debug.print("    {s} {s}\n", .{ status, test_result.name });
            }
        }
    }

    std.debug.print("\n", .{});
    std.debug.print("-" ** 60 ++ "\n", .{});
    std.debug.print("Total: {d} tests in {d}ms\n", .{ results.total(), results.durationMs() });
    std.debug.print("  Passed:          {d}\n", .{results.total_passed});
    std.debug.print("  Failed:          {d}\n", .{results.total_failed});
    std.debug.print("  Skipped:         {d}\n", .{results.total_skipped});
    std.debug.print("  Not Implemented: {d}\n", .{results.total_not_implemented});
    std.debug.print("-" ** 60 ++ "\n", .{});

    if (results.total_failed == 0 and results.total_passed > 0) {
        std.debug.print("\nAll tests passed!\n", .{});
    } else if (results.total_failed > 0) {
        std.debug.print("\nSome tests failed.\n", .{});
    }
}

fn outputJson(results: RunnerResults) void {
    std.debug.print(
        \\{{
        \\  "total": {d},
        \\  "passed": {d},
        \\  "failed": {d},
        \\  "skipped": {d},
        \\  "not_implemented": {d},
        \\  "duration_ms": {d}
        \\}}
        \\
    , .{ results.total(), results.total_passed, results.total_failed, results.total_skipped, results.total_not_implemented, results.durationMs() });
}

fn outputJunit(results: RunnerResults) void {
    std.debug.print(
        \\<?xml version="1.0" encoding="UTF-8"?>
        \\<testsuites tests="{d}" failures="{d}" skipped="{d}">
        \\</testsuites>
        \\
    , .{ results.total(), results.total_failed, results.total_skipped + results.total_not_implemented });
}

test "runner compiles" {
    _ = all_suites;
}

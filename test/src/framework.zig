//! FORGE Conformance Test Suite - Framework
//!
//! Core testing infrastructure for FORGE conformance tests.
//! Provides test suite definitions, assertions, and helper utilities.

const std = @import("std");
const builtin = @import("builtin");

/// Error types that can occur during test execution.
pub const TestError = error{
    /// Test is not yet implemented.
    NotImplemented,
    /// Assertion failed.
    AssertionFailed,
    /// Expected value did not match actual value.
    ExpectationFailed,
    /// Golden image comparison failed.
    GoldenMismatch,
    /// Test setup failed.
    SetupFailed,
    /// Test cleanup failed.
    CleanupFailed,
    /// Timeout occurred during test execution.
    Timeout,
    /// Resource allocation failed.
    AllocationFailed,
    /// Invalid test configuration.
    InvalidConfiguration,
    /// File I/O error.
    FileError,
    /// GPU/rendering error.
    RenderError,
};

/// Result of a test execution.
pub const TestResult = union(enum) {
    /// Test passed successfully.
    pass,
    /// Test failed with an error.
    fail: TestError,
    /// Test was skipped.
    skip: []const u8,
    /// Test is not yet implemented.
    not_implemented,
};

/// A single test case within a test suite.
pub const TestCase = struct {
    /// Unique test identifier (e.g., "SCN-001_create_scene").
    name: []const u8,
    /// Test function to execute.
    run: *const fn () TestError!void,
    /// Optional description of what the test validates.
    description: ?[]const u8 = null,
    /// Whether this test requires GPU access.
    requires_gpu: bool = false,
    /// Whether this test performs golden image comparison.
    golden_test: bool = false,
    /// Tags for filtering tests.
    tags: []const []const u8 = &.{},
};

/// A collection of related test cases.
pub const TestSuite = struct {
    /// Suite name (e.g., "forge.scene").
    name: []const u8,
    /// Test cases in this suite.
    tests: []const TestCase,
    /// Optional setup function run before each test.
    setup: ?*const fn () TestError!void = null,
    /// Optional teardown function run after each test.
    teardown: ?*const fn () TestError!void = null,
    /// Optional one-time setup for the entire suite.
    suite_setup: ?*const fn () TestError!void = null,
    /// Optional one-time teardown for the entire suite.
    suite_teardown: ?*const fn () TestError!void = null,
};

/// Configuration for test execution.
pub const TestConfig = struct {
    /// Allocator for test operations.
    allocator: std.mem.Allocator,
    /// Whether to update golden images instead of comparing.
    update_golden: bool = false,
    /// Directory containing golden images.
    golden_dir: []const u8 = "golden",
    /// Directory for output diffs.
    diff_dir: []const u8 = "diffs",
    /// Directory for test assets.
    asset_dir: []const u8 = "assets",
    /// Tolerance for golden image comparison (0.0 - 1.0).
    golden_tolerance: f32 = 0.001,
    /// Whether to run GPU-dependent tests.
    run_gpu_tests: bool = true,
    /// Filter pattern for test names.
    filter: ?[]const u8 = null,
    /// Verbose output mode.
    verbose: bool = false,
};

// =============================================================================
// Assertion Helpers
// =============================================================================

/// Assert that two values are equal.
pub fn expectEqual(expected: anytype, actual: @TypeOf(expected)) TestError!void {
    if (expected != actual) {
        return error.ExpectationFailed;
    }
}

/// Assert that two optional values are equal.
pub fn expectEqualOptional(expected: anytype, actual: @TypeOf(expected)) TestError!void {
    if (expected == null and actual == null) return;
    if (expected == null or actual == null) return error.ExpectationFailed;
    if (expected.? != actual.?) return error.ExpectationFailed;
}

/// Assert that two slices are equal.
pub fn expectEqualSlices(comptime T: type, expected: []const T, actual: []const T) TestError!void {
    if (expected.len != actual.len) return error.ExpectationFailed;
    for (expected, actual) |e, a| {
        if (e != a) return error.ExpectationFailed;
    }
}

/// Assert that a value is true.
pub fn expect(value: bool) TestError!void {
    if (!value) return error.AssertionFailed;
}

/// Assert that a value is not null.
pub fn expectNotNull(value: anytype) TestError!void {
    if (value == null) return error.AssertionFailed;
}

/// Assert that a value is null.
pub fn expectNull(value: anytype) TestError!void {
    if (value != null) return error.AssertionFailed;
}

/// Assert that two floating point values are approximately equal.
pub fn expectApproxEqual(expected: anytype, actual: @TypeOf(expected), tolerance: @TypeOf(expected)) TestError!void {
    const diff = @abs(expected - actual);
    if (diff > tolerance) return error.ExpectationFailed;
}

/// Assert that an error occurred.
pub fn expectError(expected_error: anyerror, result: anytype) TestError!void {
    if (result) |_| {
        return error.ExpectationFailed;
    } else |err| {
        if (err != expected_error) return error.ExpectationFailed;
    }
}

// =============================================================================
// Scene Creation Helpers
// =============================================================================

/// Options for creating a test scene.
pub const TestSceneOptions = struct {
    /// Scene width in pixels.
    width: u32 = 800,
    /// Scene height in pixels.
    height: u32 = 600,
    /// Enable depth buffer.
    depth_buffer: bool = true,
    /// Enable MSAA.
    msaa_samples: u8 = 1,
    /// Background color (RGBA).
    clear_color: [4]f32 = .{ 0.0, 0.0, 0.0, 1.0 },
};

/// Create a minimal test scene with default configuration.
/// Returns a scene handle or error.
pub fn createTestScene(allocator: std.mem.Allocator) TestError!*TestSceneContext {
    return createTestSceneWithOptions(allocator, .{});
}

/// Create a test scene with custom options.
pub fn createTestSceneWithOptions(allocator: std.mem.Allocator, options: TestSceneOptions) TestError!*TestSceneContext {
    const ctx = allocator.create(TestSceneContext) catch return error.AllocationFailed;
    ctx.* = .{
        .allocator = allocator,
        .options = options,
        .initialized = true,
    };
    return ctx;
}

/// Test scene context for managing test resources.
pub const TestSceneContext = struct {
    allocator: std.mem.Allocator,
    options: TestSceneOptions,
    initialized: bool = false,
    // TODO: Add forge.Scene handle when available
    // scene: ?forge.Scene = null,

    pub fn deinit(self: *TestSceneContext) void {
        self.initialized = false;
        self.allocator.destroy(self);
    }

    /// Render the scene and return the framebuffer.
    pub fn render(self: *TestSceneContext) TestError![]u8 {
        _ = self;
        // TODO: Implement actual rendering
        return error.NotImplemented;
    }

    /// Capture the current framebuffer as an image.
    pub fn captureFramebuffer(self: *TestSceneContext) TestError!FramebufferCapture {
        _ = self;
        // TODO: Implement actual capture
        return error.NotImplemented;
    }
};

/// Captured framebuffer data.
pub const FramebufferCapture = struct {
    width: u32,
    height: u32,
    channels: u8,
    data: []u8,
    allocator: std.mem.Allocator,

    pub fn deinit(self: *FramebufferCapture) void {
        self.allocator.free(self.data);
    }
};

// =============================================================================
// Test Utilities
// =============================================================================

/// Log a message during test execution (only in verbose mode).
pub fn log(comptime fmt: []const u8, args: anytype) void {
    if (builtin.is_test) {
        std.debug.print(fmt ++ "\n", args);
    }
}

/// Measure execution time of a function.
pub fn measureTime(func: anytype, args: anytype) struct { result: @TypeOf(@call(.auto, func, args)), elapsed_ns: u64 } {
    const start = std.time.nanoTimestamp();
    const result = @call(.auto, func, args);
    const end = std.time.nanoTimestamp();
    return .{
        .result = result,
        .elapsed_ns = @intCast(end - start),
    };
}

/// Skip the current test with a reason.
pub fn skip(reason: []const u8) TestError {
    _ = reason;
    // TODO: Integrate with test runner for skip reporting
    return error.NotImplemented;
}

// =============================================================================
// Test Suite Registration
// =============================================================================

/// All registered test suites.
pub const all_suites = &[_]*const TestSuite{
    // Populated by build system or manual registration
};

/// Run all tests in a suite and return results.
pub fn runSuite(suite: *const TestSuite, config: TestConfig) !SuiteResults {
    var results = SuiteResults{
        .suite_name = suite.name,
        .passed = 0,
        .failed = 0,
        .skipped = 0,
        .not_implemented = 0,
        .test_results = std.ArrayList(SingleTestResult).init(config.allocator),
    };

    // Run suite setup if present
    if (suite.suite_setup) |setup| {
        setup() catch |err| {
            results.suite_error = err;
            return results;
        };
    }

    for (suite.tests) |test_case| {
        // Check filter
        if (config.filter) |filter| {
            if (std.mem.indexOf(u8, test_case.name, filter) == null) {
                continue;
            }
        }

        // Skip GPU tests if not enabled
        if (test_case.requires_gpu and !config.run_gpu_tests) {
            results.skipped += 1;
            try results.test_results.append(.{
                .name = test_case.name,
                .result = .{ .skip = "GPU tests disabled" },
            });
            continue;
        }

        // Run setup if present
        if (suite.setup) |setup| {
            setup() catch |err| {
                results.failed += 1;
                try results.test_results.append(.{
                    .name = test_case.name,
                    .result = .{ .fail = err },
                });
                continue;
            };
        }

        // Run the test
        const test_result: TestResult = blk: {
            test_case.run() catch |err| {
                if (err == error.NotImplemented) {
                    break :blk .not_implemented;
                }
                break :blk .{ .fail = err };
            };
            break :blk .pass;
        };

        // Run teardown if present
        if (suite.teardown) |teardown| {
            teardown() catch {};
        }

        // Record result
        switch (test_result) {
            .pass => results.passed += 1,
            .fail => results.failed += 1,
            .skip => results.skipped += 1,
            .not_implemented => results.not_implemented += 1,
        }

        try results.test_results.append(.{
            .name = test_case.name,
            .result = test_result,
        });
    }

    // Run suite teardown if present
    if (suite.suite_teardown) |teardown| {
        teardown() catch {};
    }

    return results;
}

/// Results from running a single test.
pub const SingleTestResult = struct {
    name: []const u8,
    result: TestResult,
    duration_ns: u64 = 0,
};

/// Aggregated results from running a test suite.
pub const SuiteResults = struct {
    suite_name: []const u8,
    passed: u32,
    failed: u32,
    skipped: u32,
    not_implemented: u32,
    test_results: std.ArrayList(SingleTestResult),
    suite_error: ?TestError = null,

    pub fn deinit(self: *SuiteResults) void {
        self.test_results.deinit();
    }

    pub fn total(self: SuiteResults) u32 {
        return self.passed + self.failed + self.skipped + self.not_implemented;
    }
};

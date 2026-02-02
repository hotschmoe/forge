//! FORGE Conformance Test Suite - Framework
//!
//! Core testing infrastructure for FORGE conformance tests.
//! Provides test suite definitions, assertions, and helper utilities.

const std = @import("std");

pub const TestError = error{
    NotImplemented,
    AssertionFailed,
    ExpectationFailed,
    GoldenMismatch,
    SetupFailed,
    CleanupFailed,
    Timeout,
    AllocationFailed,
    InvalidConfiguration,
    FileError,
    RenderError,
};

pub const TestResult = union(enum) {
    pass,
    fail: TestError,
    skip: []const u8,
    not_implemented,
};

pub const TestCase = struct {
    name: []const u8,
    run: *const fn () TestError!void,
    description: ?[]const u8 = null,
    requires_gpu: bool = false,
    golden_test: bool = false,
};

pub const TestSuite = struct {
    name: []const u8,
    tests: []const TestCase,
    setup: ?*const fn () TestError!void = null,
    teardown: ?*const fn () TestError!void = null,
    suite_setup: ?*const fn () TestError!void = null,
    suite_teardown: ?*const fn () TestError!void = null,
};

pub const TestConfig = struct {
    allocator: std.mem.Allocator,
    update_golden: bool = false,
    golden_dir: []const u8 = "golden",
    diff_dir: []const u8 = "diffs",
    asset_dir: []const u8 = "assets",
    golden_tolerance: f32 = 0.001,
    run_gpu_tests: bool = true,
    filter: ?[]const u8 = null,
    verbose: bool = false,
};

// Assertion helpers

pub fn expectEqual(expected: anytype, actual: @TypeOf(expected)) TestError!void {
    if (expected != actual) return error.ExpectationFailed;
}

pub fn expectEqualSlices(comptime T: type, expected: []const T, actual: []const T) TestError!void {
    if (expected.len != actual.len) return error.ExpectationFailed;
    for (expected, actual) |e, a| {
        if (e != a) return error.ExpectationFailed;
    }
}

pub fn expect(value: bool) TestError!void {
    if (!value) return error.AssertionFailed;
}

pub fn expectNotNull(value: anytype) TestError!void {
    if (value == null) return error.AssertionFailed;
}

pub fn expectNull(value: anytype) TestError!void {
    if (value != null) return error.AssertionFailed;
}

pub fn expectApproxEqual(expected: anytype, actual: @TypeOf(expected), tolerance: @TypeOf(expected)) TestError!void {
    if (@abs(expected - actual) > tolerance) return error.ExpectationFailed;
}

pub fn expectError(expected_error: anyerror, result: anytype) TestError!void {
    if (result) |_| {
        return error.ExpectationFailed;
    } else |err| {
        if (err != expected_error) return error.ExpectationFailed;
    }
}

// Test suite runner

pub fn runSuite(suite: *const TestSuite, config: TestConfig) !SuiteResults {
    var results = SuiteResults{
        .suite_name = suite.name,
        .test_results = std.ArrayList(SingleTestResult).init(config.allocator),
    };

    if (suite.suite_setup) |setup| {
        setup() catch |err| {
            results.suite_error = err;
            return results;
        };
    }

    for (suite.tests) |test_case| {
        if (config.filter) |filter| {
            if (std.mem.indexOf(u8, test_case.name, filter) == null) continue;
        }

        if (test_case.requires_gpu and !config.run_gpu_tests) {
            results.skipped += 1;
            try results.test_results.append(.{ .name = test_case.name, .result = .{ .skip = "GPU tests disabled" } });
            continue;
        }

        if (suite.setup) |setup| {
            setup() catch |err| {
                results.failed += 1;
                try results.test_results.append(.{ .name = test_case.name, .result = .{ .fail = err } });
                continue;
            };
        }

        const test_result: TestResult = blk: {
            test_case.run() catch |err| {
                break :blk if (err == error.NotImplemented) .not_implemented else .{ .fail = err };
            };
            break :blk .pass;
        };

        if (suite.teardown) |teardown| teardown() catch {};

        switch (test_result) {
            .pass => results.passed += 1,
            .fail => results.failed += 1,
            .skip => results.skipped += 1,
            .not_implemented => results.not_implemented += 1,
        }

        try results.test_results.append(.{ .name = test_case.name, .result = test_result });
    }

    if (suite.suite_teardown) |teardown| teardown() catch {};

    return results;
}

pub const SingleTestResult = struct {
    name: []const u8,
    result: TestResult,
};

pub const SuiteResults = struct {
    suite_name: []const u8,
    passed: u32 = 0,
    failed: u32 = 0,
    skipped: u32 = 0,
    not_implemented: u32 = 0,
    test_results: std.ArrayList(SingleTestResult),
    suite_error: ?TestError = null,

    pub fn deinit(self: *SuiteResults) void {
        self.test_results.deinit();
    }

    pub fn total(self: SuiteResults) u32 {
        return self.passed + self.failed + self.skipped + self.not_implemented;
    }
};

//! FORGE Conformance Test Suite - Golden Image Comparison
//!
//! Infrastructure for comparing rendered output against golden reference images.

const std = @import("std");
const framework = @import("framework.zig");

pub const ComparisonMode = enum {
    exact,
    tolerance,
    perceptual,
    ssim,
};

pub const ComparisonResult = struct {
    matches: bool,
    diff_percentage: f32,
    max_diff: u8,
    avg_diff: f32,
    ssim_score: f32 = -1,
    diff_image_path: ?[]const u8 = null,
};

pub const GoldenConfig = struct {
    golden_dir: []const u8 = "golden",
    diff_dir: []const u8 = "diffs",
    mode: ComparisonMode = .tolerance,
    pixel_tolerance: u8 = 2,
    diff_threshold: f32 = 0.1,
    generate_diffs: bool = true,
    update_mode: bool = false,
};

pub const GoldenManager = struct {
    allocator: std.mem.Allocator,
    config: GoldenConfig,

    pub fn init(allocator: std.mem.Allocator, config: GoldenConfig) GoldenManager {
        return .{ .allocator = allocator, .config = config };
    }

    pub fn compare(
        self: *GoldenManager,
        test_name: []const u8,
        category: []const u8,
        actual: []const u8,
        width: u32,
        height: u32,
    ) !ComparisonResult {
        const golden_path = try self.getGoldenPath(category, test_name);
        defer self.allocator.free(golden_path);

        if (self.config.update_mode) {
            try self.saveGolden(golden_path, actual, width, height);
            return .{ .matches = true, .diff_percentage = 0, .max_diff = 0, .avg_diff = 0, .ssim_score = 1.0 };
        }

        const golden = self.loadGolden(golden_path) catch |err| {
            if (err == error.FileNotFound) {
                return .{ .matches = false, .diff_percentage = 100, .max_diff = 255, .avg_diff = 255 };
            }
            return err;
        };
        defer self.allocator.free(golden.data);

        if (golden.width != width or golden.height != height) {
            return .{ .matches = false, .diff_percentage = 100, .max_diff = 255, .avg_diff = 255 };
        }

        return switch (self.config.mode) {
            .exact => self.compareExact(actual, golden.data),
            .tolerance, .perceptual => self.compareTolerance(actual, golden.data),
            .ssim => self.compareTolerance(actual, golden.data), // TODO: implement SSIM
        };
    }

    fn getGoldenPath(self: *GoldenManager, category: []const u8, test_name: []const u8) ![]u8 {
        return std.fmt.allocPrint(self.allocator, "{s}/{s}/{s}.png", .{ self.config.golden_dir, category, test_name });
    }

    fn loadGolden(self: *GoldenManager, path: []const u8) !GoldenImage {
        _ = self;
        _ = path;
        return error.FileNotFound; // TODO: Implement PNG loading
    }

    fn saveGolden(self: *GoldenManager, path: []const u8, data: []const u8, width: u32, height: u32) !void {
        _ = self;
        _ = path;
        _ = data;
        _ = width;
        _ = height;
        // TODO: Implement PNG saving
    }

    fn compareExact(self: *GoldenManager, actual: []const u8, golden: []const u8) ComparisonResult {
        _ = self;
        var diff_count: u32 = 0;
        var max_diff: u8 = 0;
        var total_diff: u64 = 0;

        for (actual, golden) |a, g| {
            if (a != g) {
                diff_count += 1;
                const diff: u8 = if (a > g) a - g else g - a;
                max_diff = @max(max_diff, diff);
                total_diff += diff;
            }
        }

        const pixel_count = actual.len / 4;
        const diff_pct = @as(f32, @floatFromInt(diff_count)) / @as(f32, @floatFromInt(pixel_count)) * 100.0;
        const avg = if (actual.len > 0) @as(f32, @floatFromInt(total_diff)) / @as(f32, @floatFromInt(actual.len)) else 0;

        return .{ .matches = diff_count == 0, .diff_percentage = diff_pct, .max_diff = max_diff, .avg_diff = avg };
    }

    fn compareTolerance(self: *GoldenManager, actual: []const u8, golden: []const u8) ComparisonResult {
        var diff_count: u32 = 0;
        var max_diff: u8 = 0;
        var total_diff: u64 = 0;

        for (actual, golden) |a, g| {
            const diff: u8 = if (a > g) a - g else g - a;
            if (diff > self.config.pixel_tolerance) diff_count += 1;
            max_diff = @max(max_diff, diff);
            total_diff += diff;
        }

        const pixel_count = actual.len / 4;
        const diff_pct = @as(f32, @floatFromInt(diff_count)) / @as(f32, @floatFromInt(pixel_count)) * 100.0;
        const avg = if (actual.len > 0) @as(f32, @floatFromInt(total_diff)) / @as(f32, @floatFromInt(actual.len)) else 0;

        return .{ .matches = diff_pct <= self.config.diff_threshold, .diff_percentage = diff_pct, .max_diff = max_diff, .avg_diff = avg };
    }
};

const GoldenImage = struct {
    width: u32,
    height: u32,
    data: []u8,
};

// Helper functions

pub fn assertGoldenMatch(
    allocator: std.mem.Allocator,
    test_name: []const u8,
    category: []const u8,
    actual: []const u8,
    width: u32,
    height: u32,
) framework.TestError!void {
    var manager = GoldenManager.init(allocator, .{});
    const result = manager.compare(test_name, category, actual, width, height) catch return error.GoldenMismatch;
    if (!result.matches) return error.GoldenMismatch;
}

pub fn updateGolden(
    allocator: std.mem.Allocator,
    test_name: []const u8,
    category: []const u8,
    data: []const u8,
    width: u32,
    height: u32,
) !void {
    var manager = GoldenManager.init(allocator, .{ .update_mode = true });
    _ = try manager.compare(test_name, category, data, width, height);
}

// Tests

test "exact comparison - identical images" {
    var manager = GoldenManager.init(std.testing.allocator, .{ .mode = .exact });
    const img = [_]u8{ 255, 0, 0, 255, 0, 255, 0, 255 };
    const result = manager.compareExact(&img, &img);
    try std.testing.expect(result.matches);
    try std.testing.expectEqual(@as(f32, 0), result.diff_percentage);
}

test "tolerance comparison - within threshold" {
    var manager = GoldenManager.init(std.testing.allocator, .{ .mode = .tolerance, .pixel_tolerance = 5, .diff_threshold = 10 });
    const img1 = [_]u8{ 100, 100, 100, 255 };
    const img2 = [_]u8{ 102, 98, 100, 255 };
    const result = manager.compareTolerance(&img1, &img2);
    try std.testing.expect(result.matches);
}

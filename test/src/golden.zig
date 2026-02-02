//! FORGE Conformance Test Suite - Golden Image Comparison
//!
//! Infrastructure for comparing rendered output against golden reference images.
//! Supports pixel-perfect and perceptual comparison modes.

const std = @import("std");
const framework = @import("framework.zig");

/// Image format for golden images.
pub const ImageFormat = enum {
    png,
    ppm,
    raw,
};

/// Comparison mode for golden image testing.
pub const ComparisonMode = enum {
    /// Exact pixel-by-pixel comparison.
    exact,
    /// Allow small per-pixel differences.
    tolerance,
    /// Perceptual comparison (ignores imperceptible differences).
    perceptual,
    /// Structural similarity index.
    ssim,
};

/// Result of a golden image comparison.
pub const ComparisonResult = struct {
    /// Whether the images match within tolerance.
    matches: bool,
    /// Percentage of pixels that differ (0.0 - 100.0).
    diff_percentage: f32,
    /// Maximum per-pixel difference found.
    max_diff: u8,
    /// Average per-pixel difference.
    avg_diff: f32,
    /// SSIM score if computed (-1 if not computed).
    ssim_score: f32,
    /// Path to generated diff image (if any).
    diff_image_path: ?[]const u8,
};

/// Configuration for golden image comparison.
pub const GoldenConfig = struct {
    /// Base directory for golden images.
    golden_dir: []const u8 = "golden",
    /// Directory for output diffs.
    diff_dir: []const u8 = "diffs",
    /// Comparison mode.
    mode: ComparisonMode = .tolerance,
    /// Per-pixel tolerance (0-255).
    pixel_tolerance: u8 = 2,
    /// Maximum percentage of differing pixels allowed.
    diff_threshold: f32 = 0.1,
    /// Whether to generate diff images on mismatch.
    generate_diffs: bool = true,
    /// Whether to update golden images instead of comparing.
    update_mode: bool = false,
};

/// Golden image manager for a test suite.
pub const GoldenManager = struct {
    allocator: std.mem.Allocator,
    config: GoldenConfig,

    pub fn init(allocator: std.mem.Allocator, config: GoldenConfig) GoldenManager {
        return .{
            .allocator = allocator,
            .config = config,
        };
    }

    /// Compare a rendered image against its golden reference.
    ///
    /// Args:
    ///   test_name: The test identifier (e.g., "SCN-001_create_scene")
    ///   category: The test category (e.g., "scene")
    ///   actual: The rendered image data
    ///   width: Image width
    ///   height: Image height
    ///
    /// Returns comparison result or error.
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

        // In update mode, save the actual as the new golden
        if (self.config.update_mode) {
            try self.saveGolden(golden_path, actual, width, height);
            return .{
                .matches = true,
                .diff_percentage = 0,
                .max_diff = 0,
                .avg_diff = 0,
                .ssim_score = 1.0,
                .diff_image_path = null,
            };
        }

        // Load the golden image
        const golden = self.loadGolden(golden_path) catch |err| {
            if (err == error.FileNotFound) {
                // No golden exists yet - this is a new test
                return .{
                    .matches = false,
                    .diff_percentage = 100,
                    .max_diff = 255,
                    .avg_diff = 255,
                    .ssim_score = -1,
                    .diff_image_path = null,
                };
            }
            return err;
        };
        defer self.allocator.free(golden.data);

        // Verify dimensions match
        if (golden.width != width or golden.height != height) {
            return .{
                .matches = false,
                .diff_percentage = 100,
                .max_diff = 255,
                .avg_diff = 255,
                .ssim_score = -1,
                .diff_image_path = null,
            };
        }

        // Perform comparison based on mode
        return switch (self.config.mode) {
            .exact => self.compareExact(actual, golden.data),
            .tolerance => self.compareTolerance(actual, golden.data),
            .perceptual => self.comparePerceptual(actual, golden.data),
            .ssim => self.compareSSIM(actual, golden.data, width, height),
        };
    }

    /// Generate the path for a golden image.
    fn getGoldenPath(self: *GoldenManager, category: []const u8, test_name: []const u8) ![]u8 {
        return std.fmt.allocPrint(
            self.allocator,
            "{s}/{s}/{s}.png",
            .{ self.config.golden_dir, category, test_name },
        );
    }

    /// Load a golden image from disk.
    fn loadGolden(self: *GoldenManager, path: []const u8) !GoldenImage {
        _ = self;
        _ = path;
        // TODO: Implement PNG loading
        return error.FileNotFound;
    }

    /// Save an image as a golden reference.
    fn saveGolden(self: *GoldenManager, path: []const u8, data: []const u8, width: u32, height: u32) !void {
        _ = self;
        _ = path;
        _ = data;
        _ = width;
        _ = height;
        // TODO: Implement PNG saving
    }

    /// Exact pixel-by-pixel comparison.
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

        const pixel_count = actual.len / 4; // Assuming RGBA
        const diff_percentage = @as(f32, @floatFromInt(diff_count)) / @as(f32, @floatFromInt(pixel_count)) * 100.0;
        const avg_diff = if (actual.len > 0)
            @as(f32, @floatFromInt(total_diff)) / @as(f32, @floatFromInt(actual.len))
        else
            0;

        return .{
            .matches = diff_count == 0,
            .diff_percentage = diff_percentage,
            .max_diff = max_diff,
            .avg_diff = avg_diff,
            .ssim_score = -1,
            .diff_image_path = null,
        };
    }

    /// Comparison with per-pixel tolerance.
    fn compareTolerance(self: *GoldenManager, actual: []const u8, golden: []const u8) ComparisonResult {
        var diff_count: u32 = 0;
        var max_diff: u8 = 0;
        var total_diff: u64 = 0;

        for (actual, golden) |a, g| {
            const diff: u8 = if (a > g) a - g else g - a;
            if (diff > self.config.pixel_tolerance) {
                diff_count += 1;
            }
            max_diff = @max(max_diff, diff);
            total_diff += diff;
        }

        const pixel_count = actual.len / 4;
        const diff_percentage = @as(f32, @floatFromInt(diff_count)) / @as(f32, @floatFromInt(pixel_count)) * 100.0;
        const avg_diff = if (actual.len > 0)
            @as(f32, @floatFromInt(total_diff)) / @as(f32, @floatFromInt(actual.len))
        else
            0;

        return .{
            .matches = diff_percentage <= self.config.diff_threshold,
            .diff_percentage = diff_percentage,
            .max_diff = max_diff,
            .avg_diff = avg_diff,
            .ssim_score = -1,
            .diff_image_path = null,
        };
    }

    /// Perceptual comparison (placeholder).
    fn comparePerceptual(self: *GoldenManager, actual: []const u8, golden: []const u8) ComparisonResult {
        // TODO: Implement perceptual comparison (e.g., using LAB color space)
        return self.compareTolerance(actual, golden);
    }

    /// SSIM-based comparison (placeholder).
    fn compareSSIM(self: *GoldenManager, actual: []const u8, golden: []const u8, width: u32, height: u32) ComparisonResult {
        _ = width;
        _ = height;
        // TODO: Implement SSIM calculation
        return self.compareTolerance(actual, golden);
    }

    /// Generate a diff image highlighting differences.
    pub fn generateDiffImage(
        self: *GoldenManager,
        test_name: []const u8,
        category: []const u8,
        actual: []const u8,
        golden: []const u8,
        width: u32,
        height: u32,
    ) ![]u8 {
        _ = self;
        _ = test_name;
        _ = category;
        _ = actual;
        _ = golden;
        _ = width;
        _ = height;
        // TODO: Implement diff image generation
        return error.NotImplemented;
    }
};

/// Loaded golden image data.
const GoldenImage = struct {
    width: u32,
    height: u32,
    channels: u8,
    data: []u8,
};

// =============================================================================
// Helper Functions
// =============================================================================

/// Assert that a rendered image matches its golden reference.
pub fn assertGoldenMatch(
    allocator: std.mem.Allocator,
    test_name: []const u8,
    category: []const u8,
    actual: []const u8,
    width: u32,
    height: u32,
) framework.TestError!void {
    var manager = GoldenManager.init(allocator, .{});
    const result = manager.compare(test_name, category, actual, width, height) catch {
        return error.GoldenMismatch;
    };

    if (!result.matches) {
        return error.GoldenMismatch;
    }
}

/// Update a golden reference image.
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

// =============================================================================
// Tests
// =============================================================================

test "exact comparison - identical images" {
    const allocator = std.testing.allocator;
    var manager = GoldenManager.init(allocator, .{ .mode = .exact });

    const img = [_]u8{ 255, 0, 0, 255, 0, 255, 0, 255 };
    const result = manager.compareExact(&img, &img);

    try std.testing.expect(result.matches);
    try std.testing.expectEqual(@as(f32, 0), result.diff_percentage);
}

test "tolerance comparison - within threshold" {
    const allocator = std.testing.allocator;
    var manager = GoldenManager.init(allocator, .{
        .mode = .tolerance,
        .pixel_tolerance = 5,
        .diff_threshold = 10,
    });

    const img1 = [_]u8{ 100, 100, 100, 255 };
    const img2 = [_]u8{ 102, 98, 100, 255 };
    const result = manager.compareTolerance(&img1, &img2);

    try std.testing.expect(result.matches);
}

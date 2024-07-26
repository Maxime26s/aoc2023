const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn();
    const stdout = std.io.getStdOut();
    var buffered_reader = std.io.bufferedReader(stdin.reader());
    var buffer: [1024]u8 = undefined;

    while (try buffered_reader.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        stdout.writer().print("{s}\n", .{line}) catch |err| {
            std.debug.print("Error: {s}", .{@errorName(err)});
        };
    }
}

pub fn main1() !void {
    const lines = readStdin() catch {
        std.debug.print("failed", .{});
        return;
    };
    defer lines.deinit();

    var sum: u32 = 0;
    for (lines.items) |line| {
        sum += parseLine(line);
    }

    std.debug.print("Value: {}\n", .{sum});
    return;
}

pub fn parseLine(input: []const u8) u32 {
    if (input.len <= 1) std.debug.print("wtf", .{});
    var first_digit: u8 = undefined;
    for (input) |ch| {
        if (isDigit(ch)) {
            first_digit = ch - 48;
            break;
        }
    }

    var second_digit: u8 = undefined;
    var i: usize = input.len - 1;
    while (i >= 0) : (i -= 1) {
        const ch = input[i];
        if (isDigit(ch)) {
            second_digit = ch - '0';
            break;
        }
    }

    return first_digit * 10 + second_digit;
}

pub fn isDigit(ch: u8) bool {
    return ch >= '0' and ch <= '9';
}

pub fn readStdin() !std.ArrayList([]const u8) {
    const allocator = std.heap.page_allocator;
    const stdin = std.io.getStdIn().reader();

    var buffer = try allocator.alloc(u8, 1024);
    defer allocator.free(buffer);

    const file_size = stdin.readAll(buffer) catch return error.ReadFileError;
    const contents = buffer[0..file_size];

    var lines = std.ArrayList([]const u8).init(allocator);
    var tokenizer = std.mem.tokenize(u8, contents, "\n");

    while (tokenizer.next()) |line| {
        std.debug.print("{s}", .{line});
        try lines.append(line);
    }

    for (lines.items) |line| {
        std.debug.print("{s}", .{line});
    }
    std.debug.print("test {}", .{lines.items.len});

    return lines;
}

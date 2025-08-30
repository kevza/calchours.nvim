local M = {}

function M.calculate_time(line)
  -- Pattern to match: ## YYYY-MM-DD (HH:MM - HH:MM)
    local pattern = "^## +(%d%d%d%d%-%d%d%-%d%d) +%((%d%d:%d%d) *%- *(%d%d:%d%d)%)$"
    local year, start_time, end_time = line:match(pattern)

    -- Return nil if the line doesn't match the pattern
    if not year or not start_time or not end_time then
        return 0
    end

    -- Extract hours and minutes from start and end times
    local start_hour, start_min = start_time:match("(%d%d):(%d%d)")
    local end_hour, end_min = end_time:match("(%d%d):(%d%d)")

    -- Convert to numbers
    start_hour = tonumber(start_hour)
    start_min = tonumber(start_min)
    end_hour = tonumber(end_hour)
    end_min = tonumber(end_min)

    -- Convert times to minutes for easier calculation
    local start_total_min = start_hour * 60 + start_min
    local end_total_min = end_hour * 60 + end_min

    -- Calculate difference in minutes
    local diff_min = end_total_min - start_total_min

    -- Handle cases where end time is on the next day (e.g., 23:00 - 01:00)
    if diff_min < 0 then
        diff_min = diff_min + 24 * 60  -- Add 24 hours in minutes
    end

    -- Convert to hours (as a decimal)
    return diff_min / 60
end

return M


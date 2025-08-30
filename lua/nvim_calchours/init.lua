local M = {}
local calc_utils = require("nvim_calchours.utils");

function M.calculate_hours()
  -- Get the current buffer
  local buf = vim.api.nvim_get_current_buf()

  -- Get the start and end line numbers of the visual selection
  local start_line = vim.api.nvim_buf_get_mark(0, "<")[1] - 1  -- 0-based index
  local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]        -- 0-based index

  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line + 1, false)

  -- Modify each line (example: uppercase the line)
  local total_duration = 0
  for i, line in ipairs(lines) do
      local duration = calc_utils.calculate_time(line)
      total_duration = total_duration + duration
      if duration > 0 then
        lines[i] = string.format("%s %.2f hours", line, duration)
      end
  end
  table.insert(lines, "")
  table.insert(lines, string.format("#### Billed for <MONTH> : %0.2f hours", total_duration))

  -- Update the selected lines in the buffer
  vim.api.nvim_buf_set_lines(buf, start_line, end_line + 1, false, lines)
end

-- Map a command to the function
vim.api.nvim_create_user_command('CalcHours', M.calculate_hours, { range = true })
return M

function current_markdown_header()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  for lnum = row, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
    if line and line:match("^#+%s+") then
      return line:gsub("^#+%s*", "")
    end
  end

  return nil
end

-- Replace <++> sequentially with lines from visual selection
function replace_mark_visual()
  local bufnr = 0

  -- Get the start and end of the visual selection
  local start_pos = vim.fn.getpos("'<")[2] -- line number of '<
  local end_pos   = vim.fn.getpos("'>")[2] -- line number of '>

  -- Get lines from visual selection
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos - 1, end_pos, false)
  local i = 1

  -- Iterate through all buffer lines
  for lnum = 0, vim.api.nvim_buf_line_count(bufnr) - 1 do
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]

    -- Replace <++> sequentially with lines from selection
    local new_line, count = line:gsub("<%+%+>", function()
      if i <= #lines then
        local val = lines[i]
        i = i + 1
        return val
      else
        return "<++>"  -- leave marker if no more lines
      end
    end)

    if count > 0 then
      vim.api.nvim_buf_set_lines(bufnr, lnum, lnum + 1, false, {new_line})
    end
  end
end

-- Create a command for visual selection
vim.api.nvim_create_user_command('Replacemark', function()
  replace_mark_visual()
end, { range = true })

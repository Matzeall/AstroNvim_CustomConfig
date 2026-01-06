--# selene: allow(parse_error)
local M = {}

-- default repo: nvim config dir
local function default_repo() return vim.fn.stdpath "config" end

-- parse git status porcelain=2 --branch lines
-- returns: ahead (number or nil), behind (number or nil), has_upstream (bool), has_local_changes (bool)
local function parse_porcelain_branch(lines)
  local ahead, behind
  local has_upstream = false
  local has_local_changes = false

  for _, line in ipairs(lines) do
    if not line then goto continue end
    line = vim.trim(line)
    if line == "" then goto continue end

    -- porcelain v2 branch info: "# branch.ab +<ahead> -<behind>"
    local a, b = line:match "^#%s+branch%.ab%s+%+(%d+)%s+%-(%d+)"
    if a and b then
      ahead = tonumber(a)
      behind = tonumber(b)
    end

    -- detect upstream explicit presence
    if line:match "^#%s+branch%.upstream%s+" then has_upstream = true end

    -- any non-comment (not starting with "#") porcelain entry means some local change/untracked/etc.
    if not line:match "^#" then has_local_changes = true end

    ::continue::
  end

  return ahead, behind, has_upstream, has_local_changes
end

-- run git fetch first, then run git status --porcelain=2 --branch
function M.check_repo(repo, opts)
  opts = opts or {}
  repo = repo or default_repo()
  local notify = vim.notify
  local min_behind = opts.min_behind or 1
  local min_ahead = opts.min_ahead or 1

  if vim.fn.isdirectory(repo .. "/.git") == 0 then return end

  -- start fetch (argv-style, cross-platform safe)
  local fetch_cmd = { "git", "-C", repo, "fetch", "--quiet" }

  vim.fn.jobstart(fetch_cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function() end, -- ignore
    on_stderr = function(_, _) end, -- ignore or log
    on_exit = function(_, exit_code)
      -- schedule follow-up so we run in main loop safely
      vim.schedule(function()
        if exit_code ~= 0 then
          -- fetch failed (offline, auth, etc.) — optionally notify or continue anyway
          notify(("git fetch failed for %s (exit=%d); using local refs"):format(repo, exit_code), vim.log.levels.WARN)
        end

        -- now run git status
        local status_cmd = { "git", "-C", repo, "status", "--porcelain=2", "--branch" }
        vim.fn.jobstart(status_cmd, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_stdout = function(_, data)
            if not data or #data == 0 then return end

            -- parse git status information
            local ahead, behind, has_upstream, local_changes = parse_porcelain_branch(data)

            vim.schedule(function()
              if not opts.callback then
                if local_changes then
                  notify(("Config has local modifications\n%s"):format(repo), vim.log.levels.INFO)
                end
                if behind and behind >= min_behind then
                  notify(("Config is behind upstream by %d commit(s)."):format(behind), vim.log.levels.WARN)
                elseif ahead and ahead >= min_ahead then
                  notify(("Config is ahead of upstream by %d commit(s)."):format(ahead), vim.log.levels.INFO)
                end
              else
                pcall(
                  opts.callback,
                  { ahead = ahead, behind = behind, upstream = has_upstream, local_changes = local_changes, raw = data }
                )
              end
            end)
          end,
          on_stderr = function(_, err_lines)
            if not err_lines or #err_lines == 0 or (#err_lines == 1 and err_lines[1] == "") then return end
            vim.notify(("Config check -> git status error:\n%s"):format(vim.inspect(err_lines)), vim.log.levels.ERROR)
          end,
          on_exit = function() end,
        })
      end)
    end,
  })
end

-- schedule default config check on startup
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.schedule(function() M.check_repo() end)
  end,
})

return M

local M = {}
local config = require("tnew.config")

local function get_note_path(ext)
    vim.fn.mkdir(config.options.dir, "p")

    ext = ext and ext:match("^%w+$") or config.options.default_ext
    local filename = os.date(config.options.filename) .. "." .. ext
    return config.options.dir .. "/" .. filename
end

function M.new_temp_buffer(opts)
    local ext = opts.args ~= "" and opts.args or config.options.default_ext
    local file = get_note_path(ext)
    vim.cmd("enew")
    vim.cmd("file " .. file)
end

function M.clean_temp_files()
    if vim.fn.isdirectory(config.options.dir) == 0 then
        vim.notify("Tnew: No temp directory found", vim.log.levels.INFO)
        return
    end

    local files = vim.fn.globpath(config.options.dir, "*", false, true)
    if #files == 0 then
        vim.notify("Tnew: No temp files to clean", vim.log.levels.INFO)
        return
    end

    table.sort(files)
    local count = 0
    local use_trash = config.options.delete_to_trash

    if use_trash then
        local trash_cmd = nil
        local candidates = { "trash", "gio trash", "kioclient5 move" }

        for _, candidate in ipairs(candidates) do
            local exe = vim.split(candidate, " ")[1]
            if vim.fn.executable(exe) == 1 then
                trash_cmd = candidate
                break
            end
        end

        if not trash_cmd then
            vim.notify("Tnew: No trash utility found", vim.log.levels.WARN)
            return
        end

        for _, file in ipairs(files) do
            local cmd = string.format(
                "%s %s", trash_cmd, vim.fn.shellescape(file)
            )
            if os.execute(cmd) == 0 then
                count = count + 1
            end
        end
    else
        for _, file in ipairs(files) do
            if os.remove(file) then
                count = count + 1
            end
        end
    end

    vim.notify(
        string.format("Tnew: Deleted %d temp file(s)", count),
        vim.log.levels.INFO
    )
end

function M.register()
    vim.api.nvim_create_user_command("Tnew", M.new_temp_buffer, { nargs = "?" })
    vim.api.nvim_create_user_command("TnewClean", M.clean_temp_files, {})
end

return M

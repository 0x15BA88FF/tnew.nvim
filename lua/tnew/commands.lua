local M = {}
local config = require("tnew.config")

local function ensure_dir()
    vim.fn.mkdir(config.options.dir, "p")
end

local function get_note_path(ext)
    ensure_dir()
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

function M.list_temp_files()
    ensure_dir()
    local files = vim.fn.globpath(config.options.dir, "*", false, true)
    table.sort(files)
    return files
end

function M.clean_temp_files()
    local files = M.list_temp_files()
    local count = 0

    local use_trash = config.options.delete_to_trash
    local trash_cmd = nil

    if use_trash then
        local candidates = { "trash", "gio trash", "kioclient5 move" }

        for _, candidate in ipairs(candidates) do
            local exe = vim.split(candidate, " ")[1]
            if vim.fn.executable(exe) == 1 then
                trash_cmd = candidate
                break
            end
        end

        if not trash_cmd then
            vim.notify("Tnew: No trash utility found")
            return
        end
    end

    for _, file in ipairs(files) do
        local success = false

        if use_trash and trash_cmd then
            local cmd = string.format(
                "%s %s",
                trash_cmd,
                vim.fn.shellescape(file)
            )
            success = os.execute(cmd) == 0
        elseif not use_trash then
            success = os.remove(file) ~= nil
        end

        if success then
            count = count + 1
        end
    end

    vim.notify(
        string.format("Tnew: Deleted %d temp file(s).", count),
        vim.log.levels.INFO
    )
end

function M.register()
    vim.api.nvim_create_user_command(
        "Tnew",
        M.new_temp_buffer, { nargs = "?" }
    )

    vim.api.nvim_create_user_command(
        "TnewList",
        function()
            for _, f in ipairs(M.list_temp_files()) do
                print(f)
            end
        end, {}
    )

    vim.api.nvim_create_user_command(
        "TnewClean",
        M.clean_temp_files, {}
    )
end

return M

local config = require("tnew.config")
local commands = require("tnew.commands")

local M = {}

function M.setup(user_config)
    config.set(user_config or {})
    commands.register()
end

return M

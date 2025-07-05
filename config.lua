local M = {}

M.options = {
    dir = vim.fn.stdpath("cache") .. "/tnew",
    filename = "%Y%m%d-%H%M%S",
    default_ext = "md",
    delete_to_trash = false,
}

function M.set(user_opts)
    M.options = vim.tbl_deep_extend("force", M.options, user_opts or {})
end

return M

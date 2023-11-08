local M = {}

M.set_opacity = function(opacity)
    if opacity < 0 or opacity > 100 then
        print("Opacity should be between 0 and 100")
        return
    end
    local command = string.format("echo -e '\\033]11;[100;%d]\\007'", opacity)
    vim.cmd('silent! !' .. command)
end

return M


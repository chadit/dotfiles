local Utils = {}

local has_notify, notify = pcall(require, "notify")

--  vim.inspect(table)
Utils.use = function(conf)
    local new_conf = {}
    if type(conf) == "string" then
        new_conf[1] = conf
    else
        new_conf = conf
    end
    new_conf.run = function(plugin)
        if has_notify then
            notify(table.concat(plugin.messages, "\n"), "info",
                   {title = plugin.short_name, timeout = 2000})
        end
    end
    local pkr_use = require("packer").use
    return pkr_use(new_conf)
end

return Utils

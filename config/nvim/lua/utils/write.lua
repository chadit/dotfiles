local show = vim.schedule_wrap(function(msg)
  local has_notify, notify = pcall(require, "plugins.notify")
  if has_notify then
    notify.notify_info(msg, "ensure-tools")
  end
end)

local function serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0
  local tmp = string.rep(" ", depth)

  if name then
    if type(name) == "number" then
      tmp = tmp .. "[" .. name .. "] = "
    else
      tmp = tmp .. name .. " = "
    end
  end

  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")
    for k, v in pairs(val) do
      tmp = tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end
    tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  elseif type(val) == "function" then
    tmp = tmp .. "[Function Placeholder]," .. (not skipnewlines and "\n" or "")
  else
    error("Cannot serialize a " .. type(val))
  end

  return tmp
end

local M = {}

function M.WriteFile(path, data)
  show("data type:" .. type(data) .. " path: " .. path)

  local was_successful, msg = pcall(function()
    local file = io.open(path, "w")
    if file == nil then
      print("Error: Could not open file: " .. path)
      return
    end
    -- show("data: " .. tostring(serializeTable(data)))
    file:write(serializeTable(data))
    --file:write(data)
    file:close()
  end)

  show("was successful: " .. tostring(was_successful) .. " msg: " .. tostring(msg) .. " path: " .. path)
end

return M

local M = {}

function M.TableToString(tbl, indent)
  if not indent then indent = 0 end
  if type(tbl) ~= 'table' then return tostring(tbl) end

  local format = string.rep('  ', indent) .. '{\n'
  indent = indent + 1

  for k, v in pairs(tbl) do
    local key
    if type(k) == 'string' then
      key = string.format("[%s] = ", tostring(k))
    else
      key = string.format("[%d] = ", k)
    end

    if type(v) == 'table' then
      format = format .. string.rep('  ', indent) .. key .. M.TableToString(v, indent) .. ',\n'
    else
      format = format .. string.rep('  ', indent) .. key .. tostring(v) .. ',\n'
    end
  end

  return format .. string.rep('  ', indent - 1) .. '}'
end

return M

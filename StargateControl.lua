local component = require("component")
local fs = require("filesystem")

for _, name in ipairs({"gpu", "stargate"}) do
  if not component.isAvailable(name) then
    io.stderr:write("Missing component: " .. name .. "\n")
    return
  end
end

-- OpenOS sets "_" to the absolute path of the running program.
local directory = fs.path(os.getenv("_") or "StargateControl.lua")
local originalPath = package.path
package.path = fs.concat(directory, "?.lua") .. ";" .. originalPath

local ok, reason = pcall(function()
  require("src/app").run()
end)
package.path = originalPath

if not ok then
  io.stderr:write("Stargate Control: " .. tostring(reason) .. "\n")
end

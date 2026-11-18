local component = require("component")
local event = require("event")
local term = require("term")
local palette = require("src/palette")
local graphics = require("src/graphics")
local Button = require("src/Button")
local AddressField = require("src/AddressField")

local app = {}

local function discoverGates(previous)
  local gates, byId = {}, {}
  for id in component.list("stargate", true) do
    local entry = previous[id]
    if not entry then
      local ok, proxy = pcall(component.proxy, id)
      if ok and proxy then
        entry = {id = id, proxy = proxy, chevrons = {}, address = "",
          autoClose = false, closedForIncoming = false}
      end
    end
    if entry then
      gates[#gates + 1] = entry
      byId[id] = entry
    end
  end
  table.sort(gates, function(a, b) return a.id < b.id end)
  return gates, byId
end

local function read(method, ...)
  if not method then return nil end
  local ok, result, second, third = pcall(method, ...)
  if ok then return result, second, third end
end

local function command(entry, method, ...)
  local ok, result, reason = pcall(entry.proxy[method], ...)
  if not ok then
    entry.error = tostring(result)
  elseif not result then
    entry.error = reason or "КОМАНДА НЕ ВЫПОЛНЕНА"
  else
    entry.error = nil
  end
end

local function updateGate(entry)
  local gate = entry.proxy
  local state, engaged, direction = read(gate.stargateState)
  entry.engaged = type(engaged) == "number" and math.max(0, math.min(9, math.floor(engaged))) or 0
  entry.state, entry.direction = state or "Offline", direction
  entry.iris = read(gate.irisState)
  entry.localAddress = AddressField.normalize(read(gate.localAddress))
  entry.remoteAddress = AddressField.normalize(read(gate.remoteAddress))

  if entry.state == "Idle" or entry.state == "Offline" then
    entry.chevrons = {}
  end

  local incoming = direction == "Incoming"
    and (state == "Dialling" or state == "Opening" or state == "Connected")
  if not incoming then
    entry.closedForIncoming = false
  elseif entry.autoClose and not entry.closedForIncoming then
    if entry.iris == "Open" then
      command(entry, "closeIris")
      entry.iris = read(gate.irisState)
      entry.closedForIncoming = true
    elseif entry.iris == "Closed" then
      entry.closedForIncoming = true
    end
  end
end

local function sameAddress(a, b)
  -- SGCraft reports both seven-symbol local and nine-symbol interdimensional addresses.
  if not AddressField.valid(a) or not AddressField.valid(b) then return false end
  if #a == #b then return a == b end
  return (#a == 7 or #b == 7) and a:sub(1, 7) == b:sub(1, 7)
end

local function routeStatus(source, target)
  if not source then return "НЕТ ИНТЕРФЕЙСА ВРАТ" end
  if not target then return "ПОДКЛЮЧИТЕ ВТОРЫЕ ВРАТА" end
  if sameAddress(source.localAddress, target.localAddress) then
    return "АДРЕСА ВРАТ СОВПАДАЮТ"
  end
  if source.state == "Connected" and target.state == "Connected"
      and source.direction == "Outgoing" and target.direction == "Incoming"
      and sameAddress(source.remoteAddress, target.localAddress)
      and sameAddress(target.remoteAddress, source.localAddress) then
    if (source.iris == "Open" or source.iris == "Offline")
        and (target.iris == "Open" or target.iris == "Offline") then
      return "ГОТОВО: ВОЙДИТЕ ВО ВРАТА", true
    end
    return "ПРОВЕРЬТЕ ОБЕ ДИАФРАГМЫ"
  end
  return "ЦЕЛЬ: " .. graphics.stateLabel(target.state) .. " / " .. graphics.irisLabel(target.iris)
end

local function controlGate(gpu)
  graphics.draw()

  local width = gpu.getResolution()
  local screen = gpu.getScreen()
  local exit = Button.new(width - 9, 1, 7, 3, "X", palette.RED_DARK, palette.TEXT_WHITE)
  local iris = Button.new(4, 17, 16, 3, "ДИАФРАГМА", palette.CYAN, palette.TEXT_WHITE)
  local autoclose = Button.new(22, 17, 16, 3, "АВТОЗАКР.: ВЫКЛ", palette.CYAN, palette.TEXT_WHITE)
  local dial = Button.new(4, 13, 16, 3, "НАБРАТЬ", palette.CYAN, palette.TEXT_WHITE)
  local terminate = Button.new(22, 13, 16, 3, "РАЗЪЕДИНИТЬ", palette.RED_DARK, palette.TEXT_WHITE)
  local address = AddressField.new(4, 9, 34, 3, palette.BORDER, palette.TEXT_WHITE, palette.INSET)
  local selectGate = Button.new(124, 14, 25, 3, "ИСТОЧНИК", palette.CYAN, palette.TEXT_WHITE)
  local linkGate = Button.new(124, 18, 25, 3, "СОЕДИНИТЬ ВРАТА", palette.BLUE, palette.TEXT_WHITE)
  exit:update("X", palette.RED_DARK, false)
  address:draw()

  local gates, byId = discoverGates({})
  local selected = 1
  local shownGate, shownState, shownDirection, shownInterior, shownEngaged
  local shownRemote, shownLocal, shownRoute
  local shownChevrons = {}

  while true do
    local entry = gates[selected]
    local target = #gates > 1 and gates[selected % #gates + 1] or nil
    for _, item in ipairs(gates) do updateGate(item) end

    local state = entry and entry.state or "Offline"
    local direction = entry and entry.direction
    local irisState = entry and entry.iris
    local engaged = entry and entry.engaged or 0
    if state ~= shownState then graphics.drawStateMsg(state) end
    if entry ~= shownGate or state ~= shownState or direction ~= shownDirection
        or engaged ~= shownEngaged then
      graphics.drawStateDetail(state, direction, engaged)
      shownGate, shownState, shownDirection, shownEngaged = entry, state, direction, engaged
    end

    for number = 1, 9 do
      local symbol = entry and entry.chevrons[number]
      if not symbol and state ~= "Idle" and state ~= "Offline" and number <= engaged then
        symbol = "+"
      end
      if symbol ~= shownChevrons[number] then
        graphics.drawChevron(number, symbol or " ", symbol ~= nil)
        shownChevrons[number] = symbol
      end
    end

    local interior = graphics.emptyGate
    if irisState == "Closed" then
      interior = graphics.drawIris
    elseif state == "Connected" then
      interior = graphics.drawWormhole
    end
    if interior ~= shownInterior then
      interior()
      shownInterior = interior
    end

    local irisLabel = ({
      Closed = "ОТКР. ДИАФРАГМУ", Open = "ЗАКР. ДИАФРАГМУ", Offline = "НЕТ ДИАФРАГМЫ"
    })[irisState] or "ДИАФРАГМА ЗАНЯТА"
    iris:update(irisLabel, palette.CYAN, irisState ~= "Open" and irisState ~= "Closed")
    local autoClose = entry and entry.autoClose
    autoclose:update(autoClose and "АВТОЗАКР.: ВКЛ" or "АВТОЗАКР.: ВЫКЛ",
      autoClose and palette.CYAN_LIGHT or palette.CYAN, not irisState or irisState == "Offline")
    dial:update("НАБРАТЬ", palette.BLUE, state ~= "Idle" or not address:isValid() or address.draft ~= nil)
    terminate:update("РАЗЪЕДИНИТЬ", palette.RED_DARK,
      not (state == "Dialling" or state == "Connected" or state == "Opening") or direction == "Incoming")

    selectGate:update(string.format("ИСТОЧНИК %d/%d", entry and selected or 0, #gates),
      palette.CYAN, #gates < 2)
    local routePossible = target and target.state == "Idle"
      and AddressField.valid(target.localAddress)
      and not sameAddress(entry.localAddress, target.localAddress)
    linkGate:update("СОЕДИНИТЬ ВРАТА", palette.BLUE, not routePossible or state ~= "Idle")
    local route, ready = routeStatus(entry, target)
    local sourceAddress = entry and entry.localAddress ~= "" and entry.localAddress or "—"
    local targetAddress = target and target.localAddress ~= "" and target.localAddress or "—"
    local routeKey = table.concat({sourceAddress, targetAddress, route, tostring(ready)}, "|")
    if shownRoute ~= routeKey then
      graphics.drawRoute(sourceAddress, targetAddress, route, ready)
      shownRoute = routeKey
    end

    local remote = direction and direction ~= "" and entry.remoteAddress ~= ""
      and entry.remoteAddress or address.address
    local cost = entry and state == "Idle" and address:isValid()
      and read(entry.proxy.energyToDial, address.address) or nil
    local remoteKey = remote .. "|" .. tostring(cost)
    if shownRemote ~= remoteKey then
      graphics.drawRemoteInfo(remote, cost)
      shownRemote = remoteKey
    end
    local localAddress = entry and entry.localAddress
    local energy = entry and read(entry.proxy.energyAvailable)
    local lastError = entry and entry.error
    local localKey = table.concat({tostring(localAddress), tostring(energy), tostring(irisState),
      tostring(lastError)}, "|")
    if shownLocal ~= localKey then
      graphics.drawLocalGateInfo(localAddress, energy, irisState, lastError)
      shownLocal = localKey
    end

    local signal, source, first, second = event.pull(1)
    if signal == "interrupted" then
      return
    elseif (signal == "component_added" or signal == "component_removed") and first == "stargate" then
      local previousId = entry and entry.id
      gates, byId = discoverGates(byId)
      selected = 1
      for index, item in ipairs(gates) do
        if item.id == previousId then selected = index break end
      end
      if gates[selected] ~= entry then
        address.draft = nil
        address.address = gates[selected] and gates[selected].address or ""
        address:draw()
      end
    elseif signal == "sgChevronEngaged" and byId[source]
        and type(first) == "number" and first % 1 == 0 and first >= 1 and first <= 9 then
      byId[source].chevrons[first] = tostring(second or " "):sub(1, 1)
    elseif signal == "key_down" and address.draft then
      address:keyDown(first, second)
      if entry then entry.address = address.address end
    elseif signal == "clipboard" and address.draft then
      address:insert(first)
    elseif signal == "touch" and source == screen then
      local x, y = first, second
      if exit:clicked(x, y) then
        return
      elseif selectGate:clicked(x, y) then
        selected = selected % #gates + 1
        address.draft = nil
        address.address = gates[selected].address
        address:draw()
      elseif entry then
        if linkGate:clicked(x, y) then
          address.draft = nil
          address.address = target.localAddress
          entry.address = address.address
          address:draw()
          command(entry, "dial", target.localAddress)
        elseif iris:clicked(x, y) then
          command(entry, irisState == "Closed" and "openIris" or "closeIris")
        elseif autoclose:clicked(x, y) then
          entry.autoClose = not entry.autoClose
          if entry.autoClose then entry.closedForIncoming = false end
        elseif terminate:clicked(x, y) then
          command(entry, "disconnect")
        elseif address:clicked(x, y) then
          address:startEditing()
        elseif dial:clicked(x, y) then
          command(entry, "dial", address.address)
        end
      end
    end
  end
end

function app.run()
  local gpu = component.gpu
  if not gpu.getScreen() then
    error("К видеокарте не подключён экран", 0)
  end

  local width, height = gpu.getResolution()
  local maxWidth, maxHeight = gpu.maxResolution()
  if maxWidth < 153 or maxHeight < 50 then
    error("Экран и видеокарта должны поддерживать разрешение от 153x50", 0)
  end

  local foreground, foregroundIsPalette = gpu.getForeground()
  local background, backgroundIsPalette = gpu.getBackground()
  local ok, reason = pcall(function()
    if width < 153 or height < 50 then
      assert(gpu.setResolution(maxWidth, maxHeight), "Не удалось изменить разрешение экрана")
    end
    controlGate(gpu)
  end)

  local currentWidth, currentHeight = gpu.getResolution()
  if currentWidth ~= width or currentHeight ~= height then
    gpu.setResolution(width, height)
  end
  gpu.setBackground(background, backgroundIsPalette)
  gpu.setForeground(foreground, foregroundIsPalette)
  term.clear()
  if not ok then error(reason, 0) end
end

return app

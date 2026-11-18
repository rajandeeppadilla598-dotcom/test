local unicode = require("unicode")
local palette = require("src/palette")
local gpu = require("component").gpu
local graphics = {}

local function fill(x, y, width, height, color)
  gpu.setBackground(color)
  gpu.fill(x, y, width, height, " ")
end

local function text(x, y, value, foreground, background)
  gpu.setBackground(background)
  gpu.setForeground(foreground)
  gpu.set(x, y, value)
end

local function centered(x, y, width, value, foreground, background)
  text(x + math.floor((width - unicode.len(value)) / 2), y, value, foreground, background)
end

local function panel(x, y, width, height, title)
  fill(x, y, width, height, palette.PANEL)
  fill(x, y, width, 1, palette.BORDER)
  text(x + 2, y + 1, title, palette.CYAN_LIGHT, palette.PANEL)
end

local centerX, centerY = 79, 23

local function ellipse(rx, ry, color)
  gpu.setBackground(color)
  for dy = -ry, ry do
    local dx = math.floor(rx * math.sqrt(1 - (dy / ry)^2))
    gpu.fill(centerX - dx, centerY + dy, 2 * dx + 1, 1, " ")
  end
end

local function drawRing()
  ellipse(31, 15, 0x213750)
  ellipse(30, 14, 0x376B88)
  ellipse(28, 13, 0x1A3550)
  ellipse(26, 12, 0x72BDCF)
  ellipse(23, 11, palette.INSET)
end

-- Positions follow the SGCraft seven-chevron sequence, with two extra lower slots.
local ringChevrons = {
  {98, 13}, {107, 23}, {98, 33}, {60, 33}, {51, 23},
  {60, 13}, {79, 9}, {89, 36}, {69, 36}
}

function graphics.drawChevron(number, symbol, active)
  local ring = ringChevrons[number]
  local x = 124 + (number - 1) % 3 * 9
  local y = 29 + math.floor((number - 1) / 3) * 5
  local color = active and palette.AMBER or palette.BORDER
  fill(ring[1] - 1, ring[2], 3, 1, color)
  fill(x, y, 7, 3, palette.INSET)
  text(x + 1, y, tostring(number), palette.GREY_LIGHT, palette.INSET)
  centered(x, y + 1, 7, active and symbol or "-", color, palette.INSET)
end

function graphics.draw()
  local width, height = gpu.getResolution()
  fill(1, 1, width, height, palette.BACKGROUND)
  fill(1, 1, width, 3, palette.PANEL)
  fill(1, 4, width, 1, palette.BORDER)
  text(4, 2, "УПРАВЛЕНИЕ ЗВЁЗДНЫМИ ВРАТАМИ", palette.TEXT_WHITE, palette.PANEL)

  panel(3, 6, 36, 15, "УПРАВЛЕНИЕ")
  panel(3, 23, 36, 9, "НАЗНАЧЕНИЕ")
  panel(3, 34, 36, 15, "ВЫБРАННЫЕ ВРАТА")
  panel(41, 6, 77, 43, "СОСТОЯНИЕ ПОРТАЛА")
  panel(121, 6, 31, 17, "МАРШРУТ")
  panel(121, 25, 31, 24, "ШЕВРОНЫ")

  drawRing()
  for number = 1, 9 do graphics.drawChevron(number, " ", false) end
end

function graphics.emptyGate()
  ellipse(23, 11, palette.INSET)
  fill(centerX - 3, centerY, 7, 1, 0x1E3650)
  fill(centerX, centerY - 1, 1, 3, 0x1E3650)
end

function graphics.drawIris()
  ellipse(23, 11, 0x314B68)
  ellipse(18, 9, 0x466480)
  ellipse(12, 6, 0x567591)
  ellipse(5, 3, 0x314B68)
  centered(66, centerY, 27, "ДИАФРАГМА ЗАКРЫТА", palette.TEXT_WHITE, 0x314B68)
end

function graphics.drawWormhole()
  ellipse(23, 11, 0x16446C)
  ellipse(20, 9, 0x205F91)
  ellipse(16, 7, 0x2683AA)
  ellipse(11, 5, 0x37A5BD)
  ellipse(6, 3, 0x72CAD2)
end

local states = {
  Offline = "НЕДОСТУПНЫ", Idle = "ОЖИДАНИЕ", Dialling = "НАБОР АДРЕСА",
  Opening = "ОТКРЫТИЕ", Connected = "СОЕДИНЕНО", Closing = "ЗАКРЫТИЕ"
}
local irises = {
  Offline = "НЕТ", Open = "ОТКРЫТА", Closed = "ЗАКРЫТА",
  Opening = "ОТКРЫВАЕТСЯ", Closing = "ЗАКРЫВАЕТСЯ"
}
local directions = {Incoming = "ВХОДЯЩЕЕ", Outgoing = "ИСХОДЯЩЕЕ"}

function graphics.stateLabel(state)
  return states[state] or "НЕИЗВЕСТНО"
end

function graphics.irisLabel(state)
  return irises[state] or "НЕИЗВЕСТНО"
end

function graphics.drawStateMsg(state, direction)
  local color = palette.CYAN_LIGHT
  if state == "Connected" then
    color = palette.GREEN
  elseif state == "Offline" then
    color = palette.RED_BRIGHT
  elseif state ~= "Idle" then
    color = palette.AMBER
  end
  fill(45, 40, 69, 1, palette.BORDER)
  fill(45, 41, 69, 6, palette.INSET)
  centered(45, 43, 69, graphics.stateLabel(state), color, palette.INSET)
  if directions[direction] then
    centered(45, 45, 69, directions[direction], palette.GREY_LIGHT, palette.INSET)
  end
end

local function wrap(value, width, lines)
  local result = {}
  while unicode.len(value) > width and #result < lines - 1 do
    local line = unicode.sub(value, 1, width + 1):match("^(.*) ")
    local length = line and line ~= "" and unicode.len(line) or width
    result[#result + 1] = unicode.sub(value, 1, length)
    value = unicode.sub(value, length + 1):gsub("^ +", "")
  end
  result[#result + 1] = unicode.sub(value, 1, width)
  return result
end

function graphics.drawRoute(label, status, ready)
  fill(123, 9, 27, 5, palette.PANEL)
  text(124, 9, unicode.sub(label, 1, 26), palette.TEXT_WHITE, palette.PANEL)
  for row, line in ipairs(wrap(status, 26, 2)) do
    text(124, 10 + row, line, ready and palette.GREEN or palette.GREY_LIGHT, palette.PANEL)
  end
end

local function readout(y, label, value)
  fill(5, y, 32, 1, palette.INSET)
  text(6, y, label, palette.GREY_LIGHT, palette.INSET)
  local shown = unicode.sub(tostring(value), 1, 18)
  text(36 - unicode.len(shown), y, shown, palette.TEXT_WHITE, palette.INSET)
end

local function energyValue(energy)
  return type(energy) == "number" and math.floor(energy + 0.5) or "—"
end

function graphics.drawRemoteInfo(address, energy)
  readout(27, "АДРЕС", address ~= "" and address or "-")
  readout(29, "ЦЕНА НАБОРА", energyValue(energy))
end

function graphics.drawLocalGateInfo(address, energy, iris, err)
  readout(38, "АДРЕС", address and address ~= "" and address or "-")
  readout(40, "ЭНЕРГИЯ", energyValue(energy))
  readout(42, "ДИАФРАГМА", graphics.irisLabel(iris))
  fill(5, 44, 32, 4, palette.PANEL)
  if err then
    for row, line in ipairs(wrap(tostring(err):gsub("%c", " "), 30, 3)) do
      text(6, 43 + row, line, palette.AMBER, palette.PANEL)
    end
  end
end

return graphics

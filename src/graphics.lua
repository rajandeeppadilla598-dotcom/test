local graphics = {}

local component = require("component")
local palette = require("src/palette")

local gpu = component.gpu

function graphics.draw()
  local w, h = gpu.getResolution()
  gpu.setBackground(palette.BACKGROUND)
  gpu.fill(1, 1, w, h, " ")
  graphics.drawBorders(w, h)
  gpu.setBackground(palette.CYAN)
  gpu.setForeground(palette.TEXT_WHITE)
  gpu.set(4, 1, "STARGATE CONTROL")
  gpu.setBackground(palette.BACKGROUND)
  gpu.setForeground(palette.CYAN_LIGHT)
  gpu.set(44, 2, "GATE STATUS")
  gpu.set(129, 6, "CHEVRONS")
  graphics.drawGate()
  graphics.drawGateControls()
  graphics.drawStatusWindow()
end

function graphics.drawBorders(w, h)
  gpu.setBackground(palette.CYAN)
  gpu.fill(1, 1, w, 1, " ")
  gpu.fill(1, 2, 1, h - 2, " ")
  gpu.fill(1, h, w, 1, " ")
  gpu.fill(w, 2, 1, h - 2, " ")
end

function graphics.drawGate()
  --outer ring
  gpu.setBackground(palette.CYAN_LIGHT)
  gpu.fill(74, 8, 14, 1, " ")
  gpu.fill(88, 9, 6, 1, " ")
  gpu.fill(94, 10, 4, 1, " ")
  gpu.fill(98, 11, 2, 1, " ")
  gpu.fill(100, 12, 2, 1, " ")
  gpu.fill(102, 13, 2, 1, " ")
  gpu.fill(104, 14, 2, 1, " ")
  gpu.fill(106, 15, 2, 2, " ")
  gpu.fill(108, 17, 2, 3, " ")
  
  gpu.fill(110, 20, 2, 7, " ")
  gpu.fill(108, 27, 2, 3, " ")
  gpu.fill(106, 30, 2, 2, " ")
  gpu.fill(104, 32, 2, 1, " ")
  gpu.fill(102, 33, 2, 1, " ")
  gpu.fill(100, 34, 2, 1, " ")
  gpu.fill(98, 35, 2, 1, " ")
  gpu.fill(94, 36, 4, 1, " ")
  gpu.fill(88, 37, 6, 1, " ")

  gpu.fill(74, 38, 14, 1, " ")
  gpu.fill(68, 37, 6, 1, " ")
  gpu.fill(64, 36, 4, 1, " ")
  gpu.fill(62, 35, 2, 1, " ")
  gpu.fill(60, 34, 2, 1, " ")
  gpu.fill(58, 33, 2, 1, " ")
  gpu.fill(56, 32, 2, 1, " ")
  gpu.fill(54, 30, 2, 2, " ")
  gpu.fill(52, 27, 2, 3, " ")

  gpu.fill(50, 20, 2, 7, " ")
  gpu.fill(52, 17, 2, 3, " ")
  gpu.fill(54, 15, 2, 2, " ")
  gpu.fill(56, 14, 2, 1, " ")
  gpu.fill(58, 13, 2, 1, " ")
  gpu.fill(60, 12, 2, 1, " ")
  gpu.fill(62, 11, 2, 1, " ")
  gpu.fill(64, 10, 4, 1, " ")
  gpu.fill(68, 9, 6, 1, " ")
  
  --inner ring
  gpu.fill(74, 11, 14, 1, " ")
  gpu.fill(88, 12, 4, 1, " ")
  gpu.fill(92, 13, 4, 1, " ")
  gpu.fill(96, 14, 2, 1, " ")
  gpu.fill(98, 15, 2, 1, " ")
  gpu.fill(100, 16, 2, 2, " ")
  gpu.fill(102, 18, 2, 2, " ")

  gpu.fill(104, 20, 2, 7, " ")
  gpu.fill(102, 27, 2, 2, " ")
  gpu.fill(100, 29, 2, 2, " ")
  gpu.fill(98, 31, 2, 1, " ")
  gpu.fill(96, 32, 2, 1, " ")
  gpu.fill(92, 33, 4, 1, " ")
  gpu.fill(88, 34, 4, 1, " ")

  gpu.fill(74, 35, 14, 1, " ")
  gpu.fill(70, 34, 4, 1, " ")
  gpu.fill(66, 33, 4, 1, " ")
  gpu.fill(64, 32, 2, 1, " ")
  gpu.fill(62, 31, 2, 1, " ")
  gpu.fill(60, 29, 2, 2, " ")
  gpu.fill(58, 27, 2, 2, " ")

  gpu.fill(56, 20, 2, 7, " ")
  gpu.fill(58, 18, 2, 2, " ")
  gpu.fill(60, 16, 2, 2, " ")
  gpu.fill(62, 15, 2, 1, " ")
  gpu.fill(64, 14, 2, 1, " ")
  gpu.fill(66, 13, 4, 1, " ")
  gpu.fill(70, 12, 4, 1, " ")
  
  --middle ring
  gpu.setBackground(palette.SLATE_LIGHT)
  gpu.fill(84, 9, 2, 2, " ")
  gpu.fill(88, 10, 2, 2, " ")
  gpu.fill(92, 11, 2, 2, " ")
  gpu.fill(96, 12, 2, 1, " ")
  gpu.fill(98, 14, 2, 1, " ")
  gpu.fill(102, 15, 2, 1, " ")
  gpu.fill(102, 17, 4, 1, " ")
  gpu.fill(104, 19, 4, 1, " ")
  gpu.fill(106, 21, 4, 1, " ")
  
  gpu.fill(106, 25, 4, 1, " ")
  gpu.fill(104, 27, 4, 1, " ")
  gpu.fill(102, 29, 4, 1, " ")
  gpu.fill(102, 31, 2, 1, " ")
  gpu.fill(98, 32, 2, 1, " ")
  gpu.fill(100, 33, 2, 1, " ")
  gpu.fill(96, 34, 2, 1, " ")
  gpu.fill(92, 34, 2, 2, " ")
  gpu.fill(88, 35, 2, 2, " ")
  gpu.fill(84, 36, 2, 2, " ")

  gpu.fill(80, 36, 2, 2, " ")
  gpu.fill(76, 36, 2, 2, " ")
  gpu.fill(72, 35, 2, 2, " ")
  gpu.fill(68, 34, 2, 2, " ")
  gpu.fill(64, 34, 2, 1, " ")
  gpu.fill(62, 32, 2, 1, " ")
  gpu.fill(60, 33, 2, 1, " ")
  gpu.fill(58, 31, 2, 1, " ")
  gpu.fill(56, 29, 4, 1, " ")
  gpu.fill(54, 27, 4, 1, " ")
  gpu.fill(52, 25, 4, 1, " ")

  gpu.fill(52, 21, 4, 1, " ")
  gpu.fill(54, 19, 4, 1, " ")
  gpu.fill(56, 17, 4, 1, " ")
  gpu.fill(58, 15, 2, 1, " ")
  gpu.fill(62, 14, 2, 1, " ")
  gpu.fill(64, 12, 2, 1, " ")
  gpu.fill(68, 11, 2, 2, " ")
  gpu.fill(72, 10, 2, 2, " ")
  gpu.fill(76, 9, 2, 2, " ")
  
  --chevrons
  gpu.setBackground(palette.RED_DARK)

  gpu.fill(78, 8, 6, 1, " ")
  gpu.fill(79, 9, 1, 1, " ")
  gpu.fill(82, 9, 1, 1, " ")
  gpu.fill(80, 10, 2, 1, " ")
  
  gpu.fill(100, 12, 2, 1, " ")
  gpu.fill(102, 13, 2, 1, " ")
  gpu.fill(98, 13, 2, 2, " ")
  gpu.fill(100, 14, 2, 1, " ")
  
  gpu.fill(106, 23, 2, 1, " ")
  gpu.fill(108, 22, 2, 1, " ")
  gpu.fill(108, 24, 2, 1, " ")
  gpu.fill(110, 22, 2, 3, " ")

  gpu.fill(102, 30, 4, 1, " ")
  gpu.fill(102, 31, 2, 1, " ")
  gpu.fill(106, 31, 2, 1, " ")
  gpu.fill(104, 32, 2, 1, " ")

  gpu.fill(90, 35, 2, 1, " ")
  gpu.fill(89, 36, 1, 1, " ")
  gpu.fill(92, 36, 1, 1, " ")
  gpu.fill(88, 37, 6, 1, " ")
  
  gpu.fill(70, 35, 2, 1, " ")
  gpu.fill(69, 36, 1, 1, " ")
  gpu.fill(72, 36, 1, 1, " ")
  gpu.fill(68, 37, 6, 1, " ")

  gpu.fill(56, 30, 4, 1, " ")
  gpu.fill(54, 31, 2, 1, " ")
  gpu.fill(58, 31, 2, 1, " ")
  gpu.fill(56, 32, 2, 1, " ")

  gpu.fill(50, 22, 4, 1, " ")
  gpu.fill(50, 23, 2, 1, " ")
  gpu.fill(54, 23, 2, 1, " ")
  gpu.fill(50, 24, 4, 1, " ")
  
  gpu.fill(60, 12, 2, 1, " ")
  gpu.fill(58, 13, 2, 1, " ")
  gpu.fill(62, 13, 2, 1, " ")
  gpu.fill(60, 14, 4, 1, " ")
end

function graphics.drawGateControls()
  --chevron lines
  gpu.setBackground(palette.SLATE_LIGHT)

  gpu.fill(102, 12, 18, 1, " ")
  gpu.fill(119, 11, 1, 1, " ")
  gpu.fill(119, 10, 17, 1, " ")

  gpu.fill(112, 23, 10, 1, " ")
  gpu.fill(121, 17, 1, 6, " ")
  gpu.fill(121, 16, 18, 1, " ")
  
  gpu.fill(106, 32, 17, 1, " ")
  gpu.fill(123, 23, 1, 10, " ")
  gpu.fill(123, 22, 19, 1, " ")
  
  gpu.fill(144, 46, 3, 1, " ")
  gpu.fill(146, 6, 1, 40, " ")
  gpu.fill(80, 6, 67, 1, " ")
  gpu.fill(80, 6, 2, 2, " ")
  
  gpu.fill(144, 40, 5, 1, " ")
  gpu.fill(148, 5, 1, 35, " ")
  gpu.fill(54, 5, 95, 1, " ")
  gpu.fill(54, 5, 1, 8, " ")
  gpu.fill(54, 12, 6, 1, " ")
  
  gpu.fill(144, 34, 7, 1, " ")
  gpu.fill(150, 4, 1, 30, " ")
  gpu.fill(44, 23, 6, 1, " ")
  gpu.fill(44, 4, 1, 20, " ")
  gpu.fill(44, 4, 107, 1, " ")
  
  gpu.fill(144, 28, 9, 1, " ")
  gpu.fill(152, 3, 1, 25, " ")
  gpu.fill(40, 32, 16, 1, " ")
  gpu.fill(40, 3, 1, 29, " ")
  gpu.fill(40, 3, 112, 1, " ")
  
  --address windows
  gpu.setBackground(palette.SLATE_LIGHT)
  gpu.setForeground(palette.TEXT_WHITE)
  for number = 1, 9 do
    local y = 7 + (number - 1) * 5
    gpu.setBackground(palette.SLATE_LIGHT)
    gpu.fill(130, y, 14, 3, " ")
    gpu.setBackground(palette.BACKGROUND)
    gpu.fill(131, y + 1, 12, 1, " ")
    gpu.set(129, y + 1, tostring(number))
  end
end

function graphics.fillGate(color)
  gpu.setBackground(color)
  gpu.fill(74, 12, 14, 1, " ")
  gpu.fill(70, 13, 22, 1, " ")
  gpu.fill(66, 14, 30, 1, " ")
  gpu.fill(64, 15, 34, 1, " ")
  gpu.fill(62, 16, 38, 2, " ")
  gpu.fill(60, 18, 42, 2, " ")
  gpu.fill(58, 20, 46, 7, " ")
  gpu.fill(60, 27, 42, 2, " ")
  gpu.fill(62, 29, 38, 2, " ")
  gpu.fill(64, 31, 34, 1, " ")
  gpu.fill(66, 32, 30, 1, " ")
  gpu.fill(70, 33, 22, 1, " ")
  gpu.fill(74, 34, 14, 1, " ")
  
  if color == palette.BACKGROUND then
    -- cross in the middle of gate graphic
    gpu.setBackground(palette.GREY_DARK)
    gpu.fill(80, 22, 2, 3, " ")
    gpu.fill(78, 23, 6, 1, " ")
  end
end

function graphics.drawIris()
  graphics.fillGate(palette.BLUE_DARK)
  gpu.setBackground(palette.BLUE_LIGHT)
  gpu.fill(80, 12, 2, 23, " ")
  gpu.fill(58, 23, 46, 1, " ")
  
  gpu.fill(82, 21, 2, 1, " ")
  gpu.fill(84, 20, 2, 1, " ")
  gpu.fill(86, 18, 2, 2, " ")
  gpu.fill(88, 16, 2, 2, " ")
  gpu.fill(90, 14, 2, 2, " ")
  
  gpu.fill(84, 22, 2, 1, " ")
  gpu.fill(86, 21, 2, 1, " ")
  gpu.fill(88, 20, 4, 1, " ")
  gpu.fill(92, 19, 4, 1, " ")
  gpu.fill(96, 18, 4, 1, " ")
  
  gpu.fill(84, 24, 2, 1, " ")
  gpu.fill(86, 25, 2, 1, " ")
  gpu.fill(88, 26, 4, 1, " ")
  gpu.fill(92, 27, 4, 1, " ")
  gpu.fill(96, 28, 4, 1, " ")
  
  gpu.fill(82, 25, 2, 1, " ")
  gpu.fill(84, 26, 2, 1, " ")
  gpu.fill(86, 27, 2, 2, " ")
  gpu.fill(88, 29, 2, 2, " ")
  gpu.fill(90, 31, 2, 2, " ")

  gpu.fill(78, 25, 2, 1, " ")
  gpu.fill(76, 26, 2, 1, " ")
  gpu.fill(74, 27, 2, 2, " ")
  gpu.fill(72, 29, 2, 2, " ")
  gpu.fill(70, 31, 2, 2, " ")
  
  gpu.fill(76, 24, 2, 1, " ")
  gpu.fill(74, 25, 2, 1, " ")
  gpu.fill(70, 26, 4, 1, " ")
  gpu.fill(66, 27, 4, 1, " ")
  gpu.fill(62, 28, 4, 1, " ")

  gpu.fill(76, 22, 2, 1, " ")
  gpu.fill(74, 21, 2, 1, " ")
  gpu.fill(70, 20, 4, 1, " ")
  gpu.fill(66, 19, 4, 1, " ")
  gpu.fill(62, 18, 4, 1, " ")

  gpu.fill(78, 21, 2, 1, " ")
  gpu.fill(76, 20, 2, 1, " ")
  gpu.fill(74, 18, 2, 2, " ")
  gpu.fill(72, 16, 2, 2, " ")
  gpu.fill(70, 14, 2, 2, " ")
end

local chevrons = {
  {100, 13}, {108, 23}, {104, 31}, {56, 31}, {52, 23},
  {60, 13}, {80, 9}, {90, 36}, {70, 36}
}

function graphics.drawChevron(number, symbol, color)
  local position = chevrons[number]
  if not position then return end
  gpu.setBackground(color)
  gpu.fill(position[1], position[2], 2, 1, " ")
  gpu.setBackground(palette.BACKGROUND)
  gpu.setForeground(palette.TEXT_WHITE)
  gpu.set(136, 8 + (number - 1) * 5, symbol)
end

local function drawHorizonLayer(radiusX, radiusY, color)
  gpu.setBackground(color)
  for dy = -radiusY, radiusY do
    local halfWidth = math.floor(radiusX * math.sqrt(1 - (dy / radiusY)^2))
    gpu.fill(81 - halfWidth, 23 + dy, 2 * halfWidth + 1, 1, " ")
  end
end

function graphics.drawWormhole()
  graphics.fillGate(palette.BLUE)
  drawHorizonLayer(19, 9, 0x277EA5)
  drawHorizonLayer(14, 7, 0x309ABC)
  drawHorizonLayer(8, 4, 0x55BBD2)
end

function graphics.emptyGate()
  graphics.fillGate(palette.BACKGROUND)
end

function graphics.drawStatusWindow()
  gpu.setBackground(palette.CYAN)
  gpu.fill(40, 40, 80, 9, " ")
  gpu.setBackground(palette.BACKGROUND)
  gpu.fill(40, 42, 80, 5, " ")
  gpu.fill(41, 41, 78, 1, " ")
  gpu.fill(41, 47, 78, 1, " ")
end

function graphics.drawStateMsg(state, direction)
  -- clear previous message
  gpu.setBackground(palette.BACKGROUND)
  gpu.fill(40, 42, 80, 5, " ")
  gpu.fill(41, 41, 78, 1, " ")
  gpu.fill(41, 47, 78, 1, " ")
  
  -- write message
  gpu.setBackground(palette.RED)
  if state == "Offline" then
    graphics.drawO(10)
    graphics.drawF(10+8)
    graphics.drawF(10+16)
    graphics.drawL(10+24)
    graphics.drawI(10+32)
    graphics.drawN(10+40)
    graphics.drawE(10+48)
  elseif state == "Idle" then
    graphics.drawI(23)
    graphics.drawD(23+8)
    graphics.drawL(23+16)
    graphics.drawE(23+24)
  elseif state == "Dialling" then
    graphics.drawD(5)
    graphics.drawI(5+8)
    graphics.drawA(5+16)
    graphics.drawL(5+24)
    graphics.drawL(5+32)
    graphics.drawI(5+40)
    graphics.drawN(5+48)
    graphics.drawG(5+56)
  elseif state == "Opening" then
    graphics.drawO(10)
    graphics.drawP(10+8)
    graphics.drawE(10+16)
    graphics.drawN(10+24)
    graphics.drawI(10+32)
    graphics.drawN(10+40)
    graphics.drawG(10+48)
  elseif state == "Connected" and direction == "Incoming" then
    graphics.drawI(4)
    graphics.drawN(4+8)
    graphics.drawC(4+16)
    graphics.drawO(4+24)
    graphics.drawM(4+32+1)
    graphics.drawI(4+40+2)
    graphics.drawN(4+48+2)
    graphics.drawG(4+56+2)
  elseif state == "Connected" and direction == "Outgoing" then
    graphics.drawC(2)
    graphics.drawO(2+8)
    graphics.drawN(2+16)
    graphics.drawN(2+24)
    graphics.drawE(2+32)
    graphics.drawC(2+40)
    graphics.drawT(2+48)
    graphics.drawE(2+56)
    graphics.drawD(2+64)
  elseif state == "Closing" then
    graphics.drawC(10)
    graphics.drawL(10+8)
    graphics.drawO(10+16)
    graphics.drawS(10+24)
    graphics.drawI(10+32)
    graphics.drawN(10+40)
    graphics.drawG(10+48)
  end
end

function graphics.drawRoute(label, status, ready)
  gpu.setBackground(palette.BACKGROUND)
  gpu.setForeground(palette.CYAN_LIGHT)
  gpu.fill(4, 45, 34, 1, " ")
  gpu.set(4, 45, label:sub(1, 34))
  gpu.setForeground(ready and palette.GREEN or palette.TEXT_WHITE)
  gpu.fill(4, 49, 34, 1, " ")
  gpu.set(4, 49, status:sub(1, 34))
end

function graphics.drawRemoteInfo(x, y, address, energy)
  gpu.setBackground(palette.CYAN)
  gpu.fill(x, y, 34, 9, " ")
  gpu.setBackground(palette.BACKGROUND)
  gpu.fill(x+1, y+3, 32, 5, " ")
  gpu.setBackground(palette.CYAN)
  gpu.setForeground(palette.TEXT_WHITE)
  gpu.set(x + math.floor((34 - #"REMOTE GATE DATA") / 2), y+1, "REMOTE GATE DATA")
  gpu.setBackground(palette.BACKGROUND)
  if address == nil or string.len(address) < 7 then
    gpu.set(x+2, y+4, "ADDRESS: INVALID")
  else
    gpu.set(x+2, y+4, "ADDRESS: " .. address)
  end
  
  if type(energy) ~= "number" then
    gpu.set(x+2, y+6, "ENERGY TO DIAL: N/A")
  else
    gpu.set(x+2, y+6, "ENERGY TO DIAL: " .. math.floor(energy + 0.5))
  end
  
end

function graphics.drawLocalGateInfo(x, y, address, energy, iris, err)
  gpu.setBackground(palette.CYAN)
  gpu.fill(x, y, 34, 11+7, " ")
  gpu.setBackground(palette.BACKGROUND)
  gpu.fill(x+1, y+3, 32, 7+7, " ")
  gpu.setBackground(palette.CYAN)
  gpu.setForeground(palette.TEXT_WHITE)
  gpu.set(x + math.floor((34 - #"LOCAL GATE DATA") / 2), y+1, "LOCAL GATE DATA")
  gpu.setBackground(palette.BACKGROUND)
  
  if not address or address == "" then
    gpu.set(x+2, y+4, "ADDRESS: UNKNOWN")
  else
    gpu.set(x+2, y+4, "ADDRESS: " .. address)
  end
  
  if type(energy) ~= "number" then
    gpu.set(x+2, y+6, "AVAILABLE ENERGY: N/A")
  else
    gpu.set(x+2, y+6, "AVAILABLE ENERGY: " .. math.floor(energy + 0.5))
  end
  
  if iris == nil then
    gpu.set(x+2, y+8, "IRIS STATE: UNKNOWN")
  else
    gpu.set(x+2, y+8, "IRIS STATE: " .. iris)
  end
  
  gpu.set(x+2, y+10, "LAST DIALLING ERROR:")
  gpu.fill(x+2, y+11, 31, 5, " ")
  if err == nil then
    gpu.setForeground(palette.GREEN)
    gpu.set(x+2, y+12, "None")
  else
    gpu.setForeground(palette.RED_DARK)
    err = tostring(err):gsub("%c", " ")
    for row = 0, 3 do
      local start = row * 30 + 1
      gpu.set(x + 2, y + 12 + row, err:sub(start, start + 29))
    end
    
  end
end

function graphics.drawA(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 44, 6, 1, " ")
  gpu.fill(47+offset, 42, 2, 5, " ")
end

function graphics.drawC(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
end

function graphics.drawD(offset)
  gpu.fill(43+offset, 42, 4, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 46, 4, 1, " ")
  gpu.fill(47+offset, 43, 2, 3, " ")
end

function graphics.drawE(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 44, 4, 1, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
end

function graphics.drawF(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 44, 4, 1, " ")
end

function graphics.drawG(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
  gpu.fill(47+offset, 42, 2, 2, " ")
  gpu.fill(46+offset, 45, 3, 2, " ")
end

function graphics.drawI(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(45+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
end

function graphics.drawL(offset)
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
end

function graphics.drawM(offset)
  gpu.fill(43+offset, 42, 2, 1, " ")
  gpu.fill(42+offset, 42, 2, 5, " ")
  gpu.fill(47+offset, 42, 2, 1, " ")
  gpu.fill(48+offset, 42, 2, 5, " ")
  gpu.fill(45+offset, 43, 2, 1, " ")
end

function graphics.drawN(offset)
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(47+offset, 42, 2, 5, " ")
  gpu.fill(45+offset, 43, 1, 1, " ")
  gpu.fill(45+offset, 44, 2, 1, " ")
  gpu.fill(46+offset, 45, 1, 1, " ")
end

function graphics.drawO(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
  gpu.fill(47+offset, 42, 2, 5, " ")
end

function graphics.drawP(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 5, " ")
  gpu.fill(43+offset, 44, 6, 1, " ")
  gpu.fill(47+offset, 42, 2, 3, " ")
end

function graphics.drawS(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(43+offset, 42, 2, 3, " ")
  gpu.fill(43+offset, 44, 6, 1, " ")
  gpu.fill(47+offset, 44, 2, 3, " ")
  gpu.fill(43+offset, 46, 6, 1, " ")
end

function graphics.drawT(offset)
  gpu.fill(43+offset, 42, 6, 1, " ")
  gpu.fill(45+offset, 42, 2, 5, " ")
end

return graphics

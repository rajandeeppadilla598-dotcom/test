local component = require("component")
local unicode = require("unicode")
local palette = require("src/palette")
local classes = require("src/classes")

local gpu = component.gpu

local Button = classes.class()

function Button:init(x, y, w, h, label, bg, fg)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.label = label
  self.bg = bg
  self.fg = fg
  self.locked = false
end

function Button:draw()
  if self.locked then
    gpu.setBackground(palette.GREY)
    gpu.setForeground(palette.GREY_LIGHT)
  else
    gpu.setBackground(self.bg)
    gpu.setForeground(self.fg)
  end
  
  gpu.fill(self.x, self.y, self.w, self.h, " ")
  gpu.set(self.x + math.floor((self.w - unicode.len(self.label)) / 2), self.y + math.floor(self.h / 2), self.label)
end

function Button:update(label, bg, locked)
  if self.drawn and self.label == label and self.bg == bg and self.locked == locked then
    return
  end
  self.label, self.bg, self.locked = label, bg, locked
  self:draw()
  self.drawn = true
end

function Button:clicked(x, y)
  if not x or not y then
    return false
  end
  if self.locked then
    return false
  end
  if x >= self.x and x < (self.x + self.w) and y >= self.y and y < (self.y + self.h) then
    return true
  else
    return false
  end
end

return Button

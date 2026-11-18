local component = require("component")
local unicode = require("unicode")
local classes = require("src/classes")
local palette = require("src/palette")

local gpu = component.gpu
local AddressField = classes.class()

function AddressField:init(x, y, w, h, bg, fg, textBg)
  self.x, self.y, self.w, self.h = x, y, w, h
  self.bg, self.fg, self.textBg = bg, fg, textBg
  self.address = ""
end

function AddressField:draw()
  local address = self.draft or self.address
  local text = address:sub(1, 4)
  if #address > 4 then
    text = text .. "-" .. address:sub(5, 7)
  end
  if #address > 7 then
    text = text .. "-" .. address:sub(8)
  end
  if self.draft then
    text = text .. "_"
  elseif text == "" then
    text = "ВВЕДИТЕ АДРЕС"
  end

  gpu.setBackground(self.draft and palette.CYAN or self.bg)
  gpu.fill(self.x, self.y, self.w, self.h, " ")
  gpu.setBackground(self.textBg)
  gpu.fill(self.x + 1, self.y + 1, self.w - 2, self.h - 2, " ")
  gpu.setForeground(address == "" and not self.draft and palette.GREY_LIGHT or self.fg)
  gpu.set(self.x + math.floor((self.w - unicode.len(text)) / 2),
    self.y + math.floor(self.h / 2), text)
end

function AddressField:clicked(x, y)
  return x >= self.x and x < self.x + self.w
    and y >= self.y and y < self.y + self.h
end

function AddressField:startEditing()
  if not self.draft then
    self.draft = ""
    self:draw()
  end
end

function AddressField:insert(text)
  self.draft = (self.draft .. text:upper():gsub("[^A-Z0-9]", "")):sub(1, 9)
  self:draw()
end

function AddressField:keyDown(char, code)
  if code == 1 then
    self.draft = nil
  elseif char == 13 then
    self.address = self.draft
    self.draft = nil
  elseif char == 8 then
    self.draft = self.draft:sub(1, -2)
  elseif char >= 32 and char <= 126 then
    self:insert(string.char(char))
    return
  else
    return
  end
  self:draw()
end

function AddressField.normalize(address)
  return type(address) == "string" and address:upper():gsub("[%s%-]", "") or ""
end

function AddressField.valid(address)
  return #address >= 7 and #address <= 9 and address:match("^[A-Z0-9]+$") ~= nil
end

function AddressField:isValid()
  return AddressField.valid(self.address)
end

return AddressField

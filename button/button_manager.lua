local indexof = function (array, target)
  for k,v in ipairs(array) do
    if v == target then 
      return k
    end
  end
  return -1
end

local remove_first = function (array, target)
  local i = indexof(array, target)
  if i ~= -1 then
    table.remove(array, i)
  end
end

local btn_set_x = function(self, x)
  self.x = x
end

local btn_set_y = function(self, y)
  self.y = y
end

local btn_set_width = function(self, width)
  self.width = width
end

local btn_set_height = function(self, height)
  self.height = height
end

local btn_set_font = function(self, font)
  self.font = font
end

local btn_set_font_color = function(self, font_color)
  self.font_color = font_color
end

local btn_set_outline_width = function(self, outline_width)
  self.outline_width = outline_width
end

local btn_set_outline_color = function(self, outline_color)
  self.outline_color = outline_color
end

local btn_set_color = function(self, color)
  self.color = color
end

local btn_set_text = function(self, text)
  self.text = text
end

local btn_set_onclick = function(self, onclick)
  self.onclick = onclick
end

local btn_draw = function(self)
  local oldfont = love.graphics.getFont()
  local oldr, oldg, oldb, olda = love.graphics.getColor()
  print(oldcolor)
  local oldlinewidth = love.graphics.getLineWidth()

  love.graphics.setFont(self.font)
  love.graphics.setColor(self.color)
  love.graphics.setLineWidth(self.outline_width)

  local corex = self.x + (self.outline_width)
  local corey = self.y + (self.outline_width)
  local corew = self.width - (self.outline_width)
  local coreh = self.height - (self.outline_width)
  love.graphics.rectangle("fill", corex, corey, corew, coreh)
  
  love.graphics.setColor(self.font_color)
  love.graphics.printf(self.text, corex, corey, corew, "center")
  
  love.graphics.setColor(self.outline_color)
  local outx = self.x + .5 * self.outline_width
  local outy = self.y + .5 * self.outline_width

  love.graphics.rectangle("line", outx, outy, self.width, self.height)

  love.graphics.setFont(oldfont)
  love.graphics.setColor(oldr, oldg, oldb, olda)
  love.graphics.setLineWidth(oldlinewidth)
end

local default_font = love.graphics.newFont("assets/font/kenvector_future_thin.ttf",.02*love.graphics.getWidth())
local default_outline_color = {20,20,20}
local default_color = {220,220,220}
local default_font_color = {0,0,0}
local default_text = "PRESS ME"

local new_mgr = function()
  local mgr = {}
  mgr.buttons = {}

  local btn_remove = function(self)
    remove_first(mgr.buttons, self)
  end

  mgr.new_button = function(self, options)
    options = options or {}
    local btn = {}
    btn.set_x = btn_set_x
    btn.set_y = btn_set_y
    btn.set_width = btn_set_width
    btn.set_height = btn_set_height
    btn.set_font = btn_set_font
    btn.set_font_color = btn_set_font_color
    btn.set_outline_width = btn_set_outline_width
    btn.set_outline_color = btn_set_outline_color
    btn.set_color = btn_set_color
    btn.set_text = btn_set_text
    btn.set_onclick = btn_set_onclick

    btn.draw = btn_draw
    btn.remove = btn_remove

    btn.x = options.x or 0
    btn.y = options.y or 0
    btn.width = options.width or 100
    btn.height = options.height or 100
    btn.font = options.font or default_font
    btn.font_color = options.font_color or default_font_color
    btn.outline_width = options.outline_width or 2
    btn.outline_color = options.outline_color or default_outline_color
    btn.color = options.color or default_color
    btn.text = options.text or default_text
    btn.onclick = options.onclick

    table.insert(self.buttons, btn)
    return btn
  end

  mgr.draw = function(self)
    for _,b in ipairs(self.buttons) do
      b:draw()
    end
  end

  mgr.mousepressed = function(self, x, y, code)
    for _,b in ipairs(self.buttons) do
      b:mousepressed(x, y, code)
    end
  end

  return mgr

end

return new_mgr
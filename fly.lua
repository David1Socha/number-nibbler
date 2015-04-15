
function new_fly(col, row, box_size)
  local c = math.random(2) == 1
  local fly = {
    score = 1,
    scale = 1,
    row = row,
    col = col,
    correct = c,
    font = love.graphics.newFont(10),
    text = tostring(c),
    text_off = vector(-10, 50),
    img = love.graphics.newImage "assets/image/fly.png",
  }

  fly.offx = (box_size - fly.img:getWidth() * fly.scale) / 2
  fly.offy = 0

  function fly:draw(box_size) 
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.font)
    rowcol_scaled = vector(self.row, self.col) * box_size + vector(self.offx, self.offy)
    love.graphics.draw(self.img, rowcol_scaled.x, rowcol_scaled.y, 0, self.scale, self.scale)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, rowcol_scaled.x + self.text_off.x, rowcol_scaled.y + self.text_off.y, self.img:getWidth(), "center")
  end

  return fly
end

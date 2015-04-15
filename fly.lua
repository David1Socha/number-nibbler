function new_fly(box_size)
  local fly = {
    score = 1,
    scale = .9,
    correct = true,
    font = love.graphics.newFont(10),
    text = "5 + 5 + 5",
    text_off = vector(-20, 46),
    img = love.graphics.newImage "assets/image/fly.png",
  }

  fly.offx = (box_size - fly.img:getWidth() * fly.scale) / 2
  fly.offy = 0

  function fly:draw(row, col, box_size) 
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(self.font)
    rowcol_scaled = vector(row, col) * box_size + vector(self.offx, self.offy)
    love.graphics.draw(self.img, rowcol_scaled.x, rowcol_scaled.y, 0, self.scale, self.scale)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(self.text, rowcol_scaled.x + self.text_off.x, rowcol_scaled.y + self.text_off.y, self.img:getWidth(), "center")
  end

  return fly
end

function new_lilypad(box_size, offx)
  local lilypad = {
    scale = .7,
    box_size = box_size,
    img = love.graphics.newImage "assets/image/lilypad.png",
  }

  lilypad.offx = (box_size - lilypad.img:getWidth() * lilypad.scale) / 2 + offx
  lilypad.offy = (box_size - lilypad.img:getHeight() * lilypad.scale)

  function lilypad:draw(row, col) 
    love.graphics.setColor(255, 255, 255)
    rowcol_scaled = vector(row, col) * self.box_size + vector(self.offx, self.offy)
    love.graphics.draw(self.img, rowcol_scaled.x, rowcol_scaled.y, 0, self.scale, self.scale)
  end

  return lilypad
end

function new_node()
  local node = {
    score = 1,
    correct = true,
    img = love.graphics.newImage "assets/image/lilypad.png",
  }

  function node:draw(row, col, scale) 
    rowcol_scaled = vector(row, col) * scale
    love.graphics.draw(self.img, rowcol_scaled.x, rowcol_scaled.y, 0, .5, .5)
  end

  return node
end

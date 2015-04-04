function new_node(box_size)
  local node = {
    score = 1,
    scale = .9,
    correct = true,
    img = love.graphics.newImage "assets/image/lilypad.png",
  }

  node.offx = (box_size - node.img:getWidth() * node.scale) / 2
  node.offy = (box_size - node.img:getHeight() * node.scale)

  function node:draw(row, col, box_size) 
    love.graphics.setColor(255, 255, 255)
    rowcol_scaled = vector(row, col) * box_size + vector(self.offx, self.offy)
    love.graphics.draw(self.img, rowcol_scaled.x, rowcol_scaled.y, 0, self.scale, self.scale)
  end

  return node
end

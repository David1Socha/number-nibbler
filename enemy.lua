function new_enemy(pos,box_size, offx,grid_units,num)

  num = num or math.random(1,4)
  local enemy = {
    pos = pos,
    act = pos,
    dest = pos,
    time_moving = 0,
    box_size = box_size,
    movetime = 1,
    scale = .69,
    tweening = false,
    img = love.graphics.newImage("assets/image/gator_"..num..".png")
  }

  local enemy_offx = (box_size - enemy.img:getWidth() * enemy.scale) / 2 + offx
  local enemy_offy = (box_size - enemy.img:getHeight() * enemy.scale) - enemy.img:getHeight() / 20
  enemy.off = vector(enemy_offx, enemy_offy)

  function enemy:draw()
    local scaled_act = self.act * self.box_size + vector(self.off.x, self.off.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.img, scaled_act.x, scaled_act.y, 0, self.scale, self.scale)
  end

  return enemy

end
function new_enemy(pos,box_size, offx,grid_units,num)

  num = num or math.random(1,4)
  local enemy = {
    pos = pos,
    act = pos,
    dest = pos,
    grid_units = grid_units,
    since_moved = 0,
    move_wait = 1.8,
    box_size = box_size,
    movetime = .8,
    scale = .6,
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

  function enemy:update(dt)
    self.since_moved = self.since_moved + dt
    if self.since_moved >= self.move_wait then
      self.since_moved = self.since_moved - self.move_wait
      local new_pos = self.pos + self:get_random_delta()
      local tween_duration = self.movetime
      Timer.tween(tween_duration, self.act, new_pos, 'linear')
      self.pos = new_pos
    end
  end

  function enemy:get_random_delta()
    local deltas = self:get_delta_vectors()
    local delta = deltas[math.random(#deltas)]
    return delta
  end

  function enemy:get_delta_vectors()
    local possibilities = {}
    local x_deltas = get_deltas(self.pos.x,self.grid_units)
    local y_deltas = get_deltas(self.pos.y,self.grid_units)
    for k,v in pairs(x_deltas) do
      for k2,v2 in pairs(y_deltas) do
        local vec = vector(v,v2)
        table.insert(possibilities,vec)
      end
    end
    possibilities = remove_empty_delta(possibilities)
    return possibilities
  end

  function get_deltas(pos,max)
    local deltas = {0}
    if (pos - 1) >= 0 then
      table.insert(deltas,-1)
    end
    if (pos + 1) <= max then
      table.insert(deltas,1)
    end
    return deltas
  end

  function remove_empty_delta(deltas)
    local empty = vector(0,0)
    for i=#deltas,1,-1 do
      local v = deltas[i]
      if v == empty then
        table.remove(deltas,i)
      end
    end
    return deltas
  end

  return enemy

end
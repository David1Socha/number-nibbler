vector = require "hump.vector"

function new_player(max_x_or_y, box_size)
  local player = {
    pos = vector(0, 0),
    color = {0x00, 0xff, 0x00},
    dest = vector(0, 0),
    time_moving = 0,
    movetime = .2,
    size = box_size / 2
  }

  function player:update(dt)
    self.time_moving = self.time_moving + dt
    if self.time_moving > self.movetime then
      self.time_moving = self.time_moving - self.movetime
      local old_pos = self.pos
      self.pos = move_closer_vector(self.pos, self.dest, 1)
    end
  end

  function player:draw(scale)
    love.graphics.setColor(self.color)
    local offset = (self.size / 2)
    scaled_pos = self.pos * scale + vector(offset, offset)
    love.graphics.rectangle("fill", scaled_pos.x, scaled_pos.y, self.size, self.size)
  end

  return player
end

function move_closer_vector(current, dest, step)
  local new = vector()
  new.x = move_closer(current.x, dest.x, step)
  new.y = move_closer(current.y, dest.y, step)
  return new
end

function move_closer(current, dest, step)
  local new
  if current > dest then
    new = math.max(current - step, dest)
  elseif current < dest then
    new = math.min(current + step, dest)
  else
    new = current
  end
  return new
end
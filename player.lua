
function new_player(max_x_or_y, box_size)
  local player = {
    pos = vector(0, 0),
    act = vector(0.0, 0.0),
    color = {0x00, 0xff, 0x00},
    dest = vector(0, 0),
    time_moving = 0,
    movetime = .5,
    tweening = false,
    imgs = { 
      rest = love.graphics.newImage "assets/image/froggy.png",
      eat1 = love.graphics.newImage "assets/image/frog_tongue_1.png",
      eat2 = love.graphics.newImage "assets/image/frog_tongue_2.png"
    }
  }

  player.offx = (box_size - player.imgs.rest:getWidth() / 2) / 2
  player.offy = (box_size - player.imgs.rest:getHeight() / 2)

  function player:update(dt)
    self.time_moving = self.time_moving + dt
    if self.time_moving > self.movetime then
      self.time_moving = self.time_moving - self.movetime
      local new_pos = move_closer_vector(self.pos, self.dest, 1)
      local tween_duration = self.movetime - self.time_moving
      if not neareq_vec(self.act, new_pos) and not player.tweening then
        player.tweening = true
        Timer.tween(tween_duration, self.act, new_pos, 'linear', function() player.tweening = false end)
      end
      self.pos = new_pos
    end
  end

  function player:draw(scale)
    love.graphics.setColor(self.color)
    scaled_act = self.act * scale + vector(self.offx, self.offy)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.imgs.rest, scaled_act.x, scaled_act.y, 0, .5, .5)
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
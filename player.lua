
function new_player(max_x_or_y, box_size, offx)
  local player = {
    pos = vector(0, 0),
    act = vector(0.0, 0.0),
    dest = vector(0, 0),
    time_moving = 0,
    box_size = box_size,
    movetime = .5,
    scale = .69,
    tweening = false,
    move_sound = love.audio.newSource("assets/sound/player_movement.ogg", "static"),
    anim_eat = {s2 = game.select_cd / 2, s3 = game.select_cd},
    defeated = false,
    imgs = { 
      rest = love.graphics.newImage "assets/image/froggy.png",
      eat1 = love.graphics.newImage "assets/image/frog_tongue_1.png",
      eat2 = love.graphics.newImage "assets/image/frog_tongue_2.png",
      rip = love.graphics.newImage "assets/image/frog_rip.png"
    }
  }

  player.imgs.curr = player.imgs.rest
  player_offx = (box_size - player.imgs.rest:getWidth() * player.scale) / 2 + offx
  player_offy = (box_size - player.imgs.rest:getHeight() * player.scale) - player.imgs.rest:getHeight() / 20
  player.off = vector(player_offx, player_offy)

  function player:update(dt)
    if self.defeated then
      self.imgs.curr = self.imgs.rip
    elseif self.anim_eat.active then
      self:update_anim_eat(dt)
    end

    self.time_moving = self.time_moving + dt
    if self.time_moving > self.movetime then
      self.time_moving = self.time_moving - self.movetime
      local new_pos = move_closer_vector(self.pos, self.dest, 1)
      local tween_duration = self.movetime - self.time_moving
      if not neareq_vec(self.act, new_pos) and not self.tweening then
        self.tweening = true
        love.audio.play(self.move_sound)
        Timer.tween(tween_duration, self.act, new_pos, 'linear', function() self.tweening = false end)
      end
      self.pos = new_pos
    end
  end

  function player:update_anim_eat(dt)
    self.anim_eat.elapsed = self.anim_eat.elapsed + dt
    if self.anim_eat.elapsed > self.anim_eat.s3 then --animation done
      self.imgs.curr = self.imgs.rest
      self.anim_eat.active = false
    elseif self.anim_eat.elapsed > self.anim_eat.s2 then -- in 2nd stage of animation
      self.imgs.curr = self.imgs.eat2
    end
  end

  function player:draw()
    scaled_act = self.act * self.box_size + vector(self.off.x, self.off.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.imgs.curr, scaled_act.x, scaled_act.y, 0, self.scale, self.scale)
  end

  function player:start_anim_eat()
    player.anim_eat.active = true
    player.anim_eat.elapsed = 0
    player.imgs.curr = player.imgs.eat1
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
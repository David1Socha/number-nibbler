
function new_player(box_size)
  local player = {
    pos = vector(0, 0),
    act = vector(0.0, 0.0),
    dest = vector(0, 0),
    can_move = true,
    box_size = box_size,
    movetime = .5,
    scale = .000351*love.window.getWidth(),
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
  local player_offx = (box_size - player.imgs.rest:getWidth() * player.scale) / 2 + game.offx
  local player_offy = (box_size - player.imgs.rest:getHeight() * player.scale) - (player.imgs.rest:getHeight() * player.scale) / 8
  player.off = vector(player_offx, player_offy)

  function player:move(dest)
    if not self.can_move then return end
    if (self.pos ~= dest and not self.tweening and game.active) then
      self.dest = dest
      self.tweening = true
      local new_pos = move_closer_vector(self.pos, self.dest, 1)
      love.audio.play(self.move_sound)
      Timer.tween(self.movetime, self.act, new_pos, 'linear', function()
        self.pos = new_pos
        self.tweening = false
        self:move(dest)
      end)
    end
  end

  function player:update(dt)
    if self.defeated then
      self.imgs.curr = self.imgs.rip
      return
    elseif self.anim_eat.active then
      self:update_anim_eat(dt)
    end
  end

  function player:update_anim_eat(dt)
    self.anim_eat.elapsed = self.anim_eat.elapsed + dt
    if self.anim_eat.elapsed > self.anim_eat.s3 then --animation done
      self.imgs.curr = self.imgs.rest
      self.anim_eat.active = false
      self.can_move = true
    elseif self.anim_eat.elapsed > self.anim_eat.s2 then -- in 2nd stage of animation
      self.imgs.curr = self.imgs.eat2
    end
  end

  function player:draw()
    local scaled_act = self.act * self.box_size + vector(self.off.x, self.off.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.imgs.curr, scaled_act.x, scaled_act.y, 0, self.scale, self.scale)
  end

  function player:start_eat()
    self.can_move = false
    self.anim_eat.active = true
    self.anim_eat.elapsed = 0
    self.imgs.curr = self.imgs.eat1
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
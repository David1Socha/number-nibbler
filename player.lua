function new_player(max_x_or_y)
  local _player = {
    x = 0,
    color = {0x00, 0xff, 0x00},
    y = 0,
    dx = 0,
    dy = 0,
    time_moving = 0,
    movetime = .2,
    size = 64
  }

  local player_newindex = function (table, key, value)
    if (key == "x" or key == "y") then
      _player[key] = math.max(0, math.min(value, max_x_or_y))
    else
      _player[key] = value
    end
  end

  local player_index = function (table, key)
    return _player[key]
  end

  local player_meta = {
    __newindex = player_newindex,
    __index = player_index
  }

  local Player = setmetatable({}, player_meta)

  function Player:update(dt)
    self.time_moving = self.time_moving + dt
    if self.time_moving > self.movetime then
      self.time_moving = self.time_moving - self.movetime
      self.x = move_closer(self.x, self.dx, 1)
      self.y = move_closer(self.y, self.dy, 1)
    end
  end

  function Player:draw(scale)
    love.graphics.setColor(_player.color)
    love.graphics.rectangle("fill", (_player.x * scale) + _player.size / 2, (_player.y * scale) + _player.size / 2, _player.size, _player.size)
  end

  return Player
end

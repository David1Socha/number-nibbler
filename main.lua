function love.load()
  scale = 64
  grid_size = 4
  player = build_player()
  select = love.audio.newSource("assets/select.ogg", "static")
end

function love.update(dt)
  player.time_moving = player.time_moving + dt
  if player.time_moving > player.movetime then
    player.time_moving = player.time_moving - player.movetime
    player.x = move_closer(player.x, player.dx, 1)
    player.y = move_closer(player.y, player.dy, 1)
  end
end

function love.mousepressed(x, y, button)
  local grid_x = math.floor(x / scale)
  local grid_y = math.floor(y / scale)

  if grid_y == player.y and grid_x == player.x then
    choose_square()
  end
  player.dy = grid_y
  player.dx = grid_x
end

function love.draw()
  --love.graphics.printf(msg, 100, 100, 100)
  love.graphics.rectangle("fill", (player.x * scale) + player.size / 2, (player.y * scale) + player.size / 2, player.size, player.size)
end

function move_closer(current, dest, step)
  local new = nil
  if current > dest then
    new = math.max(current - step, dest)
  else
    new = math.min(current + step, dest)
  end
  return new
end

function choose_square()
  love.audio.play(select)
end

function build_player()
  local _player = {
    x = 0,
    y = 0,
    dx = 0,
    dy = 0,
    time_moving = 0,
    movetime = .2,
    size = 32
  }

  player_newindex = function (table, key, value)
    if (key == "x" or key == "y") then
      _player[key] = math.max(0, math.min(value, grid_size))
    else
      _player[key] = value
    end
  end

  player_index = function (table, key)
    return _player[key]
  end

  player_meta = {
    __newindex = player_newindex,
    __index = player_index
  }

  return setmetatable({}, player_meta)
end
function love.load()
  scale = 64
  grid_size = 4
  player = build_player()
  select = love.audio.newSource("select.ogg", "static")
end

function love.update(dt)

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
  love.graphics.rectangle("fill", (player.x * scale) + player.size / 2, (player.y * scale) + player.size / 2, player.size, player.size)
end

function choose_square()
  love.audio.play(select)
end

function build_player()
  local _player = {
    x = 0,
    y = 0,
    speed = 10,
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
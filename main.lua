require("player")
require("menu")
require("node")

function love.load()
  menu.load()
  phase = "menu"
  scale = 128
  plain_font = love.graphics.newFont(20)
  grid_units = 4
  grid = {}
  for i=0,grid_units do
    grid[i] = {}
    for j=0,grid_units do
      grid[i][j] = new_node()
    end
  end
  bg = {0x33, 0xff, 0xff}
  player = new_player(grid_units)
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
  if (phase == "menu") then
    menu.mousepressed()
  else
    local grid_x = math.floor(x / scale)
    local grid_y = math.floor(y / scale)

    if grid_y == player.y and grid_x == player.x then
      choose_square()
    end
    player.dy = grid_y
    player.dx = grid_x
  end
end

function love.draw()
  if phase == "menu" then
    menu.draw()
  else
    love.graphics.setFont(plain_font)
    love.graphics.setBackgroundColor(bg)
    --love.graphics.printf(msg, 100, 100, 100)
    player:draw(scale)
  end
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
  player.score = player.score + grid[player.y][player.x].score
  love.audio.play(select)
end


require("player")
require("node")

game = {}

function game.load()
  game.grid_units = 4
  game.grid = {}
  for i=0,game.grid_units do
    game.grid[i] = {}
    for j=0,game.grid_units do
      game.grid[i][j] = new_node()
    end
  end
  game.grid[0][0].correct = false
  game.score = 0
  game.bg = {0x33, 0xff, 0xff}
  game.grid_box_size = love.graphics.getHeight() / (game.grid_units + 1)
  game.player = new_player(game.grid_units, game.grid_box_size)
  game.plain_font = love.graphics.newFont(20)
  game.select = love.audio.newSource("assets/select.ogg", "static")
end


function game.update(dt)
  game.player.time_moving = game.player.time_moving + dt
  if game.player.time_moving > game.player.movetime then
    game.player.time_moving = game.player.time_moving - game.player.movetime
    game.player.x = move_closer(game.player.x, game.player.dx, 1)
    game.player.y = move_closer(game.player.y, game.player.dy, 1)
  end
end

function game.draw()
  love.graphics.setFont(game.plain_font)
  love.graphics.setBackgroundColor(game.bg)
  --love.graphics.printf(msg, 100, 100, 100)
  game.player:draw(game.grid_box_size)
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Score: "..game.score, 0, love.graphics.getHeight() - game.plain_font:getHeight(), love.graphics.getWidth(), "center")
end

function game.mousepressed(x, y, grid)
  local grid_x = math.floor(x / game.grid_box_size)
  local grid_y = math.floor(y / game.grid_box_size)

  if grid_y == game.player.y and grid_x == game.player.x then
    choose_square()
  end
  game.player.dy = grid_y
  game.player.dx = grid_x
end

function choose_square()
  local curr_node = game.grid[game.player.y][game.player.x]
  if not curr_node.correct then
    phase = "menu"
  else
    game.score = game.score + curr_node.score
    love.audio.play(game.select)
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